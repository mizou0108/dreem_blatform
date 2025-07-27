#!/data/data/com.termux/files/usr/bin/bash

echo -e "\n📦 استعادة الملفات الناقصة...\n"

# روابط احتياطية (عدّل المسارات حسب مستودعك الخاص لو عندك واحد)
BASE_URL="https://raw.githubusercontent.com/dreem-dev/dreem-resources/main"

MISSING=(
    "generate.sh"
    "submit_to_report.sh"
    "network_check.sh"
    "dreem_bruteforce.sh"
    "dreem_bruteforce.py"
    "passwords.txt"
    "report.html"
)

for file in "${MISSING[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "🔍 تحميل $file ..."
        curl -s -O "$BASE_URL/$file" && echo "[✔] تم تحميل $file بنجاح" || echo "[✘] فشل تحميل $file ❌"
        chmod +x "$file" 2>/dev/null
    else
        echo -e "[✔] $file موجود مسبقًا ✅"
    fi
done

echo -e "\n🎉 انتهى الاسترداد. شغّل dreem_boot.sh للتحقق مرة أخرى."
