
#!/data/data/com.termux/files/usr/bin/bash
source ./chat_config.sh
BOT_TOKEN="8268505716:AAHGzrsueN2S_JTM6NOsI_9ezHLyc4kCp_o"
LOG_FILE="telegram_log.txt"
offset=0

while true; do
  updates=$(curl -s "https://api.telegram.org/bot$BOT_TOKEN/getUpdates?offset=$offset")
  messages=$(echo "$updates" | jq -c '.result[]')

  for msg in $messages; do
    update_id=$(echo "$msg" | jq '.update_id')
    chat_id=$(echo "$msg" | jq -r '.message.chat.id')
    text=$(echo "$msg" | jq -r '.message.text')

    echo "[BOT] تلقي أمر: $text" >> "$LOG_FILE"

    case "$text" in
      "/start")
        reply="🤖 أهلاً بك في Dreem Fortress™ Bot!
المتوفر:
/sign – توقيع الملفات الآن
/summary – آخر التواقيع
/report – إرسال التقرير المضغوط
/control – تشغيل لوحة Dreem"
        ;;
      "/sign")
        bash dreem_fortress.sh
        reply="⚙️ تم تنفيذ جلسة توقيع كاملة داخل Dreem Fortress™ ✅"
        ;;
      "/summary")
        last=$(jq -r '.[-5:] | .[] | "*\(.file)* في \(.timestamp)"' signatures.json | paste -sd '\n' -)
        reply="📋 آخر التواقيع:\n$last"
        ;;
      "/report")
        curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
          -F chat_id="$chat_id" \
          -F document=@"dreem_backup_*.zip" >> "$LOG_FILE"
        reply="📦 تم إرسال النسخة المضغوطة بنجاح"
        ;;
      "/control")
        reply="🧠 لوحة Dreem جاهزة: نفّذ السكربت مباشرة من Termux لواجهة Bash تفاعلية"
        ;;
      *)
        reply="⁉️ أمر غير معروف. استخدم /start لرؤية الأوامر المتاحة"
        ;;
    esac

    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
      -d chat_id="$chat_id" \
      -d text="$reply" \
      -d parse_mode="Markdown"

    offset=$((update_id + 1))
  done

  sleep 2
done
