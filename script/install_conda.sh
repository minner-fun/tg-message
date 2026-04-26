#!/bin/bash
set -e

MINICONDA_INSTALLER="Miniconda3-py39_24.3.0-0-Linux-x86_64.sh"
MINICONDA_URL="https://repo.anaconda.com/miniconda/${MINICONDA_INSTALLER}"
INSTALL_DIR="$HOME/miniconda3"

echo ">>> 更新 apt 包列表..."
sudo apt update
sudo apt upgrade -y
sudo apt install wget -y

echo ">>> 下载 Miniconda 安装包..."
wget -c "${MINICONDA_URL}" -O "/tmp/${MINICONDA_INSTALLER}"

echo ">>> 安装 Miniconda 到 ${INSTALL_DIR}..."
bash "/tmp/${MINICONDA_INSTALLER}" -b -p "${INSTALL_DIR}"

echo ">>> 初始化 conda..."
"${INSTALL_DIR}/bin/conda" init bash

if [ -f "$HOME/.zshrc" ]; then
    "${INSTALL_DIR}/bin/conda" init zsh
fi

echo ">>> 清理安装包..."
rm -f "/tmp/${MINICONDA_INSTALLER}"

echo ""
echo ">>> 安装完成！请执行以下命令使 conda 生效："
echo "    source ~/.bashrc"
echo ""
echo "常用 conda 命令："
echo "  conda search python                      # 搜索可用 Python 版本"
echo "  conda create -n env_name python=x.x      # 创建新环境"
echo "  conda activate env_name                  # 激活环境"
echo "  conda deactivate                         # 退出环境"
echo "  conda env list                           # 查看所有环境"
echo "  conda remove -n env_name --all           # 删除环境"
echo "  conda install package_name               # 安装包"
echo "  conda list                               # 查看已安装包"
