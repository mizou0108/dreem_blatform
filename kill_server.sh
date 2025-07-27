#!/bin/bash

# تحديد المنفذ
port=8080

# استخراج PID باستخدام netstat وgrep
pid=$(netstat -anp 2>/dev/null | grep ":$port" | grep LISTEN | awk '{print $7}' | cut -d'/' -f1)

if [ -z "$pid" ]; then
    echo "❌ لا يوجد سيرفر PHP يشتغل على المنفذ $port"
else
    kill "$pid"
    echo "✅ تم إغلاق السيرفر على 127.0.0.1:$port (PID: $pid)"
fi
