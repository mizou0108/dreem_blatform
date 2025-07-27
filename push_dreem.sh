#!/bin/bash

# 🌐 فحص الاتصال بـ GitHub من داخل gh
if ! gh repo list &>/dev/null; then
    echo "[🛑] لا يمكن الوصول إلى GitHub. تحقق من الاتصال أو التوثيق."
    exit 1
fi

# 📂 تحقق من بيئة Git
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "[❌] ليس مشروع Git حالياً. استخدم git init أولاً."
    exit 1
fi

# 🔄 تحويل master إلى main
branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" == "master" ]; then
    git branch -M main
    branch="main"
fi

# 🌍 ربط الريموت إذا غير موجود
if ! git remote | grep -q origin; then
    echo "[🔗] لم يتم ربط الريموت. سأضيفه الآن..."
    git remote add origin https://github.com/mizou0108/dreem_blatform.git
fi

# ❌ فحص تعارضات وإيقاف التفعيل لو وجد
if git status | grep -q "Unmerged paths"; then
    echo "[❌] هناك تعارضات غير محلولة. يرجى حلها قبل الرفع."
    exit 1
fi

# 📦 إضافة وتأكيد كل الملفات
git add .
git commit -m "📦 رفع تلقائي لكامل محتويات Dreem"
git push origin "$branch"

# 📜 تسجيل عملية الرفع
echo "$(date '+%Y-%m-%d %H:%M:%S') | رفع كامل محتويات '$branch'" >> push.log
echo "[✅] تم رفع مشروع Dreem بنجاح!"
