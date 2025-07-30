#!/data/data/com.termux/files/usr/bin/bash

INPUT_DIR="input"
OUTPUT_DIR="signed_batch"
ARCHIVE_NAME="batch_signed.zip"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="telegram_log.txt"
TELEGRAM_BOT_TOKEN="8268505716:AAHGzrsueN2S_JTM6NOsI_9ezHLyc4kCp_o"
TELEGRAM_CHAT_ID="1838691511"

mkdir -p "$OUTPUT_DIR"

FILES=$(find "$INPUT_DIR" -type f)
if [ -z "$FILES" ]; then
  echo "❌ لا توجد ملفات داخل '$INPUT_DIR' للتوقيع الجماعي"
  echo "[${TIMESTAMP}] ❌ فشل التوقيع الجماعي: لا يوجد ملفات" >> "$LOG_FILE"
  exit 1
fi

echo "🔁 بدء التوقيع الجماعي لجميع الملفات..."
for FILE in $FILES; do
  SIGNED_FILE="$OUTPUT_DIR/signed_$(basename "$FILE")"
  gpg --output "$SIGNED_FILE" --sign "$FILE"

  if [ $? -ne 0 ]; then
    echo "❌ فشل توقيع الملف: $(basename "$FILE")"
    echo "[${TIMESTAMP}] ⚠️ فشل توقيع: $(basename "$FILE")" >> "$LOG_FILE"
  else
    echo "[${TIMESTAMP}] ✅ تم توقيع: $(basename "$FILE")" >> "$LOG_FILE"
  fi
done

zip -q -r "$ARCHIVE_NAME" "$OUTPUT_DIR"

MESSAGE="🔐 Dreem Fortress™ توقيع جماعي
📦 الملفات الموقعة أرشفت في: \`$ARCHIVE_NAME\`
📂 المصدر: \`$INPUT_DIR\`
📅 الوقت: \`$TIMESTAMP\`
🧾 عدد الملفات: $(ls "$OUTPUT_DIR" | wc -l)"

RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d chat_id="${TELEGRAM_CHAT_ID}" \
  -d text="$MESSAGE" \
  -d parse_mode="Markdown")

echo "📤 Telegram: حالة الإرسال = $(echo "$RESPONSE" | grep '"ok":true' >/dev/null && echo "ناجح ✅" || echo "فشل ❌")"
