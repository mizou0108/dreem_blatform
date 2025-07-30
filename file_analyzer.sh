#!/usr/bin/env bash

TARGET="$1"
BASE="$HOME/dreem_blatform"
FILE="$BASE/$TARGET"

# ✅ تحليل ملف محدد
if [[ -n "$TARGET" ]]; then
  if [[ -f "$FILE" ]]; then
    echo "✅ الملف $TARGET موجود."
    echo "📦 الحجم: $(du -h "$FILE" | cut -f1)"
    echo "📄 عدد السطور: $(wc -l < "$FILE")"
    echo "🕓 آخر تعديل: $(date -r "$FILE" '+%Y-%m-%d %H:%M')"
    echo "🔐 توقيع: $(sha256sum "$FILE" | cut -d ' ' -f1)"
  else
    echo "❌ الملف $TARGET غير موجود."
  fi

# 📂 البحث عن ملفات PDF فقط
else
  echo "🔎 البحث عن ملفات PDF داخل $BASE..."
  find "$BASE" -type f -iname "*.pdf" | while read -r pdf; do
    echo "📄 $(basename "$pdf")"
    echo "📦 الحجم: $(du -h "$pdf" | cut -f1)"
    echo "🕓 آخر تعديل: $(date -r "$pdf" '+%Y-%m-%d %H:%M')"
    echo "🔐 توقيع: $(sha256sum "$pdf" | cut -d ' ' -f1)"
    echo "-----------------------------"
  done
fi
