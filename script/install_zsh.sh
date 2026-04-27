#!/bin/bash
set -e

echo ">>> 更新 apt 包列表..."
sudo apt-get update

echo ">>> 安装 zsh..."
sudo apt-get install -y zsh

echo ">>> 安装 git..."
sudo apt-get install -y git curl

# ── 安装 Oh My Zsh 前，快照已有工具路径 ──────────────────────────────────────
# Oh My Zsh 安装时会将现有 ~/.zshrc 备份为 ~/.zshrc.pre-oh-my-zsh，
# 然后用自己的模板覆盖，导致之前写入 ~/.zshrc 的 conda/nvm/pyenv 等初始化块丢失。
# 这里提前记录哪些工具已经安装，以便安装后重新 init。

CONDA_BIN=""
for candidate in \
    "$HOME/miniconda3/bin/conda" \
    "$HOME/anaconda3/bin/conda" \
    "$HOME/miniforge3/bin/conda" \
    "/opt/conda/bin/conda"; do
    if [ -x "$candidate" ]; then
        CONDA_BIN="$candidate"
        break
    fi
done

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"

echo ">>> 安装 Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# ── 安装后，将各工具的初始化配置写入 Oh My Zsh custom 目录 ──────────────────
# ~/.oh-my-zsh/custom/*.zsh 会被 Oh My Zsh 自动 source，
# 单独存放工具配置可避免被未来的 .zshrc 覆盖操作影响。

OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

reinit_tools() {
    local custom_file="$OMZ_CUSTOM/tools-init.zsh"
    : > "$custom_file"   # 清空/创建

    # conda
    if [ -n "$CONDA_BIN" ]; then
        echo ">>> 重新初始化 conda for zsh..."
        "$CONDA_BIN" init zsh
        # conda init 已经写入 ~/.zshrc；同时在 custom 里保留路径，防止未来再次失效
        {
            echo "# conda"
            echo "[ -f \"\$HOME/miniconda3/etc/profile.d/conda.sh\" ] && source \"\$HOME/miniconda3/etc/profile.d/conda.sh\""
            echo "[ -f \"\$HOME/anaconda3/etc/profile.d/conda.sh\" ]  && source \"\$HOME/anaconda3/etc/profile.d/conda.sh\""
            echo "[ -f \"\$HOME/miniforge3/etc/profile.d/conda.sh\" ] && source \"\$HOME/miniforge3/etc/profile.d/conda.sh\""
        } >> "$custom_file"
    fi

    # nvm
    if [ -d "$NVM_DIR" ]; then
        echo ">>> 重新初始化 nvm for zsh..."
        {
            echo ""
            echo "# nvm"
            echo "export NVM_DIR=\"\$HOME/.nvm\""
            echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && source \"\$NVM_DIR/nvm.sh\""
            echo "[ -s \"\$NVM_DIR/bash_completion\" ] && source \"\$NVM_DIR/bash_completion\""
        } >> "$custom_file"
    fi

    # pyenv
    if [ -d "$PYENV_ROOT/bin" ]; then
        echo ">>> 重新初始化 pyenv for zsh..."
        {
            echo ""
            echo "# pyenv"
            echo "export PYENV_ROOT=\"\$HOME/.pyenv\""
            echo "export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
            echo "eval \"\$(pyenv init -)\""
        } >> "$custom_file"
    fi

    [ -s "$custom_file" ] && echo ">>> 工具初始化配置已写入 $custom_file"
}

reinit_tools

echo ">>> 切换默认 shell 为 zsh..."
chsh -s "$(which zsh)"

echo ""
echo ">>> 安装完成！请注销并重新登录以使默认 shell 生效。"
echo "    或执行以下命令立即切换到 zsh："
echo "    exec zsh"
