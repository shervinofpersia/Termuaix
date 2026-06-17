#!/bin/bash
# Exclusive ☬SHΞN™ made - GPT Cloudflare Routing & Hijack Detector

# بررسی و نصب پیش‌نیازها
command -v curl >/dev/null 2>&1 || { echo -e "\e[1;33m[*] Installing curl...\e[0m"; pkg install curl -y; }
command -v traceroute >/dev/null 2>&1 || { echo -e "\e[1;33m[*] Installing traceroute...\e[0m"; pkg install traceroute -y; }

clear
echo -e "\e[1;33m[*] Fetching Real IP...\e[0m"
R_IP=$(curl -s --max-time 5 https://api.ipify.org)

if [ -z "$R_IP" ]; then
    echo -e "\e[0;31m[-] Failed to get real IP. Check your connection.\e[0m"
    exit 1
fi

echo -e "\e[0;32m[+] Real IP: $R_IP\e[0m\n"

# تارگت‌های اختصاصی GPT و CDNهای مرتبط
TARGETS=(
    "chatgpt.com"
    "oaistatic.com"
    "openai.com"
)

for d in "${TARGETS[@]}"; do
    echo -e "\e[1;34m[*] Target: $d\e[0m"
    
    # بررسی آی‌پی از دید کلودفلر روی مسیرهای GPT
    C_IP=$(curl -s --max-time 5 "https://$d/cdn-cgi/trace" | grep ip= | cut -d= -f2)

    if [ -z "$C_IP" ]; then
        echo -e "\e[0;31m[-] Could not retrieve trace info (Endpoint might be blocked or timing out).\e[0m"
    else
        echo -e "CF IP: \e[1;33m$C_IP\e[0m"
        if [ "$R_IP" == "$C_IP" ]; then
            echo -e "\e[0;32m[+] Trace: Normal (No spoofing)\e[0m"
        else
            echo -e "\e[0;31m[!] Trace: Mismatch! Traffic proxied/hijacked on GPT route.\e[0m"
        fi
    fi

    # بررسی روتینگ شبکه برای رنج‌های آلوده
    echo -ne "Route Check: "
    TR=$(traceroute -m 15 -w 1 $d 2>/dev/null | grep -E "2\.189\.5[23]\.")
    
    if [ -n "$TR" ]; then
        echo -e "\n\e[0;31m[!] Suspected TIC (2.189.5x.x) IPs Found on path to $d!\e[0m"
        echo -e "\e[0;31m$TR\e[0m"
    else
        echo -e "\e[0;32mClean (No known malicious hops).\e[0m"
    fi
    echo "-----------------------------------"
done
