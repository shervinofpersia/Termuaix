#!/bin/bash

# پاک کردن صفحه برای زیبایی کار
clear
echo "======================================"
echo "    در حال آماده‌سازی هوش مصنوعی...   "
echo "======================================"

# آپدیت ترموکس و نصب پایتون
echo "[*] Installing dependencies (Python, Flask)..."
pkg update -y
pkg install python -y
pkg install wget -y

# نصب کتابخانه‌های پایتون
pip install flask requests

# ساخت پوشه پروژه و رفتن به داخل آن
mkdir -p ~/termux-ai-chat/templates
cd ~/termux-ai-chat

# دانلود فایل‌ها از گیت‌هاب تو (آدرس‌ها رو با لینک raw ریپازیتوری خودت جایگزین کن)
echo "[*] Downloading project files..."
wget -q -O app.py https://raw.githubusercontent.com/YourUsername/YourRepo/main/app.py
wget -q -O templates/index.html https://raw.githubusercontent.com/YourUsername/YourRepo/main/templates/index.html

# اجرای سرور در پس‌زمینه
echo "[*] Starting local server..."
python app.py &

# مکث کوتاه برای اینکه سرور کامل بالا بیاد
sleep 3

# باز کردن آدرس در مرورگر گرافیکی کاربر
echo "[*] Opening browser..."
termux-open-url http://127.0.0.1:5000
