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

## 更换 Docker 国内源：
function ChooseMirrors() {
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
    echo -e '  提供以下国内 Docker CE 和 Docker Hub 源可供选择：'
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e ' Docker CE '
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
    echo -e ' *  10)   上海交通大学'
    echo -e ' *  11)   中国科学技术大学'
    echo -e ''
    echo -e ' Docker Hub（镜像加速器） '
    echo -e ''
    echo -e ' *  1)    阿里云'
    echo -e ' *  2)    腾讯云'
    echo -e ' *  3)    官方中国区'
    echo -e ' *  4)    DaoCloud'
    echo -e ' *  5)    中国科学技术大学'
    echo -e ' *  6)    网易'
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e "         运行环境  ${SYSTEM_NAME} ${SYSTEM_VERSION_NUMBER} ${SYSTEM_ARCH}"
    echo -e "         系统时间  $(date "+%Y-%m-%d %H:%M:%S")"
    echo -e ''
    echo -e '#####################################################'
    CHOICE_A=$(echo -e '\n\033[32m└ 请选择并输入您想使用的 Docker CE 国内源 [ 1~11 ]：\033[0m')
    read -p "${CHOICE_A}" INPUT
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
        SOURCE="ftp.sjtu.edu.cn"
        ;;
    11)
        SOURCE="mirrors.ustc.edu.cn"
        ;;
    *)
        SOURCE="mirrors.aliyun.com"
        echo -e '\n\033[33m---------- 输入错误，更新源将默认使用阿里源 ---------- \033[0m'
        sleep 2s
        ;;
    esac
    echo -e ''

    ## 定义镜像加速器
    CHOICE_B=$(echo -e '\033[32m└ 请选择并输入您想使用的 Docker Hub 国内源 [ 1~6 ]：\033[0m')
    read -p "${CHOICE_B}" INPUT
    case $INPUT in
    1)
        REGISTRY_SOURCE="registry.cn-hangzhou.aliyuncs.com"
        ;;
    2)
        REGISTRY_SOURCE="mirror.ccs.tencentyun.com"
        ;;
    3)
        REGISTRY_SOURCE="registry.docker-cn.com"
        ;;
    4)
        REGISTRY_SOURCE="f1361db2.m.daocloud.io"
        ;;
    5)
        REGISTRY_SOURCE="docker.mirrors.ustc.edu.cn"
        ;;
    6)
        REGISTRY_SOURCE="hub-mirror.c.163.com"
        ;;
    *)
        REGISTRY_SOURCE="registry.cn-hangzhou.aliyuncs.com"
        echo -e '\033[33m---------- 输入错误，将默认使用阿里云镜像加速器 ---------- \033[0m'
        sleep 3s
        ;;
    esac
    echo -e ''
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

    ## 删除旧的 Docker CE 源
    if [ $SYSTEM = ${SYSTEM_DEBIAN} ]; then
        sed -i '/docker-ce/d' ${DebianSourceList}
        rm -rf ${DockerSourceList}
    elif [ $SYSTEM = ${SYSTEM_REDHAT} ]; then
        rm -rf ${DockerRepo}
    fi

    ## 配置 Docker CE 源
    if [ $SYSTEM = ${SYSTEM_DEBIAN} ]; then
        if [ $SYSTEM_NAME = ${SYSTEM_KALI} ]; then
            curl -fsSL https://${SOURCE}/docker-ce/linux/debian/gpg | apt-key add -
        else
            curl -fsSL https://${SOURCE}/docker-ce/linux/${SOURCE_BRANCH}/gpg | apt-key add -
        fi

        echo "deb [arch=${SOURCE_ARCH}] https://${SOURCE}/docker-ce/linux/${SOURCE_BRANCH} $SYSTEM_VERSION stable" | tee ${DockerSourceList} >/dev/null 2>&1

        if [ $SYSTEM_NAME = ${SYSTEM_KALI} ]; then
            sed -i "s/${SYSTEM_VERSION}/buster/g" ${DockerSourceList}
            sed -i "s/${SOURCE_BRANCH}/debian/g" ${DockerSourceList}
        fi
    elif [ $SYSTEM = ${SYSTEM_REDHAT} ]; then
        yum-config-manager -y --add-repo https://${SOURCE}/docker-ce/linux/${SOURCE_BRANCH}/docker-ce.repo
    fi

    ## 安装 Docker Engine
    if [ $SYSTEM = ${SYSTEM_DEBIAN} ]; then
        apt-get update
        apt-get install -y docker-ce docker-ce-cli containerd.io
    elif [ $SYSTEM = ${SYSTEM_REDHAT} ]; then
        yum makecache
        yum install -y docker-ce docker-ce-cli containerd.io
    fi

    ## 配置镜像加速器
    ImageAccelerator
}

## 配置镜像加速器：
function ImageAccelerator() {
    ## 创建目录和文件
    if [ -d ${DockerDirectory} ] && [ -e ${DockerConfig} ]; then
        if [ -e ${DockerConfigBackup} ]; then
            echo -e "\n\033[32m└ 检测到已备份的 Docker 配置文件，跳过备份操作 ...... \033[0m\n"
        else
            cp -rf ${DockerConfig} ${DockerConfigBackup}
            echo -e "\n\033[32m└ 已备份原有 Docker 配置文件至 ${DockerConfigBackup} ...... \033[0m\n"
        fi
        sleep 2s
    else
        mkdir -p ${DockerDirectory} >/dev/null 2>&1
        touch ${DockerConfig}
    fi

    ## 配置镜像加速器
    echo -e '{\n  "registry-mirrors": ["https://SOURCE"]\n}' >${DockerConfig}
    sed -i "s/SOURCE/$REGISTRY_SOURCE/g" ${DockerConfig}

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
