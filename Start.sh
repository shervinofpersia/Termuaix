#!/bin/bash

# تعریف رنگ‌ها برای گرافیک ترمینال
C='\e[0;36m'  # فیروزه‌ای (Cyan)
G='\e[0;32m'  # سبز (Green)
Y='\e[1;33m'  # زرد (Yellow)
R='\e[0;31m'  # قرمز (Red)
P='\e[0;35m'  # بنفش (Purple)
NC='\e[0m'    # بدون رنگ (حالت پیش‌فرض)

clear

# پیام خوش‌آمدگویی و امضای شما
echo -e "${C}╔══════════════════════════════════════════╗${NC}"
echo -e "${C}║${NC} ${Y}🚀 Welcome to Termux Auto-Setup ${NC} ${C}║${NC}"
echo -e "${C}║${NC} ${G}👨‍💻 Created by: [☬SHΞЯVIN™]   ${NC} ${C}║${NC}"
echo -e "${C}╚══════════════════════════════════════════╝${NC}"
echo ""

# لیست پکیج‌ها
PACKAGES=("python" "termux-api" "git" "nano" "curl" "wget" "ncurses-utils")
PIP_PACKAGES=("requests")

# نمایش لیست پکیج‌ها به کاربر
echo -e "${Y}[*] The following packages will be installed:${NC}"
echo -e "${C}-> System: ${PACKAGES[*]} ${NC}"
echo -e "${C}-> Python: ${PIP_PACKAGES[*]} ${NC}"
echo ""
sleep 2

# تابع ساخت انیمیشن لودینگ (Spinner)
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# مرحله ۱: آپدیت مخازن
echo -ne "${Y}[1/4] Updating repositories...${NC}"
(pkg update -y && pkg upgrade -y) > /dev/null 2>&1 & spinner
echo -e "${G}[Done]${NC}"

# مرحله ۲: نصب تک‌به‌تک پکیج‌ها با انیمیشن
echo -e "${Y}[2/4] Installing core tools...${NC}"
for pkg in "${PACKAGES[@]}"; do
    echo -ne "   ${C}-> Installing ${pkg}...${NC}"
    pkg install "$pkg" -y > /dev/null 2>&1 & spinner
    echo -e "${G}[Done]${NC}"
done

# مرحله ۳: تنظیمات پایتون
echo -e "${Y}[3/4] Configuring Python...${NC}"
echo -ne "   ${C}-> Upgrading pip...${NC}"
python -m pip install --upgrade pip > /dev/null 2>&1 & spinner
echo -e "${G}[Done]${NC}"

for pip_pkg in "${PIP_PACKAGES[@]}"; do
    echo -ne "   ${C}-> Installing module: ${pip_pkg}...${NC}"
    pip install "$pip_pkg" > /dev/null 2>&1 & spinner
    echo -e "${G}[Done]${NC}"
done

# مرحله ۴: پاکسازی فایل‌های اضافی
echo -ne "${Y}[4/4] Cleaning up system...${NC}"
(apt autoremove -y && apt clean) > /dev/null 2>&1 & spinner
echo -e "${G}[Done]${NC}"

echo ""
echo -e "${G}============================================${NC}"
echo -e "${Y}    🎉 Setup Completed Successfully! 🎉     ${NC}"
echo -e "${G}============================================${NC}"
echo ""

# درخواست دسترسی API
echo -e "${P}[!] Requesting API permissions...${NC}"
echo -e "${P}[!] Please tap 'Allow' on the popup window.${NC}"
sleep 2
termux-setup-api
