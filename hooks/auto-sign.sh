#!/bin/bash

INPUT_DIR="input"
WATCHED_FILES=".last_signature_watch"
LOG_FILE="logs/sign_log.json"
mkdir -p signed_zip

# إنشاء قائمة الملفات الحالية
find "$INPUT_DIR" -type f > "$WATCHED_FILES.new"

# مقارنة مع الملفات السابقة
NEW_FILES=$(comm -13 "$WATCHED_FILES" "$WATCHED_FILES.new")
mv "$WATCHED_FILES.new" "$WATCHED_FILES"

for FILE in $NEW_FILES; do
    FILENAME=$(basename "$FILE")
    SIGNATURE=$(sha256sum "$FILE" | cut -d ' ' -f1)
    ZIP_NAME="signed_zip/${FILENAME%.zip}_signed.zip"

    zip -j "$ZIP_NAME" "$FILE"
    ./alerts/dreem_alert.sh "⚠️ ملف جديد تم إدخاله" "📁 $FILENAME" "🔐 SHA256:$SIGNATURE"
    echo "$(date +%Y-%m-%dT%H:%M:%S) - $FILENAME - SHA256:$SIGNATURE" >> "$LOG_FILE"
    echo "✅ $FILENAME تم توقيعه تلقائيًا."
done
