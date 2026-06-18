#!/bin/bash

# مخفی کردن کرسر (نشانگر چشمک‌زن)
tput civis
# بازگرداندن کرسر در صورت توقف دستی اسکریپت (Ctrl+C)
trap 'tput cnorm; exit 1' INT

# تعریف رنگ‌ها
C='\e[0;36m'  # فیروزه‌ای
G='\e[0;32m'  # سبز
Y='\e[1;33m'  # زرد
R='\e[0;31m'  # قرمز
P='\e[0;35m'  # بنفش
NC='\e[0m'    # بدون رنگ

clear

# کادر خوش‌آمدگویی کاملاً تراز شده (بدون ایموجی)
echo -e "${C}╔══════════════════════════════════════════╗${NC}"
echo -e "${C}║${NC}${Y}       Welcome to Termux Auto-Setup       ${NC}${C}║${NC}"
echo -e "${C}║${NC}${G}         Created by: [☬SHΞЯVIN™]          ${NC}${C}║${NC}"
echo -e "${C}╚══════════════════════════════════════════╝${NC}"
echo ""

# لیست پکیج‌ها
PACKAGES=("python" "termux-api" "git" "nano" "curl" "wget" "ncurses-utils")
PIP_PACKAGES=("requests")

echo -e "${Y}[*] The following packages will be installed:${NC}"
echo -e "${C}-> System: ${PACKAGES[*]} ${NC}"
echo -e "${C}-> Python: ${PIP_PACKAGES[*]} ${NC}"
echo ""
sleep 2

# تابع ساخت درصد پیشرفت
progress_bar() {
    local pid=$!
    local percent=0
    while kill -0 $pid 2>/dev/null; do
        if [ $percent -lt 99 ]; then
            percent=$((percent + $((RANDOM % 3 + 1))))
            if [ $percent -gt 99 ]; then percent=99; fi
        fi
        printf " ${Y}[%3d%%]${NC}\b\b\b\b\b\b\b" "$percent"
        sleep 0.3
    done
    wait $pid
    local status=$?
    # چک کردن اینکه آیا نصب واقعاً موفق بوده یا نه
    if [ $status -eq 0 ]; then
        printf " ${G}[100%%]${NC} \n"
    else
        printf " ${R}[ERROR]${NC}\n"
    fi
}

# مرحله ۱: آپدیت سیستم (بدون درصد پیشرفت برای جلوگیری از خطای libcrypto)
echo -ne "${Y}[1/4] Updating repositories (Please wait)...${NC}"
DEBIAN_FRONTEND=noninteractive apt-get update -y > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::="--force-confnew" > /dev/null 2>&1
echo -e " ${G}[Done]${NC}"

# مرحله ۲: نصب تک‌به‌تک پکیج‌ها
echo -e "${Y}[2/4] Installing core tools...${NC}"
for pkg in "${PACKAGES[@]}"; do
    echo -ne "   ${C}-> Installing ${pkg}...${NC}"
    pkg install "$pkg" -y > /dev/null 2>&1 & progress_bar
done

# مرحله ۳: تنظیمات پایتون
echo -e "${Y}[3/4] Configuring Python...${NC}"
echo -ne "   ${C}-> Upgrading pip...${NC}"
python -m pip install --upgrade pip > /dev/null 2>&1 & progress_bar

for pip_pkg in "${PIP_PACKAGES[@]}"; do
    echo -ne "   ${C}-> Installing module: ${pip_pkg}...${NC}"
    pip install "$pip_pkg" > /dev/null 2>&1 & progress_bar
done

# مرحله ۴: پاکسازی
echo -ne "${Y}[4/4] Cleaning up system...${NC}"
(apt autoremove -y && apt clean) > /dev/null 2>&1 & progress_bar

echo ""
echo -e "${G}============================================${NC}"
echo -e "${Y}      Setup Completed Successfully!         ${NC}"
echo -e "${G}============================================${NC}"
echo ""

echo -e "${P}[!] Requesting API permissions...${NC}"
echo -e "${P}[!] Please tap 'Allow' on the popup window.${NC}"
sleep 2

# برگرداندن کرسر به حالت عادی
tput cnorm

# بررسی اینکه آیا پکیج API واقعاً نصب شده یا نه، سپس اجرای آن
if command -v termux-setup-api &> /dev/null; then
    termux-setup-api
else
    echo -e "${R}[!] Error: termux-api was not installed correctly.${NC}"
fi
