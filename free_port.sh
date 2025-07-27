#!/bin/bash

echo -e "\n🚀 بدء تشغيل السيرفر الذكي لـ Dreem...\n"
PORTS=(8080 9090 8000)

find_process() {
  for pid in $(ps -axo pid); do
    cmd=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' ' ')
    if echo "$cmd" | grep -q "php.*${1}"; then
      echo $pid
      return
    fi
  done
  echo ""
}

for port in "${PORTS[@]}"; do
  echo "🔍 محاولة استخدام المنفذ $port..."

  pid=$(find_process $port)
  if [ -n "$pid" ]; then
    echo "⚠️ عملية PID $pid تحتل $port، جاري قتلها..."
    kill -9 $pid
    sleep 1
  fi

  php -S 127.0.0.1:$port >/dev/null 2>&1 &
  sleep 1

  curl -s -o /dev/null http://127.0.0.1:$port
  if [ $? -eq 0 ]; then
    echo "✅ السيرفر يعمل على http://127.0.0.1:$port/report.php"
    echo $port > active_port.txt
    exit 0
  else
    echo "❌ فشل تشغيل السيرفر على $port، تجربة المنفذ التالي..."
  fi
done

echo "❌ لم يتم العثور على منفذ متاح، الرجاء الفحص يدويًا."
exit 1
