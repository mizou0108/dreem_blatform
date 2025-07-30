#!/data/data/com.termux/files/usr/bin/bash

# ⚙️ الإعدادات
BOT_TOKEN="ضع هنا رمز البوت"
CHAT_ID="ضع هنا معرف المحادثة"
SIGN_DIR="input"
ARCHIVE_DIR="signed"
ZIP_OUTPUT="dreem_backup_$(date +%Y%m%d_%H%M).zip"
LOG_FILE="telegram_log.txt"
JSON_FILE="signatures.json"
REPORT_FILE="summary.php"

mkdir -p "$SIGN_DIR" "$ARCHIVE_DIR"
touch "$LOG_FILE"
[ -f "$JSON_FILE" ] || echo "[]" > "$JSON_FILE"

# 📲 إرسال إلى Telegram
send_telegram() {
  local msg="$1"
  curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage \
    -d chat_id="$CHAT_ID" \
    -d text="$msg" \
    -d parse_mode="MarkdownV2" >> "$LOG_FILE"
}

# 🧼 تنقية الرسائل
sanitize_message() {
  echo "$1" | sed -e 's/\\/\\\\/g' -e 's/\*/\\*/g' -e 's/_/\\_/g' \
    -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/(/\\(/g' -e 's/)/\\)/g' \
    -e 's/\`/\\\`/g' -e 's/#/\\#/g' -e 's/\+/\\+/g' -e 's/\-/\\-/g' \
    -e 's/\=/\\=/g' -e 's/\!/\\!/g' -e 's/>/\\>/g'
}

# 🛡️ التحقق من الملف
check_file_safety() {
  local path="$1"
  local name="$(basename "$path")"
  [ ! -f "$path" ] && echo "❌ $name غير موجود" && return 1
  [ ! -s "$path" ] && echo "❌ $name فارغ" && return 1
  [[ "$name" =~ [^a-zA-Z0-9._\-] ]] && echo "❌ اسم غير آمن: $name" && return 1
  return 0
}

# 🔁 منع التكرار
check_duplicate() {
  local sig="$1"
  grep -q "$sig" "$LOG_FILE" && return 1 || return 0
}

# 🧾 حفظ JSON قانوني
save_json_signature() {
  local file="$1"
  local signature="$2"
  local timestamp="$3"
  jq --arg file "$file" \
     --arg signature "$signature" \
     --arg timestamp "$timestamp" \
     '. += [{"file": $file, "signature": $signature, "timestamp": $timestamp}]' \
     "$JSON_FILE" > tmp.json && mv tmp.json "$JSON_FILE"
}

# 🔍 بدء التوقيع
echo "⚙️ بدء Dreem Fortress™..." | tee -a "$LOG_FILE"
for file in "$SIGN_DIR"/*.txt; do
  filename=$(basename "$file")
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  check_file_safety "$file" || { echo "🚫 تجاهل $filename" >> "$LOG_FILE"; continue; }

  signature=$(sha256sum "$file" | cut -d ' ' -f1)
  check_duplicate "$signature" || { echo "🌀 مكرر: $filename" >> "$LOG_FILE"; continue; }

  cp "$file" "$ARCHIVE_DIR/$filename"
  save_json_signature "$filename" "$signature" "$timestamp"

  raw="📁 توقيع *$filename*
🔐 البصمة: \`$signature\`
🕒 الزمن: $timestamp"
  msg=$(sanitize_message "$raw")
  send_telegram "$msg"

  echo "[$timestamp] ✅ $filename | $signature" >> "$LOG_FILE"
done

# 📦 ضغط الملفات المؤرشفة
zip -r "$ZIP_OUTPUT" "$ARCHIVE_DIR" > /dev/null
echo "🎯 تم إنشاء نسخة مضغوطة: $ZIP_OUTPUT" | tee -a "$LOG_FILE"

# 📊 توليد واجهة summary.php
cat > "$REPORT_FILE" <<EOF
<?php
\$signatures = json_decode(file_get_contents('$JSON_FILE'), true);
echo "<!DOCTYPE html><html><head><meta charset='UTF-8'>
<title>Dreem Fortress™ - سجل التواقيع</title>
<style>
body{font-family:Arial;background:#f2f2f2;padding:20px}
h1{text-align:center}table{width:100%;border-collapse:collapse;margin-top:20px}
th,td{border:1px solid #ccc;padding:8px;text-align:left}
th{background:#333;color:white}tr:nth-child(even){background:#f9f9f9}
</style></head><body>";
echo "<h1>Dreem Fortress™ - سجل التواقيع</h1><table><tr>
<th>#</th><th>الملف</th><th>البصمة</th><th>الزمن</th></tr>";
foreach (\$signatures as \$i => \$e) {
echo "<tr><td>".(\$i+1)."</td><td>".htmlspecialchars(\$e['file'])."</td>
<td><code>".htmlspecialchars(\$e['signature'])."</code></td>
<td>".htmlspecialchars(\$e['timestamp'])."</td></tr>";}
echo "</table></body></html>";
?>
EOF

echo "✅ Dreem Fortress™ اكتملت بنجاح وواجهة summary.php جاهزة 🎉"
