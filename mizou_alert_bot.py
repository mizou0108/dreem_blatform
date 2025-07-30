#!/usr/bin/env python3

import requests
import subprocess
import time
import sys

# إعداد التوكن ومعرّف المستخدم
TOKEN = "8268505716:AAHGzrsueN2S_JTM6NOsI_9ezHLyc4kCp_o"
CHAT_ID = "ضع هنا رقم chat.id الخاص بك"
URL = f"https://api.telegram.org/bot{TOKEN}/"

# المسارات الأساسية
HOME = "/data/data/com.termux/files/home"
BOTPATH = f"{HOME}/dreem_blatform"
ANALYZER = f"{BOTPATH}/file_analyzer.sh"

def send_message(chat_id, text):
    requests.post(URL + "sendMessage", data={"chat_id": chat_id, "text": text})

def get_updates(offset=None):
    return requests.get(URL + "getUpdates", params={"offset": offset}).json()

def run_analyzer(target=""):
    cmd = ["bash", ANALYZER]
    if target:
        cmd.append(target)
    result = subprocess.run(cmd, stdout=subprocess.PIPE)
    return result.stdout.decode()

def tail_log():
    log_file = f"{BOTPATH}/dreem_log.txt"
    if subprocess.run(["test", "-f", log_file]).returncode == 0:
        result = subprocess.run(["tail", "-n", "5", log_file], stdout=subprocess.PIPE)
        return result.stdout.decode()
    return "📄 لا يوجد سجل حالياً."

def summarize_report():
    report_file = f"{BOTPATH}/report.html"
    if subprocess.run(["test", "-f", report_file]).returncode == 0:
        raw = subprocess.run(["grep", "-i", "Result", report_file], stdout=subprocess.PIPE).stdout.decode()
        signed = subprocess.run(["grep", "-i", "signature", report_file], stdout=subprocess.PIPE).stdout.decode()
        errors = subprocess.run(["grep", "-i", "Error", report_file], stdout=subprocess.PIPE).stdout.decode()
        summary = f"📊 ملخص التقرير:\n✅ النتائج: {len(raw.strip().splitlines())}\n🔐 التوقيع: {'✔️' if signed else '❌ غير موجود'}\n⚠️ أخطاء: {len(errors.strip().splitlines()) if errors else 0}"
        return summary
    return "❌ لا يوجد تقرير حالياً."

def auto_sign(file_to_sign="report.html"):
    full_path = f"{BOTPATH}/{file_to_sign}"
    if subprocess.run(["test", "-f", full_path]).returncode == 0:
        sha = subprocess.run(["sha256sum", full_path], stdout=subprocess.PIPE).stdout.decode().split()[0]
        timestamp = subprocess.run(["date", "-r", full_path, "+%Y-%m-%d %H:%M:%S"], stdout=subprocess.PIPE).stdout.decode().strip()
        return f"🖋️ توقيع `{file_to_sign}`:\n🔐 SHA256: `{sha}`\n🕓 أنشئ في: {timestamp}"
    return "❌ الملف غير موجود أو غير قابل للتوقيع."

def healthcheck(chat_id):
    report = "🧠 Dreem Fortress™ Health Check\n━━━━━━━━━━━━━━━━\n"
    for f in ["dreem_engine.sh", "dreem_security_suite.sh", "dreem_boot.sh"]:
        result = run_analyzer(f)
        report += f"\n📂 `{f}`:\n{result}\n"
    report += f"\n📡 سجل العمليات:\n{tail_log()}\n"
    pdfs = run_analyzer()
    report += f"\n📄 ملفات PDF:\n{pdfs}"
    send_message(chat_id, report)

def main():
    print("🚀 Dreem Alert Bot بدأ بنجاح.")
    offset = None
    while True:
        updates = get_updates(offset)
        for update in updates.get("result", []):
            message = update.get("message", {})
            chat_id = message.get("chat", {}).get("id")
            text = message.get("text", "").strip()
            print(f"📩 Received: {text}")

            if text == "/ping":
                send_message(chat_id, "🟢 البوت يعمل بنجاح.")
            elif text.startswith("/check"):
                parts = text.split(" ", 1)
                target = parts[1] if len(parts) > 1 else ""
                send_message(chat_id, run_analyzer(target))
            elif text == "/pdfs":
                send_message(chat_id, run_analyzer())
            elif text == "/healthcheck":
                healthcheck(chat_id)
            elif text == "/summarize_report":
                send_message(chat_id, summarize_report())
            elif text.startswith("/auto_sign"):
                parts = text.split(" ", 1)
                file_to_sign = parts[1] if len(parts) > 1 else "report.html"
                send_message(chat_id, auto_sign(file_to_sign))
            else:
                send_message(chat_id, "🤖 أوامر مدعومة:\n/ping\n/check [file]\n/pdfs\n/healthcheck\n/summarize_report\n/auto_sign [file]")

            offset = update["update_id"] + 1
        time.sleep(1)

# 🔁 دعم التشغيل التلقائي بعد العمليات
if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--healthcheck":
        healthcheck(CHAT_ID)
    else:
        main()
