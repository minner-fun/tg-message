#!/bin/bash
set -e

echo ">>> 更新 apt 包列表..."
sudo apt-get update

echo ">>> 安装 zsh..."
sudo apt-get install -y zsh

echo ">>> 安装 git..."
sudo apt-get install -y git curl

echo ">>> 安装 Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo ">>> 切换默认 shell 为 zsh..."
chsh -s "$(which zsh)"

echo ""
echo ">>> 安装完成！请注销并重新登录以使默认 shell 生效。"
echo "    或执行以下命令立即切换到 zsh："
echo "    exec zsh"
