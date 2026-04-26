在 Linux 系统上安装 Oh My Zsh 的步骤：

## 1. 安装 Zsh

如果您的系统中没有安装 Zsh，请使用以下命令安装：

```
$ sudo apt-get update
$ sudo apt-get install zsh
```

## 2. 安装 Git

Oh My Zsh 使用 Git 来管理其存储库，因此您需要先安装 Git：

```
$ sudo apt-get install git
```

## 3. 安装 Oh My Zsh

使用以下命令安装 Oh My Zsh：

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

该命令将从 Oh My Zsh 存储库下载安装脚本，并在您的系统上安装 Oh My Zsh。在安装过程中，您可能需要按下回车键来确认安装选项。

## 4. 切换默认 shell

默认情况下，您的系统可能仍在使用 Bash shell。要切换到 Zsh shell，请使用以下命令：

```
$ chsh -s $(which zsh)
```

该命令将把默认 shell 改为 Zsh，您需要注销并重新登录才能生效。

