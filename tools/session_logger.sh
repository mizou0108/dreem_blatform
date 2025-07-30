#!/data/data/com.termux/files/usr/bin/bash

# 📍 مسارات الملفات
SESSIONS_DIR="$HOME/sessions"
SIGNED_DIR="$HOME/dreem_blatform/logs/signatures"
mkdir -p "$SIGNED_DIR"  # إنشاء مجلد التوقيعات إن لم يكن موجودًا

SESSION_FILE="$SESSIONS_DIR/dreem_reports.json"
TIMESTAMP=$(date +%Y%m%d_%H%M)
SIGNED_FILE="$SIGNED_DIR/dreem_reports_signed_$TIMESTAMP.json.asc"

# 🧠 تحقق من وجود نسخة موقّعة مسبقًا
if [[ -f "$SIGNED_FILE" ]]; then
    echo "⚠️ الملف $SIGNED_FILE موجود مسبقًا."
    read -p "📛 هل تريد الاستبدال؟ (y/N) " ANSWER
    if [[ "$ANSWER" != "y" ]]; then
        read -p "📁 أدخل اسم جديد للملف الموقّع: " NEW_NAME
        SIGNED_FILE="$SIGNED_DIR/$NEW_NAME.json.asc"
    fi
fi

# 🔐 تنفيذ التوقيع
gpg --yes --batch --clearsign "$SESSION_FILE" > "$SIGNED_FILE"
echo "✅ تم توقيع الجلسة وحفظها في: $SIGNED_FILE"

# 🧾 أرشفة النسخة الأصلية قبل التوقيع (اختياري)
ARCHIVE_FILE="$SIGNED_DIR/archived_original_$TIMESTAMP.json"
cp "$SESSION_FILE" "$ARCHIVE_FILE"
echo "🗂️ تم حفظ نسخة أصلية مؤرشفة: $ARCHIVE_FILE"

# 🧠 سجل زمني إضافي (اختياري)
LOG_FILE="$SIGNED_DIR/session_history.log"
echo "[$(date)] Signed: $SIGNED_FILE" >> "$LOG_FILE"
echo "🔔 سجل التاريخ في: $LOG_FILE"
