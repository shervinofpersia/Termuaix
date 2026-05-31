#!/bin/bash

clear
echo "======================================"
echo "    در حال آماده‌سازی هوش مصنوعی...   "
echo "======================================"

# نصب پیش‌نیازهای پایه ترموکس
pkg update -y
pkg install python wget -y

# ایجاد پوشه پروژه
mkdir -p ~/termux-ai-chat
cd ~/termux-ai-chat

# دانلود مستقیم فایل HTML از ریپازیتوری شما
echo "[*] Downloading user interface..."
wget -q -O index.html https://raw.githubusercontent.com/shervinofpersia/Termuaix/main/index.html

# بستن سرورهای لوکال قبلی برای آزاد شدن پورت
pkill -f "http.server" 2>/dev/null

# اجرای وب‌سرور داخلی و پیش‌فرض خود پایتون روی پورت 5000 در پس‌زمینه
echo "[*] Starting local server..."
python -m http.server 5000 &

# مکث کوتاه برای لود شدن سرور
sleep 2

# باز کردن مرورگر گوشی
echo "[*] Opening browser..."
termux-open-url http://127.0.0.1:5000
