#!/bin/bash

echo "[+] التحقق من حالة المصادقة مع GitHub CLI..."

if [ -z "$GITHUB_TOKEN" ]; then
  echo "[✓] لا يوجد متغيّر GITHUB_TOKEN... سيتم تسجيل الدخول يدويًا"
  gh auth login --hostname github.com --scopes "repo"
else
  echo "[⚠️] تم اكتشاف GITHUB_TOKEN في البيئة..."
  echo "[🔄] سيتم إزالته مؤقتًا لتفعيل gh auth login:"
  unset GITHUB_TOKEN
  sleep 1
  gh auth login --hostname github.com --scopes "repo"
  echo "[✅] تمت عملية المصادقة اليدوية بنجاح."
fi
