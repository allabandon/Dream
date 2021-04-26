#!/bin/env bash
## Author: SuperManito
## License: GPL-2.0
## Modified: 2021-04-23

## 定义目录和文件
RedHatRelease=/etc/redhat-release
DebianSourceList=/etc/apt/sources.list
DebianSourceListBackup=/etc/apt/sources.list.bak
DebianExtendListDirectory=/etc/apt/sources.list.d
DebianExtendListDirectoryBackup=/etc/apt/sources.list.d.bak
RedHatReposDirectory=/etc/yum.repos.d
RedHatReposDirectoryBackup=/etc/yum.repos.d.bak

DockerSourceList=${DebianExtendListDirectory}/docker.list
DockerRepo=${RedHatReposDirectory}/docker-ce.repo
DockerDirectory=/etc/docker
DockerConfig=${DockerDirectory}/daemon.json
DockerConfigBackup=${DockerDirectory}/daemon.json.bak
DockerCompose=/usr/local/bin/docker-compose

## 定义变量
DebianRelease=lsb_release
Architecture=$(uname -m)
SYSTEM_DEBIAN=Debian
SYSTEM_UBUNTU=Ubuntu
SYSTEM_KALI=Kali
SYSTEM_REDHAT=RedHat
SYSTEM_CENTOS=CentOS
SYSTEM_FEDORA=Fedora
DOCKER_COMPOSE_URL=https://get.daocloud.io/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)

## 判定当前系统基于 Debian or RedHat
if [ -f ${RedHatRelease} ]; then
    SYSTEM=${SYSTEM_REDHAT}
else
    SYSTEM=${SYSTEM_DEBIAN}
fi

## 系统判定变量（名称、版本、版本号、使用架构）
if [ ${SYSTEM} = ${SYSTEM_DEBIAN} ]; then
    SYSTEM_NAME=$(${DebianRelease} -is)
    SYSTEM_VERSION=$(${DebianRelease} -cs)
    SYSTEM_VERSION_NUMBER=$(${DebianRelease} -rs)
elif [ ${SYSTEM} = ${SYSTEM_REDHAT} ]; then
    SYSTEM_NAME=$(cat ${RedHatRelease} | cut -c1-6)
    if [ ${SYSTEM_NAME} = ${SYSTEM_CENTOS} ]; then
        SYSTEM_VERSION_NUMBER=$(cat ${RedHatRelease} | cut -c22-24)
        CENTOS_VERSION=$(cat ${RedHatRelease} | cut -c22)
    elif [ ${SYSTEM_NAME} = ${SYSTEM_FEDORA} ]; then
        SYSTEM_VERSION_NUMBER=$(cat ${RedHatRelease} | cut -c16-18)
    fi
fi

if [ $Architecture = "x86_64" ]; then
    SYSTEM_ARCH=x86_64
    SOURCE_ARCH=amd64
elif [ $Architecture = "aarch64" ]; then
    SYSTEM_ARCH=arm64
    SOURCE_ARCH=arm64
elif [ $Architecture = "armv*" ]; then
    SYSTEM_ARCH=armhf
    SOURCE_ARCH=armhf
elif [ $Architecture = "*i?86*" ]; then
    SYSTEM_ARCH=x86_32
    echo -e '\n\033[31m---------- 抱歉，Docker Engine 不支持安装在 x86_32 架构的环境上！ ---------- \033[0m'
    exit 1
else
    SYSTEM_ARCH=${Architecture}
    SOURCE_ARCH=armhf
fi

## 定义更新源分支名称
SOURCE_BRANCH=${SYSTEM_NAME,,}

clear ## 清空终端所有已显示的内容

## 组合各个函数模块
function CombinationFunction() {
    EnvJudgment
    ChooseMirrors
    DockerEngine
    DockerCompose
    ShowVersion
}

## 环境判定：
function EnvJudgment() {
    ## 权限判定：
    if [ $UID -ne 0 ]; then
        echo -e '\033[31m ------------ Permission no enough, please use user ROOT! ------------ \033[0m'
        exit
    fi
    ## 网络环境判定：
    ping -c 1 www.baidu.com >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "\033[31m ----- Network connection error.Please check the network environment and try again later! ----- \033[0m"
        exit
    fi
}

## 安装 Docker Engine ：
function DockerEngine() {
    ## 卸载旧版本
    if [ $SYSTEM = ${SYSTEM_DEBIAN} ]; then
        systemctl disable --now docker >/dev/null 2>&1
        apt-get remove -y docker* containerd runc >/dev/null 2>&1
    elif [ $SYSTEM = ${SYSTEM_REDHAT} ]; then
        systemctl disable --now docker >/dev/null 2>&1
        yum remove -y docker* >/dev/null 2>&1
    fi

    ## 安装环境软件包
    if [ $SYSTEM = ${SYSTEM_DEBIAN} ]; then
        apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    elif [ $SYSTEM = ${SYSTEM_REDHAT} ]; then
        yum install -y yum-utils device-mapper-persistent-data lvm2
    fi

    ## 安装 Docker Engine
    if [ $SYSTEM = ${SYSTEM_DEBIAN} ]; then
        apt-get update
        apt-get install -y docker-ce docker-ce-cli containerd.io
    elif [ $SYSTEM = ${SYSTEM_REDHAT} ]; then
        yum makecache
        yum install -y docker-ce docker-ce-cli containerd.io
    fi

    ## 启动 Docker Engine
    systemctl stop docker >/dev/null 2>&1
    systemctl enable --now docker
}

## 安装 Docker Compose：
function DockerCompose() {
    CHOICE_C=$(echo -e '\n\033[32m└ 是否安装 Docker Compose [ Y/n ]：\033[0m')
    read -p "${CHOICE_C}" INPUT
    case $INPUT in
    [Yy]*)
        echo -e ''
        curl -L ${DOCKER_COMPOSE_URL} >${DockerCompose}
        chmod +x ${DockerCompose}
        echo -e ''
        ;;
    [Nn]*) ;;
    *)
        echo -e '\n\033[33m---------- 输入错误，默认不安装 Docker Compose ---------- \033[0m\n'
        ;;
    esac
}

## 查看版本信息
function ShowVersion() {
    docker info
    echo -e ''
    docker compose --version
    echo -e ''
}

CombinationFunction
