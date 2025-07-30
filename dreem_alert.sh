#!/bin/bash
# dreem_alert.sh — وحدة تنبيه ذكي من Dreem Fortress™

source ~/.dreem_env 2>/dev/null || source .env 2>/dev/null

if [[ -z "$BOT_TOKEN" || -z "$CHAT_ID" ]]; then
  echo "❌ BOT_TOKEN أو CHAT_ID غير معرف. تأكد من .env أو ~/.dreem_env"
  exit 1
fi

TELEGRAM_API="https://api.telegram.org/bot$BOT_TOKEN"

MESSAGE="$1"
SIGNED="$2"

if [[ -z "$MESSAGE" ]]; then
  echo "⚠️ الاستخدام: ./dreem_alert.sh \"الرسالة\" [بصمة أو ملف]"
  exit 1
fi

curl -s "$TELEGRAM_API/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="$MESSAGE" \
  -d parse_mode="Markdown"

LOG_FILE="dreem_alert.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] $MESSAGE ${SIGNED:+| 🔒 $SIGNED}" >> "$LOG_FILE"
