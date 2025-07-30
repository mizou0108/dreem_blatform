#!/bin/bash

# توقيع تلقائي للملفات
./hooks/auto-sign.sh

# تشفير الملفات الحساسة
SECRET_KEY="dreemSecret123"

for FILE in passwords.txt raw.json github_login.sh; do
    if [[ -f "$FILE" ]]; then
        ENCRYPTED="${FILE}.enc"
        openssl aes-256-cbc -salt -in "$FILE" -out "$ENCRYPTED" -pass pass:$SECRET_KEY
        echo "🔐 تم تشفير $FILE → $ENCRYPTED"
    fi
done

# إرسال ملفات إلى Telegram
./send_all_to_telegram.sh

# دفع إلى GitHub
git add .
git commit -m "🔁 مزامنة Dreem: توقيع وتشفير ودفع"
git push origin main
