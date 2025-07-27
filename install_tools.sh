#!/bin/bash

# قائمة الأدوات الأساسية
tools=(
    php
    python
    git
    curl
    jq
    qrencode
    zip
    net-tools
    openssh
    lsof
    yq
    termux-api
    zsh
    figlet
    toilet
    imagemagick
    htop
    tmux
    nmap
    hydra
    whois
    nodejs
    z3
)

echo "📦 بدء تثبيت الأدوات اللازمة لمشروع Dreem..."
echo "--------------------------------------------"

# تثبيت كل أداة وفحص حالتها
for tool in "${tools[@]}"; do
    echo "🔧 تثبيت: $tool"
    if pkg install -y "$tool" > /dev/null 2>&1; then
        echo "✅ $tool تم تثبيته بنجاح"
    else
        echo "❌ فشل في تثبيت $tool"
    fi
    echo "--------------------------------------------"
done

echo "🎉 تم الانتهاء من التثبيت!"
