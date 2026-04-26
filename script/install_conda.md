
## 更新apt
```
sudo apt update
sudo apt upgrade -y
sudo apt install wget -y
```

## 下载Miniconda
```
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.3.0-0-Linux-x86_64.sh

bash Miniconda3-py39_24.3.0-0-Linux-x86_64.sh
```

## 更新配置
```
# 重新加载shell配置
source ~/.bashrc
# 或如果是zsh用户：source ~/.zshrc

```
## conda常用命令
```
conda search python 搜索可用python版本 
conda create -n env_name python=x.x	创建新环境	conda create -n myenv python=3.11
conda activate env_name	激活环境	conda activate myenv
conda deactivate	退出环境	conda deactivate
conda env list	查看所有环境	conda env list
conda remove -n env_name --all	删除环境	conda remove -n myenv --all
conda install package_name	安装包	conda install numpy pandas
conda list	查看已安装包	conda list

```