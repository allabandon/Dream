#!/bin/env bash
## Author:SuperManito

## 定义变量：
DockerConfig=/etc/docker/daemon.json

## 判定系统是基于 Debian 还是 RedHat
ls /etc | grep redhat-release -qw
if [ $? -eq 0 ]; then
    SYSTEM="RedHat"
else
    SYSTEM="Debian"
fi
## 系统判定变量（系统名称、系统版本、系统版本号）
if [ $SYSTEM = "Debian" ]; then
    SYSTEM_NAME=$(lsb_release -is)
    SYSTEM_VERSION=$(lsb_release -cs)
    SYSTEM_VERSION_NUMBER=$(lsb_release -rs)
elif [ $SYSTEM = "RedHat" ]; then
    SYSTEM_NAME=$(cat /etc/redhat-release | cut -c1-6)
    if [ $SYSTEM_NAME = "CentOS" ]; then
        SYSTEM_VERSION_NUMBER=$(cat /etc/redhat-release | cut -c22-24)
        CENTOS_VERSION=$(cat /etc/redhat-release | cut -c22)
    elif [ $SYSTEM_NAME = "Fedora" ]; then
        SYSTEM_VERSION_NUMBER=$(cat /etc/redhat-release | cut -c16-18)
    fi
fi

## 更换 Docker CE 国内源：
function ChangeMirror() {
    echo -e ''
    echo -e '+---------------------------------------------------+'
    echo -e '|                                                   |'
    echo -e '|   =============================================   |'
    echo -e '|                                                   |'
    echo -e '|         欢迎使用 Docker 国内一键安装脚本          |'
    echo -e '|                                                   |'
    echo -e '|   =============================================   |'
    echo -e '|                                                   |'
    echo -e '+---------------------------------------------------+'
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e '         提供以下国内 Docker CE 源可供选择：'
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e ' *  1)    阿里云'
    echo -e ' *  2)    腾讯云'
    echo -e ' *  3)    华为云'
    echo -e ' *  4)    网易'
    echo -e ' *  4)    搜狐'
    echo -e ' *  6)    清华大学'
    echo -e ' *  7)    浙江大学'
    echo -e ' *  8)    重庆大学'
    echo -e ' *  9)    兰州大学'
    echo -e ' *  10)   中国科技大学'
    echo -e ' *  11)   上海交通大学'
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e "      当前操作系统  $SYSTEM_NAME $SYSTEM_VERSION_NUMBER"
    echo -e "      当前系统时间  $(date "+%Y-%m-%d %H:%M")"
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    CHOICE1=$(echo -e '\033[32m├ 请输入您想使用的国内 Docker CE 源 [ 1~11 ]：\033[0m')
    read -p "$CHOICE1" INPUT
    case $INPUT in
    1)
        SOURCE="mirrors.aliyun.com"
        ;;
    2)
        SOURCE="mirrors.cloud.tencent.com"
        ;;
    3)
        SOURCE="mirrors.huaweicloud.com"
        ;;
    4)
        SOURCE="mirrors.163.com"
        ;;
    5)
        SOURCE="mirrors.sohu.com"
        ;;
    6)
        SOURCE="mirrors.tuna.tsinghua.edu.cn"
        ;;
    7)
        SOURCE="mirrors.zju.edu.cn"
        ;;
    8)
        SOURCE="mirrors.cqu.edu.cn"
        ;;
    9)
        SOURCE="mirror.lzu.edu.cn"
        ;;
    10)
        SOURCE="mirrors.ustc.edu.cn"
        ;;
    11)
        SOURCE="ftp.sjtu.edu.cn"
        ;;
    *)
        SOURCE="mirrors.aliyun.com"
        echo -e ''
        echo -e '\033[33m---------- 输入错误，更新源将默认使用阿里源 ---------- \033[0m'
        sleep 3s
        ;;
    esac
    echo -e ''
}

## 安装 Docker Engine ：
function DockerEngine() {
    ## 配置 Docker CE 国内源
    ChangeMirror

    ## 卸载旧版本
    if [ $SYSTEM = "Debian" ]; then
        apt remove -y docker docker-engine docker.io containerd runc >/dev/null 2>&1
    elif [ $SYSTEM = "RedHat" ]; then
        yum remove -y docker* runc >/dev/null 2>&1
    fi

    ## 安装环境软件包
    if [ $SYSTEM = "Debian" ]; then
        apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    elif [ $SYSTEM = "RedHat" ]; then
        yum install -y yum-utils device-mapper-persistent-data lvm2
    fi

    ## 更换 Docker CE 国内源
    if [ $SYSTEM_NAME = "Ubuntu" ]; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
        add-apt-repository -y "deb [arch=amd64] https://$SOURCE/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
    elif [ $SYSTEM_NAME = "Debian" ]; then
        curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
        add-apt-repository -y "deb [arch=amd64] https://$SOURCE/docker-ce/linux/debian $(lsb_release -cs) stable"
    elif [ $SYSTEM_NAME = "Kali" ]; then
        curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
        add-apt-repository -y "deb [arch=amd64] https://$SOURCE/docker-ce/linux/debian $(lsb_release -cs) stable"
    elif [ $SYSTEM_NAME = "CentOS" ]; then
        yum-config-manager -y --add-repo https://$SOURCE/docker-ce/linux/centos/docker-ce.repo
    elif [ $SYSTEM_NAME = "Fedora" ]; then
        yum config-manager -y --add-repo https://$SOURCE/docker-ce/linux/fedora/docker-ce.repo
    fi

    ## 安装 Docker Engine
    if [ $SYSTEM = "Debian" ]; then
        apt update
        apt install -y docker-ce docker-ce-cli containerd.io
    elif [ $SYSTEM = "RedHat" ]; then
        yum makecache
        yum install -y docker-ce docker-ce-cli containerd.io
    fi

    ## 配置镜像加速器
    ImageAccelerator
}

## 配置镜像加速器：
function ImageAccelerator() {

    ## 创建目录和文件
    ls /etc | grep docker/daemon.json
    if [ $? -eq 0 ]; then
        mv ${DockerConfig} /etc/docker/daemon.json.bak
        echo -e '已备份原有 Docker 配置文件......'
        sleep 2s
    else
        mkdir -p /etc/docker >/dev/null 2>&1
        touch ${DockerConfig}
    fi

    ## 定义镜像加速器
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e '           提供以下国内镜像加速器可供选择：'
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e ' *  1)    官方'
    echo -e ' *  2)    阿里云'
    echo -e ' *  3)    腾讯云'
    echo -e ' *  4)    中科大'
    echo -e ' *  5)    网易'
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    CHOICE2=$(echo -e '\033[32m├ 请输入您想使用的国内镜像加速器 [ 1~5 ]：\033[0m')
    read -p "$CHOICE2" INPUT
    case $INPUT in
    1)
        REGISTRYSOURCE="registry.docker-cn.com"
        ;;
    2)
        REGISTRYSOURCE="registry.cn-hangzhou.aliyuncs.com"
        ;;
    3)
        REGISTRYSOURCE="mirror.ccs.tencentyun.com"
        ;;
    4)
        REGISTRYSOURCE="docker.mirrors.ustc.edu.cn "
        ;;
    5)
        REGISTRYSOURCE="hub-mirror.c.163.com"
        ;;
    *)
        REGISTRYSOURCE="registry.cn-hangzhou.aliyuncs.com"
        echo -e ''
        echo -e '\033[33m---------- 输入错误，将默认使用阿里云镜像加速器 ---------- \033[0m'
        sleep 3s
        ;;
    esac
    echo -e ''

    ## 配置镜像加速器
    echo -e '{\n  "registry-mirrors": ["https://SOURCE"]\n}' >${DockerConfig}
    sed -i "s/SOURCE/$REGISTRYSOURCE/g" ${DockerConfig}

    ## 启动 Docker Engine
    systemctl stop docker
    systemctl enable --now docker
    echo -e ''
}

## 安装 Docker Compose：
function DockerCompose() {
    echo -e '\033[32m---------- 开始下载 Docker Compose ---------- \033[0m'
    echo -e ''
    curl -L https://get.daocloud.io/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m) >/usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e ''
}

DockerEngine
DockerCompose

## 查看版本信息
docker info
docker-compose --version
