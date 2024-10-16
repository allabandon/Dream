#!/bin/bash

# 确保脚本以超级用户权限运行
if [[ $EUID -ne 0 ]]; then
   echo "此脚本必须以root权限运行。请使用sudo或以root用户运行。" 
   exit 1
fi

# 检查所需工具是否已安装
REQUIRED_TOOLS=("wget" "7z" "tar" "chmod" "systemctl" "zen_nospam" "flatpak" "curl" "pnpm")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "必要的工具未安装：$tool。请先安装 $tool。"
        exit 1
    fi
done

# 定义功能1到功能10的函数（功能3和功能4已删除）
function feature1() {
    echo "功能1: 修改内置flatpak源为上交大镜像源..."

    # 执行修改flatpak源的命令
    flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
    if [[ $? -ne 0 ]]; then
        echo "修改flatpak源失败。请检查命令或网络连接。"
    else
        echo -e "\033[32m成功修改flatpak源为上交大镜像源。\033[0m"
    fi
}

function feature2() {
    echo "功能2: 修改内置flatpak源为官方源..."

    # 执行修改flatpak源为官方源的命令
    flatpak remote-modify flathub --url=https://flathub.org/repo/flathub.flatpakrepo
    if [[ $? -ne 0 ]]; then
        echo "修改flatpak源为官方源失败。请检查命令或网络连接。"
    else
        echo -e "\033[32m成功修改flatpak源为官方源。\033[0m"
    fi
}

# 定义功能3: 安装插件商店
function feature3() {
    while true; do
        echo "========================="
        echo "        插件商店安装"
        echo "========================="
        echo "1. 官方安装"
        echo "2. 国内安装"
        echo "3. 卸载"
        echo "0. 返回主菜单"
        echo -n "请输入选项 [0-3]: "
        read -r sub_choice
        case $sub_choice in
            1)
                echo "正在进行官方安装..."
                # 这里添加官方安装的命令
                # 示例命令: flatpak install flathub com.example.PluginStore
				curl -L https://github.com/SteamDeckHomebrew/decky-loader/raw/main/dist/install_prerelease.sh | sh
                ;;
            2)
                echo "正在进行国内安装..."
                # 这里添加国内安装的命令
                # 示例命令: flatpak install flathub cn.example.PluginStore
				curl -L http://dl.ohmydeck.net | sh
                ;;
            3)
                echo "正在卸载插件商店..."
                # 这里添加卸载的命令
                # 示例命令: flatpak uninstall com.example.PluginStore
				curl -L https://github.com/SteamDeckHomebrew/decky-loader/raw/main/dist/uninstall.sh | sh
				pnpm update decky-frontend-lib --latest
                ;;
            0)
                echo "返回主菜单..."
                break
                ;;
            *)
                echo "无效的选项，请重新输入。"
                ;;
        esac
        echo ""
    done
}


# 定义功能4：安装加速插件TOMOON
function feature2() {
    echo "功能4：安装加速插件TOMOON"

    # 在此添加功能4的具体命令
    curl -L http://i.ohmydeck.net | sh
    if [[ $? -ne 0 ]]; then
        echo "安装加速插件TOMOON失败。请检查命令或网络连接。"
    else
        echo -e "\033[32m成功安装加速插件TOMOON。\033[0m"
    fi
}

# 定义功能5：SteamOS原生Wallpaper Engine
function feature2() {
    echo "功能5：SteamOS原生Wallpaper Engine"

    # 在此添加功能4的具体命令
    git clone https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin
	cd SteamOS-wallpaper-engine-kde-plugin
	chmod +x ./install.sh
	./install.sh
	systemctl --user restart plasma-plasmashell.service
    if [[ $? -ne 0 ]]; then
        echo "安装加速插件TOMOON失败。请检查命令或网络连接。"
    else
        echo -e "\033[32m成功安装加速插件TOMOON。\033[0m"
    fi
}

function feature6() {
    echo "功能6: 示例功能6正在执行..."
    # 在此添加功能6的具体命令
    sleep 1
    echo "功能6执行完成。"
}

function feature7() {
    echo "功能7: 示例功能7正在执行..."
    # 在此添加功能7的具体命令
    sleep 1
    echo "功能7执行完成。"
}

function feature8() {
    echo "功能8: 示例功能8正在执行..."
    # 在此添加功能8的具体命令
    sleep 1
    echo "功能8执行完成。"
}

function feature9() {
    echo "功能9: 示例功能9正在执行..."
    # 在此添加功能9的具体命令
    sleep 1
    echo "功能9执行完成。"
}

# 定义功能10: 汉化已下载插件
function feature10() {
    echo "功能10: 汉化已下载插件正在执行..."

    # 定义变量
    SERVICE_NAME="plugin_loader"
    DOWNLOAD_DIR="/home/deck/Downloads/decky-loader-chinese"
    HOMEBREW_URL="https://gitee.com/songy171/decky-chs/raw/master/homebrew.7z"
    PLUGINS_URL="https://vip.123pan.cn/1824872873/releases/decky-loader/Chinese/plugins.tar.gz"
    HOMEBREW_ARCHIVE="$DOWNLOAD_DIR/homebrew.7z"
    PLUGINS_ARCHIVE="$DOWNLOAD_DIR/plugins.tar.gz"
    PLUGIN_SOURCE_DIR="$DOWNLOAD_DIR/plugins"
    PLUGIN_TARGET_DIR="/home/deck/homebrew/plugins"

    # 停止 plugin_loader 服务
    echo "正在停止服务：$SERVICE_NAME..."
    systemctl stop "$SERVICE_NAME"
    if [[ $? -ne 0 ]]; then
        echo "无法停止服务 $SERVICE_NAME。请检查服务名称或权限。"
        return
    fi
    echo "服务 $SERVICE_NAME 已停止。"

    # 创建目标下载目录
    echo "创建下载目录：$DOWNLOAD_DIR"
    mkdir -p "$DOWNLOAD_DIR"
    if [[ $? -ne 0 ]]; then
        echo "无法创建目录 $DOWNLOAD_DIR。请检查权限。"
        return
    fi

    # 下载 homebrew.7z 文件
    echo "下载 homebrew.7z 文件..."
    wget -O "$HOMEBREW_ARCHIVE" "$HOMEBREW_URL"
    if [[ $? -ne 0 ]]; then
        echo "下载 homebrew.7z 失败。请检查URL或网络连接。"
        return
    fi

    # 解压 homebrew.7z 文件
    echo "解压 homebrew.7z 文件..."
    7z x "$HOMEBREW_ARCHIVE" -o"$DOWNLOAD_DIR/"
    if [[ $? -ne 0 ]]; then
        echo "解压 homebrew.7z 失败。请确保7z已安装且文件未损坏。"
        return
    fi

    # 下载 plugins.tar.gz 文件
    echo "下载 plugins.tar.gz 文件..."
    wget -P "$DOWNLOAD_DIR" "$PLUGINS_URL"
    if [[ $? -ne 0 ]]; then
        echo "下载 plugins.tar.gz 失败。请检查URL或网络连接。"
        return
    fi

    # 解压 plugins.tar.gz 文件
    echo "解压 plugins.tar.gz 文件..."
    tar -xzf "$PLUGINS_ARCHIVE" -C "$DOWNLOAD_DIR"
    if [[ $? -ne 0 ]]; then
        echo "解压 plugins.tar.gz 失败。请确保tar已安装且文件未损坏。"
        return
    fi

    # 修改目录权限
    echo "设置目录权限为777（所有用户可读、写、执行）..."
    chmod -R 777 "$DOWNLOAD_DIR"
    if [[ $? -ne 0 ]]; then
        echo "设置权限失败。请检查权限设置。"
        return
    fi

    # 定义处理插件的函数
    process_plugin() {
        local plugin_folder_name=$1
        local plugin_display_name=$2

        if [[ -d "$PLUGIN_TARGET_DIR/$plugin_folder_name" ]]; then
            cp -rf "$PLUGIN_SOURCE_DIR/$plugin_folder_name" "$PLUGIN_TARGET_DIR/"
            if [[ $? -eq 0 ]]; then
                echo -e "\033[38;5;207m已汉化插件：$plugin_display_name\033[0m"
                sleep 1
            else
                echo "复制插件 $plugin_display_name 失败。"
            fi
        else
            echo "目标插件目录不存在：$PLUGIN_TARGET_DIR/$plugin_folder_name"
        fi
    }

    # 处理所有插件
    echo "开始汉化插件..."
    process_plugin "tomoon" "科学上网(tomoon)"
    process_plugin "SDH-PlayTime" "游戏时长统计(PlayTime)"
    process_plugin "protondb-decky" "游戏兼容性提示(ProtonDB Badges)"
    process_plugin "PowerTools" "电源工具箱(PowerTools)"
    process_plugin "decky-steamgriddb" "封面下载(SteamGridDB)"
    process_plugin "steam-deck-battery-tracker" "电量追踪器(Battery Tracker)"
    process_plugin "CheatDeck" "游戏修改器(CheatDeck)"
    process_plugin "decky-storage-cleaner" "系统空间清理(Storage Cleaner)"
    process_plugin "Fantastic" "风扇调节(Fantastic)"
    process_plugin "SDH-AnimationChanger" "开机动画(Animation Changer)"
    process_plugin "SDH-CssLoader" "系统主题(CSS Loader)"
    process_plugin "SDH-AudioLoader" "自定义音效(Audio Loader)"
    process_plugin "Decky-Undervolt" "APU降压(Decky-Undervolt)"
    process_plugin "Junk-Store" "垃圾商店(Junk-Store)"
    process_plugin "DeckWebBrowser" "网页浏览器(web browser)"
    echo "插件汉化完成。"

    # 清理下载的文件和目录
    echo "清理临时文件和目录..."
    rm -rf "$DOWNLOAD_DIR"
    if [[ $? -ne 0 ]]; then
        echo "清理失败。请手动删除目录 $DOWNLOAD_DIR。"
        return
    fi
    echo "临时文件已清理。"

    # 输出重新启动服务的消息
    echo -e "\e[34m重新开启插件商店服务...\e[0m"

    # 重新启动 plugin_loader 服务
    systemctl start "$SERVICE_NAME"
    if [[ $? -ne 0 ]]; then
        echo "无法启动服务 $SERVICE_NAME。请检查服务状态。"
        return
    fi
    echo "服务 $SERVICE_NAME 已重新启动。"

    # 显示完成通知
    zen_nospam --info --text="汉化完毕！" --width=250 --height=100

    echo "功能10: 汉化已下载插件执行完成。"
}

# 显示菜单
while true; do
    echo "========================="
    echo "        主菜单"
    echo "========================="
    echo "1. 修改内置flatpak源为上交大镜像源"
    echo "2. 修改内置flatpak源为官方源"
    echo "3. 安装插件商店"
    echo "5. 功能5: 示例功能5"
    echo "6. 功能6: 示例功能6"
    echo "7. 功能7: 示例功能7"
    echo "8. 功能8: 示例功能8"
    echo "9. 功能9: 示例功能9"
    echo "10. 汉化已下载插件"
    echo "0. 退出"
    echo -n "请输入选项 [0-10]（1、2、3、5-10）： "
    read -r choice
    case $choice in
        1)
            feature1
            ;;
        2)
            feature2
            ;;
        3)
            feature3
            ;;
        5)
            feature5
            ;;
        6)
            feature6
            ;;
        7)
            feature7
            ;;
        8)
            feature8
            ;;
        9)
            feature9
            ;;
        10)
            feature10
            ;;
        0)
            echo "退出脚本。"
            exit 0
            ;;
        *)
            echo "无效的选项，请重新输入。"
            ;;
    esac
    echo ""
done
