#!/bin/bash
source chat_config.sh

MESSAGE="$1"
if [[ -z "$MESSAGE" ]]; then
  echo "⚠️ أدخل رسالة مثل: ./send_message.sh '✅ تم التوقيع'"
  exit 1
fi

curl -s "$TELEGRAM_API/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="$MESSAGE" \
  -d parse_mode="Markdown"
