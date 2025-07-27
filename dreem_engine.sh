#!/bin/bash

# 🌐 تحقق من الاتصال بـ GitHub
check_network() {
    if ! gh repo list &>/dev/null; then
        echo "[🛑] لا يمكن الاتصال بـ GitHub."
        echo "$(date '+%Y-%m-%d %H:%M:%S') | فشل الاتصال" >> network.log
        exit 1
    fi
}

# 🔑 تحقق من التوثيق
check_token() {
    if ! gh auth status &>/dev/null; then
        echo "[🔒] التوثيق غير فعّال. نفّذ: gh auth login"
        exit 1
    fi
}

# ❌ فحص التعارضات
check_conflict() {
    if git status | grep -q "Unmerged paths"; then
        echo "[❌] تعارضات موجودة. يرجى حلها يدويًا."
        exit 1
    fi
}

# 📦 تحقق من وجود تغييرات
check_changes() {
    if git diff --cached --quiet && git diff --quiet; then
        return 1
    fi
    return 0
}

# 🧪 توليد جلسة
generate_session() {
    session="session_$(date '+%Y%m%d_%H%M%S')"
    mkdir -p "$session"
    echo "<h1>تقرير جلسة $session</h1>" > "$session/report.html"
    echo "PDF وهمي" > "$session/report.pdf"
    zip -r "$session/report.zip" "$session" &>/dev/null
    echo "$(date '+%Y-%m-%d %H:%M:%S') | توليد: $session" >> session.log
    echo "[✅] تم إنشاء الجلسة: $session"
}

# 📊 تحليل الجلسة
analyze_session() {
    count=$(ls "$session" | wc -l)
    size=$(du -sh "$session" | cut -f1)
    echo "[🔍] عدد الملفات: $count | الحجم: $size"
}

# 🚀 البداية
echo "[💡] بدء Dreem Engine..."
check_network
check_token

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "[❌] هذا ليس مشروع Git"
    exit 1
fi

if [ "$branch" == "master" ]; then
    git branch -M main
    branch="main"
fi

if ! git remote | grep -q origin; then
    git remote add origin https://github.com/mizou0108/dreem_blatform.git
fi

git fetch origin
git pull --rebase origin "$branch"
check_conflict

generate_session
analyze_session

# 🛰️ إرسال إلى report.php
if [ -f submit_to_report.sh ]; then
    bash submit_to_report.sh "$session"
    echo "[📨] تم إرسال الجلسة إلى report.php"
else
    echo "[ℹ️] ملف submit_to_report.sh غير موجود. تخطيت الإرسال."
fi

# 📤 الدفع إلى GitHub
if check_changes; then
    git add .
    git commit -m "⚡ تحديث تلقائي من dreem_engine"
    git push origin "$branch"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | تم الدفع بنجاح" >> push.log
    echo "[✅] التحديث تم بنجاح"
else
    echo "[🚫] لا توجد تغييرات للدفع"
fi
