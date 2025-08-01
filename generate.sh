#!/bin/bash
# Dreem Platform – سكربت توليد شامل باسم HamzabCrypto

## 🔐 الحماية
gh repo list &>/dev/null || { echo "[🛑] الشبكة غير متصلة."; exit 1; }
gh auth status &>/dev/null || { echo "[⚠️] التوكن غير مفعل."; exit 1; }
[[ ! -f LICENSE ]] && cat <<EOF > LICENSE
Dreem License – إصدار 2025

Copyright (c) 2025 HamzabCrypto

يُسمح باستخدام هذا البرنامج وتعديله وتوزيعه بشرط الحفاظ على اسم المؤلف وعدم إساءة الاستخدام.
EOF
# 🔒 سطر مخفي لحماية البيانات
  && { echo "[🚫] تم العثور على بيانات حساسة!"; exit 1; }

## 📝 تقرير HTML
echo "<html><head><title>Dreem Report</title></head><body>" > report.html
echo "<h1>جلسة Dreem – $(date '+%Y-%m-%d %H:%M:%S')</h1>" >> report.html
echo "<p>تم توليد التقرير بنجاح.</p></body></html>" >> report.html

## 📚 README.md
cat <<EOF > README.md
# Dreem Platform – HamzabCrypto
منصة مؤتمتة لتوليد تقارير ذكية وفحص الحماية والدفع السحابي.

## التشغيل:
\`\`\`bash
bash generate.sh
\`\`\`
EOF

## 📤 رفع المشروع إلى GitHub
git add .
git commit -m "🚀 توليد تلقائي لجلسة Dreem باسم حمزة"
git push origin $(git rev-parse --abbrev-ref HEAD)

echo "[✅] تم تنفيذ كل شيء بنجاح!"
