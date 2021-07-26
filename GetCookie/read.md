青龙机器人 getcookie 远程扫码获取 cookie 功能修复教程：

由于 github 项目已经移除了机器人扫码获取 cookie功能。如果发现机器人升级后无法扫码了，修复方法：

a) 将 getcookie.py 脚本移动到机器人相关文件夹：
方法①  之前建立容器时，已经将容器路径 /ql/jbot/ 映射给主机的，直接将 getcookie.py 拷贝到 /ql/jbot/bot/ 或 /ql/jbot/diy/ 。
方案② 将 getcookie.py 文件保存至容器内 /ql/config/ 路径；主机运行以下命令将其移动到机器人的脚本文件夹
docker exec -it qinglong bash -c "mv /ql/config/getcookie.py /ql/jbot/bot/"
或
docker exec -it qinglong bash -c "mv /ql/config/getcookie.py /ql/jbot/diy/"
方案③ 将 getcookie.py 文件保存至容器内 /ql/config/ 路径。在你的 TG 机器人中运行以下命令将其移动到机器人的脚本文件夹(确保机器人配置文件 /ql/config/bot.json 的 CMD 命令是 true 开启状态)：
/cmd mv /ql/config/getcookie.py /ql/jbot/bot/
或
/cmd mv /ql/config/getcookie.py /ql/jbot/diy/

c) 主机执行
docker exec -it qinglong ql bot
或者 TG 机器人执行
/cmd ql bot
重启机器人后即可生效
