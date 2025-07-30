#!/bin/bash

ZIP_DIR="signed_zip"
LOG_FILE="sign_log.json"
MODE="$1"
QUERY="$2"

extract_file() {
    local FILENAME="$1"
    local ZIP_NAME="${FILENAME%.zip}_signed.zip"
    if [[ -f "$ZIP_DIR/$ZIP_NAME" ]]; then
        unzip -o "$ZIP_DIR/$ZIP_NAME" -d recovered_files/
        echo "✅ تم استخراج [$FILENAME] إلى recovered_files/"
    else
        echo "⚠️ الملف المؤرشف غير موجود: $ZIP_NAME"
    fi
}

if [[ "$MODE" == "--log-json" && -n "$QUERY" ]]; then
    MATCH=$(grep "$QUERY" "$LOG_FILE" | tail -n1)
    if [[ -z "$MATCH" ]]; then
        echo "❌ لا توجد نتيجة لـ [$QUERY]"
    else
        DATE=$(echo "$MATCH" | cut -d '-' -f1 | xargs)
        FILE=$(echo "$MATCH" | cut -d '-' -f2 | xargs)
        HASH=$(echo "$MATCH" | cut -d '-' -f3 | xargs)
        echo -e "{\n  \"date\": \"$DATE\",\n  \"file\": \"$FILE\",\n  \"hash\": \"$HASH\"\n}"
    fi
elif [[ "$MODE" == "--force-latest" ]]; then
    LATEST=$(tail -n1 "$LOG_FILE")
    FILE=$(echo "$LATEST" | cut -d '-' -f2 | xargs)
    extract_file "$FILE"
elif [[ -n "$MODE" ]]; then
    MATCH=$(grep "$MODE" "$LOG_FILE" | tail -n1)
    FILE=$(echo "$MATCH" | cut -d '-' -f2 | xargs)
    extract_file "$FILE"
else
    echo "📘 الاستخدام:\n  ./rescue.sh [query]\n  ./rescue.sh --log-json [query]\n  ./rescue.sh --force-latest"
fi
