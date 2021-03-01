################################## 临时屏蔽某个Cookie（选填） ##################################
## 如果某些Cookie已经失效了，但暂时还没法更新，可以使用此功能在不删除该Cookie和重新修改Cookie编号的前提下，临时屏蔽掉某些编号的Cookie
## 多个Cookie编号以半角的空格分隔，两侧一对半角双引号，使用此功能后，在运行js脚本时账户编号将发生变化
## 举例1：TempBlockCookie="2"    临时屏蔽掉Cookie2
## 举例2：TempBlockCookie="2 4"  临时屏蔽掉Cookie2和Cookie4
## 如果只是想要屏蔽某个账号不玩某些小游戏，可以参考下面 case 这个命令的例子来控制，脚本名称请去掉后缀 “.js”
## case $1 in
##   jd_fruit)
##     TempBlockCookie="5"      # 账号5不玩东东农场
##     ;;
##   jd_dreamFactory | jd_jdfactory)
##     TempBlockCookie="2"      # 账号2不玩京喜工厂和东东工厂
##     ;;
##   jd_jdzz | jd_joy)
##     TempBlockCookie="3 6"    # 账号3、账号6不玩京东赚赚和宠汪汪
##     ;;
##  esac
TempBlockCookie=""


################################## 定义是否自动删除失效的脚本与定时任务（选填） ##################################
## 有的时候，某些JS脚本只在特定的时间有效，过了时间就失效了，需要自动删除失效的本地定时任务，则设置为 "true" ，否则请设置为 "false"
## 检测文件：LXK9301/jd_scripts 仓库中的 docker/crontab_list.sh，和 shylocks/Loon 仓库中的 docker/crontab_list.sh
## 当设置为 "true" 时，会自动从检测文件中读取比对删除的任务（识别以“jd_”、“jr_”、“jx_”开头的任务）
## 当设置为 "true" 时，脚本只会删除一整行失效的定时任务，不会修改其他现有任务，所以任何时候，你都可以自己调整你的crontab.list
## 当设置为 "true" 时，如果你有添加额外脚本是以“jd_”“jr_”“jx_”开头的，如检测文件中，会被删除，不是以“jd_”“jr_”“jx_”开头的任务则不受影响
AutoDelCron="true"


################################## 定义是否自动增加新的本地定时任务（选填） ##################################
## LXK9301 大佬会在有需要的时候，增加定时任务，如需要本地自动增加新的定时任务，则设置为 "true" ，否则请设置为 "false"
## 检测文件：LXK9301/jd_scripts 仓库中的 docker/crontab_list.sh，和 shylocks/Loon 仓库中的 docker/crontab_list.sh
## 当设置为 "true" 时，如果检测到检测文件中有增加新的定时任务，那么在本地也增加（识别以“jd_”、“jr_”、“jx_”开头的任务）
## 当设置为 "true" 时，会自动从检测文件新增加的任务中读取时间，该时间为北京时间
## 当设置为 "true" 时，脚本只会增加新的定时任务，不会修改其他现有任务，所以任何时候，你都可以自己调整你的crontab.list
AutoAddCron="true"


################################## 定义删除日志的时间（选填） ##################################
## 定义在运行删除旧的日志任务时，要删除多少天以前的日志，请输入正整数，不填则禁用删除日志的功能
RmLogDaysAgo="7"


################################## 定义随机延迟启动任务（选填） ##################################
## 如果任务不是必须准点运行的任务，那么给它增加一个随机延迟，由你定义最大延迟时间，单位为秒，如 RandomDelay="300" ，表示任务将在 1-300 秒内随机延迟一个秒数，然后再运行
## 在crontab.list中，在每小时第0-2分、第30-31分、第59分这几个时间内启动的任务，均算作必须准点运行的任务，在启动这些任务时，即使你定义了RandomDelay，也将准点运行，不启用随机延迟
## 在crontab.list中，除掉每小时上述时间启动的任务外，其他任务在你定义了 RandomDelay 的情况下，一律启用随机延迟，但如果你按照Wiki教程给某些任务添加了 "now"，那么这些任务也将无视随机延迟直接启动
RandomDelay="300"


################################## 定义User-Agent（选填） ##################################
## 自定义LXK9301大佬仓库里京东系列js脚本的User-Agent，不懂不知不会User-Agent的请不要随意填写内容，随意填写了出错概不负责
## 如需使用，请自行解除下一行注释
# export JD_USER_AGENT=""


################################## 定义通知TOKEN（选填） ##################################
## 想通过什么渠道收取通知，就填入对应渠道的值
## 1. ServerChan，教程：http://sc.ftqq.com/3.version
export PUSH_KEY="SCU39522Ta60c9ddd5a4beb82f41570f9c73f1bfa5c382dc78862a"

## 2. BARK，教程（看BARK_PUSH和BARK_SOUND的说明）：https://gitee.com/lxk0301/jd_scripts/blob/master/githubAction.md
export BARK_PUSH="T2MQRKZn3evErMxMgNn9Jh"
export BARK_SOUND=""

## 3. Telegram，如需使用，TG_BOT_TOKEN和TG_USER_ID必须同时赋值，教程：https://gitee.com/lxk0301/jd_scripts/blob/master/backUp/TG_PUSH.md
export TG_BOT_TOKEN=""
export TG_USER_ID=""

## 4. 钉钉，教程（看DD_BOT_TOKEN和DD_BOT_SECRET部分）：https://gitee.com/lxk0301/jd_scripts/blob/master/githubAction.md
export DD_BOT_TOKEN=""
export DD_BOT_SECRET=""

## 5. iGot聚合推送，支持多方式推送，填写iGot的推送key。教程：https://gitee.com/lxk0301/jd_scripts/blob/master/githubAction.md
export IGOT_PUSH_KEY=""

## 6. Push Plus，微信扫码登录后一对一推送或一对多推送，参考文档：http://pushplus.hxtrip.com/
## 其中PUSH_PLUS_USER是一对多推送的“群组编码”（一对多推送下面->您的群组(如无则新建)->群组编码）注:(1、需订阅者扫描二维码 2、如果您是创建群组所属人，也需点击“查看二维码”扫描绑定，否则不能接受群组消息推送)，只填PUSH_PLUS_TOKEN默认为一对一推送
export PUSH_PLUS_TOKEN=""
export PUSH_PLUS_USER=""

## 7. 企业微信机器人消息推送 webhook 后面的 key，文档：https://work.weixin.qq.com/api/doc/90000/90136/91770
export QYWX_KEY=""

## 8. 企业微信应用消息推送的值，教程：https://note.youdao.com/ynoteshare1/index.html?id=351e08a72378206f9dd64d2281e9b83b&type=note
## 依次填上corpid的值,corpsecret的值,touser的值,agentid,media_id的值，注意用,号隔开，例如："wwcff56746d9adwers,B-791548lnzXBE6_BWfxdf3kSTMJr9vFEPKAbh6WERQ,mingcheng,1000001,2COXgjH2UIfERF2zxrtUOKgQ9XklUqMdGSWLBoW_lSDAdafat"
export QYWX_AM=""


################################## 定义每日签到的通知形式（选填） ##################################
## js脚本每日签到提供3种通知方式，分别为：
## 关闭通知，那么请在下方填入0
## 简洁通知，那么请在下方填入1，其效果见：https://github.com/LXK9301/jd_scripts/blob/master/icon/bean_sign_simple.jpg
## 原始通知，那么请在下方填入2，如果不填也默认为2，内容比较长，这也是默认通知方式
NotifyBeanSign="2"


################################## 定义每日签到每个接口间的延迟时间（选填） ##################################
## 默认每个签到接口并发无延迟，如需要依次进行每个接口，请自定义延迟时间，单位为毫秒，延迟作用于每个签到接口, 如填入延迟则切换顺序签到(耗时较长)
export JD_BEAN_STOP=""


################################## 定义东东农场互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MyFruit1="f5037c0b238b4f4093409165bbec2929"
MyFruit2="2a748751c2ab49dc9029b74631e957d9"
MyFruit3="be8a0925689942d6b9c696aaca807a68"
MyFruit4="e53fad47742a4d89971fffc80c920308"
MyFruit5="00dacfe9d96f4c3e90f90ccecada52f6"
MyFruit6="b3108a66f82e4ed5b1195be7860a1a55"
MyFruitA="c9cddfdc23e9473dbe33ff94f8becf5d"
MyFruitB="c9cddfdc23e9473dbe33ff94f8becf5d"

ForOtherFruit1="${MyFruit2}@${MyFruit3}@${MyFruit4}@${MyFruit5}@${MyFruit6}@${MyFruitA}"
ForOtherFruit2="${MyFruit1}@${MyFruit3}@${MyFruit4}@${MyFruit5}@${MyFruit6}@${MyFruitA}"
ForOtherFruit3="${MyFruit1}@${MyFruit2}@${MyFruit4}@${MyFruit5}@${MyFruit6}@${MyFruitA}"
ForOtherFruit4="${MyFruit1}@${MyFruit2}@${MyFruit3}@${MyFruit5}@${MyFruit6}@${MyFruitA}"
ForOtherFruit5="${MyFruit1}@${MyFruit2}@${MyFruit3}@${MyFruit4}@${MyFruit6}@${MyFruitA}"
ForOtherFruit6="${MyFruit1}@${MyFruit2}@${MyFruit3}@${MyFruit4}@${MyFruit6}@${MyFruitA}"
ForOtherFruitA="${MyFruit1}@${MyFruit2}@${MyFruit3}@${MyFruit4}@${MyFruit6}@${MyFruit1}"

################################## 定义东东萌宠互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MyPet1="MTAxODcxOTI2NTAwMDAwMDAyNzE4ODA0Nw=="
MyPet2="MTAxODExNTM5NDAwMDAwMDA0MDMxOTY0NQ=="
MyPet3="MTAxODc2NTE0NzAwMDAwMDAyMDI3NTc4OQ=="
MyPet4=""
MyPet5=""
MyPet6=""
MyPetA=""
MyPetB=""

ForOtherPet1="${MyPet2}@${MyPet3}@${MyPet4}@${MyPet5}@${MyPet6}@${MyPetA}"
ForOtherPet2="${MyPet1}@${MyPet3}@${MyPet4}@${MyPet5}@${MyPet6}@${MyPetA}"
ForOtherPet3="${MyPet2}@${MyPet1}@${MyPet4}@${MyPet5}@${MyPet6}@${MyPetA}"
ForOtherPet4="${MyPet2}@${MyPet3}@${MyPet1}@${MyPet5}@${MyPet6}@${MyPetA}"
ForOtherPet5="${MyPet2}@${MyPet3}@${MyPet4}@${MyPet1}@${MyPet6}@${MyPetA}"
ForOtherPet6="${MyPet2}@${MyPet3}@${MyPet4}@${MyPet5}@${MyPet1}@${MyPetA}"
ForOtherPetA="${MyPet2}@${MyPet3}@${MyPet4}@${MyPet5}@${MyPet6}@${MyPet1}"

################################## 定义种豆得豆互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MyBean1="igefhjvuw6xvskwf4hra425pb3i7mflq3he5jcq"
MyBean2="4npkonnsy7xi3knyu4foyzxyifkvrbzdy4jkdpy"
MyBean3="olmijoxgmjutyguyx6rk7ktzemunvnj5vp5c3ri"
MyBean4=""
MyBean5=""
MyBean6=""
MyBeanA=""
MyBeanB=""

ForOtherBean1="${MyBean2}@${MyBean3}@${MyBean4}@${MyBean5}@${MyBean6}@${MyBeanA}"
ForOtherBean2="${MyBean1}@${MyBean3}@${MyBean4}@${MyBean5}@${MyBean6}@${MyBeanA}"
ForOtherBean3="${MyBean2}@${MyBean1}@${MyBean4}@${MyBean5}@${MyBean6}@${MyBeanA}"
ForOtherBean4="${MyBean2}@${MyBean3}@${MyBean1}@${MyBean5}@${MyBean6}@${MyBeanA}"
ForOtherBean5="${MyBean2}@${MyBean3}@${MyBean4}@${MyBean1}@${MyBean6}@${MyBeanA}"
ForOtherBean6="${MyBean2}@${MyBean3}@${MyBean4}@${MyBean5}@${MyBean1}@${MyBeanA}"
ForOtherBeanA="${MyBean2}@${MyBean3}@${MyBean4}@${MyBean5}@${MyBean6}@${MyBean1}"


################################## 定义京喜工厂互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MyDreamFactory1="F5MhtGqrZSEiNUuvvQSFZg=="
MyDreamFactory2="TZ4-Tp3vKgtq7ZBMZ4qLlg=="
MyDreamFactory3=""
MyDreamFactory4=""
MyDreamFactory5=""
MyDreamFactory6="8jCfQ1mgJTJ4jrSbwI4xgw=="
MyDreamFactoryA="U58jz6mxAPb3GPyTdaosew=="
MyDreamFactoryB=""

ForOtherDreamFactory1="${MyDreamFactory2}@${MyDreamFactory3}@${MyDreamFactory4}@${MyDreamFactory5}@${MyDreamFactory6}@${MyDreamFactoryA}"
ForOtherDreamFactory2="${MyDreamFactory1}@${MyDreamFactory1}@${MyDreamFactory4}@${MyDreamFactory5}@${MyDreamFactory6}@${MyDreamFactoryA}"
ForOtherDreamFactory3="${MyDreamFactory2}@${MyDreamFactory3}@${MyDreamFactory4}@${MyDreamFactory5}@${MyDreamFactory6}@${MyDreamFactoryA}"
ForOtherDreamFactory4="${MyDreamFactory2}@${MyDreamFactory3}@${MyDreamFactory1}@${MyDreamFactory5}@${MyDreamFactory6}@${MyDreamFactoryA}"
ForOtherDreamFactory5="${MyDreamFactory2}@${MyDreamFactory3}@${MyDreamFactory4}@${MyDreamFactory1}@${MyDreamFactory6}@${MyDreamFactoryA}"
ForOtherDreamFactory6="${MyDreamFactory2}@${MyDreamFactory3}@${MyDreamFactory4}@${MyDreamFactory5}@${MyDreamFactory1}@${MyDreamFactoryA}"
ForOtherDreamFactoryA="${MyDreamFactory2}@${MyDreamFactory3}@${MyDreamFactory4}@${MyDreamFactory5}@${MyDreamFactory6}@${MyDreamFactory1}"


################################## 定义东东工厂互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MyJdFactory1="T0205KkcAGh5iw2wYGCI5Yt3CjVWnYaS5kRrbA"
MyJdFactory2="T0225KkcR01N9VWEchrzkf5ZcACjVWnYaS5kRrbA"
MyJdFactory3="T0225KkcRkoa9wLQIRuinPBfIACjVWnYaS5kRrbA"
MyJdFactory4="T0225KkcRUod8ALedBrzwfZffACjVWnYaS5kRrbA"
MyJdFactory5="T0225KkcRUwbp1DfIh78nfAPcwCjVWnYaS5kRrbA"
MyJdFactory6="T0225KkcRhYZpwLVckjykPACIgCjVWnYaS5kRrbA"
MyJdFactoryA="T0225KkcRRwd_AKGKBn3kqNfdQCjVWnYaS5kRrbA"
MyJdFactoryB=""

ForOtherJdFactory1="${MyJdFactory2}@${MyJdFactory3}@${MyJdFactory4}@${MyJdFactory5}@${MyJdFactory6}@${MyJdFactoryA}"
ForOtherJdFactory2="${MyJdFactory1}@${MyJdFactory2}@${MyJdFactory4}@${MyJdFactory5}@${MyJdFactory6}@${MyJdFactoryA}"
ForOtherJdFactory3="${MyJdFactory2}@${MyJdFactory1}@${MyJdFactory4}@${MyJdFactory5}@${MyJdFactory6}@${MyJdFactoryA}"
ForOtherJdFactory4="${MyJdFactory2}@${MyJdFactory3}@${MyJdFactory1}@${MyJdFactory5}@${MyJdFactory6}@${MyJdFactoryA}"
ForOtherJdFactory5="${MyJdFactory2}@${MyJdFactory3}@${MyJdFactory4}@${MyJdFactory1}@${MyJdFactory6}@${MyJdFactoryA}"
ForOtherJdFactory6="${MyJdFactory2}@${MyJdFactory3}@${MyJdFactory4}@${MyJdFactory5}@${MyJdFactory1}@${MyJdFactoryA}"
ForOtherJdFactoryA="${MyJdFactory2}@${MyJdFactory3}@${MyJdFactory4}@${MyJdFactory5}@${MyJdFactory6}@${MyJdFactory1}"


################################## 定义京东赚赚互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MyJdzz1="S5KkcAGh5iw2wYGCI5Yt3"
MyJdzz2="S5KkcAGh5iw2wYGCI5Yt3"
MyJdzz3=""
MyJdzz4=""
MyJdzz5=""
MyJdzz6=""
MyJdzzA=""
MyJdzzB=""

ForOtherJdzz1="${MyJdzz2}@${MyJdzz3}@${MyJdzz4}@${MyJdzz5}@${MyJdzz6}@${MyJdzzA}"
ForOtherJdzz2="${MyJdzz1}@${MyJdzz3}@${MyJdzz4}@${MyJdzz5}@${MyJdzz6}@${MyJdzzA}"
ForOtherJdzz3="${MyJdzz2}@${MyJdzz1}@${MyJdzz4}@${MyJdzz5}@${MyJdzz6}@${MyJdzzA}"
ForOtherJdzz4="${MyJdzz2}@${MyJdzz3}@${MyJdzz1}@${MyJdzz5}@${MyJdzz6}@${MyJdzzA}"
ForOtherJdzz5="${MyJdzz2}@${MyJdzz3}@${MyJdzz4}@${MyJdzz1}@${MyJdzz6}@${MyJdzzA}"
ForOtherJdzz6="${MyJdzz2}@${MyJdzz3}@${MyJdzz4}@${MyJdzz5}@${MyJdzz1}@${MyJdzzA}"
ForOtherJdzzA="${MyJdzz2}@${MyJdzz3}@${MyJdzz4}@${MyJdzz5}@${MyJdzz6}@${MyJdzz1}"


################################## 定义疯狂的JOY互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MyJoy1="D89iM9j_LcOkjy0KxMEgdw=="
MyJoy2="IIk5FqMTSy7HJbSMsiRSIat9zd5YaBeE"
MyJoy3="n597jK4lEtD7Y6ctoN0QNKt9zd5YaBeE"
MyJoy4="BIwpzk0d8fSF1P-8GZKscat9zd5YaBeE"
MyJoy5="fyjvoyHBhub7BVEDUA4oCKt9zd5YaBeE"
MyJoy6="ykUkm5FvdlHPYpynodz-k6t9zd5YaBeE"
MyJoyA="fpox6MUhM0t-tggNNwDrH6t9zd5YaBeE"
MyJoyB=""

ForOtherJoy1="${MyJoy2}@${MyJoy3}@${MyJoy4}@${MyJoy5}@${MyJoy6}@${MyJoyA}"
ForOtherJoy2="${MyJoy1}@${MyJoy3}@${MyJoy4}@${MyJoy5}@${MyJoy6}@${MyJoyA}"
ForOtherJoy3="${MyJoy2}@${MyJoy1}@${MyJoy4}@${MyJoy5}@${MyJoy6}@${MyJoyA}"
ForOtherJoy4="${MyJoy2}@${MyJoy3}@${MyJoy1}@${MyJoy5}@${MyJoy6}@${MyJoyA}"
ForOtherJoy5="${MyJoy2}@${MyJoy3}@${MyJoy4}@${MyJoy1}@${MyJoy6}@${MyJoyA}"
ForOtherJoy6="${MyJoy2}@${MyJoy3}@${MyJoy4}@${MyJoy5}@${MyJoy1}@${MyJoyA}"
ForOtherJoyA="${MyJoy2}@${MyJoy3}@${MyJoy4}@${MyJoy5}@${MyJoy6}@${MyJoy1}"


################################## 定义京喜农场互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
## 京喜农场助力码为 JSON 格式因此使用单引号，json 格式如下
## {"smp":"22bdadsfaadsfadse8a","active":"jdnc_1_btorange210113_2","joinnum":"1"}
## 助力码获取可以通过 bash jd.sh jd_get_share_code now 命令获取
## 注意：京喜农场 种植种子发生变化的时候，互助码也会变！！
MyJxnc1='{"smp":"6c21726f4e66584afc5c528f740a1f52","active":"jdnc_1_2yuannaiyou210209_2","joinnum":1}'
MyJxnc2='{"smp":"9b6aed0de5c89d3fced4dfdbfd19eb11","active":"jdnc_1_xiaoxiongbing210126_2","joinnum":1}'
MyJxnc3=''
MyJxnc4=''
MyJxnc5=''
MyJxnc6='{"smp":"342e4efb6af4797b46b62e347e5cf836","active":"jdnc_1_xiaoyuanbing210126_2","joinnum":1}'
MyJxncA='{"smp":"3ffa132188fe2db3c2cf2f3f43f58fed","active":"jdnc_1_xiaoyuanbing210126_2","joinnum":1}'
MyJxncB=''

ForOtherJxnc1="${MyJxnc2}@${MyJxnc3}@${MyJxnc4}@${MyJxnc5}@${MyJxnc6}@${MyJxncA}"
ForOtherJxnc2="${MyJxnc1}@${MyJxnc3}@${MyJxnc4}@${MyJxnc5}@${MyJxnc6}@${MyJxncA}"
ForOtherJxnc3="${MyJxnc2}@${MyJxnc1}@${MyJxnc4}@${MyJxnc5}@${MyJxnc6}@${MyJxncA}"
ForOtherJxnc4="${MyJxnc2}@${MyJxnc3}@${MyJxnc1}@${MyJxnc5}@${MyJxnc6}@${MyJxncA}"
ForOtherJxnc5="${MyJxnc2}@${MyJxnc3}@${MyJxnc4}@${MyJxnc1}@${MyJxnc6}@${MyJxncA}"
ForOtherJxnc6="${MyJxnc2}@${MyJxnc3}@${MyJxnc4}@${MyJxnc5}@${MyJxnc1}@${MyJxncA}"
ForOtherJxncA="${MyJxnc2}@${MyJxnc3}@${MyJxnc4}@${MyJxnc5}@${MyJxnc6}@${MyJxnc1}"

################################## 定义京喜农场TOKEN（选填） ##################################
## 如果某个Cookie的账号种植的是app种子，则必须填入有效的TOKEN；而种植非app种子则不需要TOKEN
## TOKEN的形式：{"farm_jstoken":"749a90f871adsfads8ffda7bf3b1576760","timestamp":"1610165423873","phoneid":"42c7e3dadfadsfdsaac-18f0e4f4a0cf"}
## 因TOKEN中带有双引号，因此，变量值两侧必须由一对单引号引起来
## TOKEN如何获取请阅读以下文件的注释：https://github.com/LXK9301/jd_scripts/blob/master/jd_jxnc.js
TokenJxnc1=''
TokenJxnc2=''
TokenJxnc3=''
TokenJxnc4=''
TokenJxnc5=''
TokenJxnc6=''


################################## 定义口袋书店互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MyBookShop1=""
MyBookShop2=""
MyBookShop3=""
MyBookShop4=""
MyBookShop5=""
MyBookShop6=""
MyBookShopA=""
MyBookShopB=""

ForOtherBookShop1=""
ForOtherBookShop2=""
ForOtherBookShop3=""
ForOtherBookShop4=""
ForOtherBookShop5=""
ForOtherBookShop6=""


################################## 定义签到领现金互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MyCash1="eU9YLJrSGKVBsRSpug9u"
MyCash2="eU9Ya7_mZv11o27SznpA0g"
MyCash3=""
MyCash4=""
MyCash5=""
MyCash6=""
MyCashA=""
MyCashB=""

ForOtherCash1="${MyCash2}@${MyCash3}@${MyCash4}@${MyCash5}@${MyCash6}@${MyCashA}"
ForOtherCash2="${MyCash1}@${MyCash3}@${MyCash4}@${MyCash5}@${MyCash6}@${MyCashA}"
ForOtherCash3="${MyCash2}@${MyCash1}@${MyCash4}@${MyCash5}@${MyCash6}@${MyCashA}"
ForOtherCash4="${MyCash2}@${MyCash3}@${MyCash1}@${MyCash5}@${MyCash6}@${MyCashA}"
ForOtherCash5="${MyCash2}@${MyCash3}@${MyCash4}@${MyCash1}@${MyCash6}@${MyCashA}"
ForOtherCash6="${MyCash2}@${MyCash3}@${MyCash4}@${MyCash5}@${MyCash1}@${MyCashA}"
ForOtherCashA="${MyCash2}@${MyCash3}@${MyCash4}@${MyCash5}@${MyCash6}@${MyCash1}"


################################## 定义闪购盲盒互助（选填） ##################################
## 具体填法及要求详见本文件最下方“互助码填法示例”
MySgmh1="T0205KkcAGh5iw2wYGCI5Yt3CjVWmIaW5kRrbA"
MySgmh2="T0225KkcR01N9VWEchrzkf5ZcACjVWmIaW5kRrbA"
MySgmh3="T0225KkcRkoa9wLQIRuinPBfIACjVWmIaW5kRrbA"
MySgmh4="T0225KkcRUod8ALedBrzwfZffACjVWmIaW5kRrbA"
MySgmh5="T0225KkcRUwbp1DfIh78nfAPcwCjVWmIaW5kRrbA"
MySgmh6="T0225KkcRhYZpwLVckjykPACIgCjVWmIaW5kRrbA"
MySgmhA="T0225KkcRRwd_AKGKBn3kqNfdQCjVWmIaW5kRrbA"
MySgmhB=""

ForOtherSgmh1="${MySgmh2}@${MySgmh3}@${MySgmh4}@${MySgmh5}@${MySgmh6}@${MySgmhA}"
ForOtherSgmh2="${MySgmh1}@${MySgmh3}@${MySgmh4}@${MySgmh5}@${MySgmh6}@${MySgmhA}"
ForOtherSgmh3="${MySgmh2}@${MySgmh1}@${MySgmh4}@${MySgmh5}@${MySgmh6}@${MySgmhA}"
ForOtherSgmh4="${MySgmh2}@${MySgmh3}@${MySgmh1}@${MySgmh5}@${MySgmh6}@${MySgmhA}"
ForOtherSgmh5="${MySgmh2}@${MySgmh3}@${MySgmh4}@${MySgmh1}@${MySgmh6}@${MySgmhA}"
ForOtherSgmh6="${MySgmh2}@${MySgmh3}@${MySgmh4}@${MySgmh5}@${MySgmh1}@${MySgmhA}"
ForOtherSgmhA="${MySgmh2}@${MySgmh3}@${MySgmh4}@${MySgmh5}@${MySgmh6}@${MySgmh1}"


################################## 定义东东超市蓝币兑换数量（选填） ##################################
## 东东超市蓝币兑换，可用值包括：
## 一、0：表示不兑换京豆，这也是js脚本的默认值
## 二、20：表示兑换20个京豆
## 三、1000：表示兑换1000个京豆
## 四、可兑换清单的商品名称，输入能跟唯一识别出来的关键词即可，比如：MARKET_COIN_TO_BEANS="抽纸"
## 注意：有些比较贵的实物商品京东只是展示出来忽悠人的，即使你零点用脚本去抢，也会提示没有或提示已下架
export MARKET_COIN_TO_BEANS="1000"


################################## 定义东东超市蓝币成功兑换奖品是否静默运行（选填） ##################################
## 默认 "false" 关闭（即:奖品兑换成功后会发出通知提示），如需要静默运行不发出通知，请改为 "true"
export MARKET_REWARD_NOTIFY="false"


################################## 定义东东超市是否自动升级商品和货架（选填） ##################################
## 升级顺序：解锁升级商品、升级货架，默认 "true" 自动升级，如需关闭自动升级，请改为 "false"
export SUPERMARKET_UPGRADE="ture"


################################## 定义东东超市是否自动更换商圈（选填） ##################################
## 小于对方300热力值自动更换商圈队伍，默认 "true" 自动更换，如不想更换商圈，请改为 "false"
## 目前已无此功能，申明了也无效
# export BUSINESS_CIRCLE_JUMP=""


################################## 定义东东超市是否自动使用金币去抽奖（选填） ##################################
## 是否用金币去抽奖，默认 "false" 关闭，如需开启，请修改为 "true"
export SUPERMARKET_LOTTERY="false"


################################## 定义东东超市是否自动参加PK队伍（选填） ##################################
## 是否每次PK活动参加脚本作者创建的PK队伍，"true" 表示参加，"false" 表示不参加，默认为 "true"
export JOIN_PK_TEAM="ture"


################################## 定义东东农场是否静默运行（选填） ##################################
## 默认为 "false"，不静默，发送推送通知消息，如不想收到通知，请修改为 "true"
## 如果你不想完全关闭或者完全开启通知，只想在特定的时间发送通知，可以参考下面的“定义东东萌宠是否静默运行”部分，设定几个if判断条件
export FRUIT_NOTIFY_CONTROL="ture"


################################## 定义东东农场是否使用水滴换豆卡（选填） ##################################
## 如果出现限时活动时100g水换20豆，此时比浇水划算，"true" 表示换豆（不浇水），"false" 表示不换豆（继续浇水）,默认是"false"
## 如需切换为换豆（不浇水），请修改为 "true"
export FRUIT_BEAN_CARD="false"


################################## 定义宠汪汪喂食克数（选填） ##################################
## 你期望的宠汪汪每次喂食克数，只能填入10、20、40、80，默认为10
## 如实际持有食物量小于所设置的克数，脚本会自动降一档，直到降无可降
## 具体情况请自行在宠汪汪游戏中去查阅攻略
export JOY_FEED_COUNT="10"


################################## 定义宠汪汪兑换京豆数量（选填） ##################################
## 目前的可用值包括：0、20、500、1000，其中0表示为不自动兑换京豆，如不设置，将默认为"20"
## 不同等级可兑换不同数量的京豆，详情请见宠汪汪游戏中兑换京豆选项
## 500、1000的京豆每天有总量限制，设置了并且你也有足够积分时，也并不代表就一定能抢到
export JD_JOY_REWARD_NAME="500"


################################## 定义宠汪汪兑换京豆是否静默运行（选填） ##################################
## 默认为 "false"，在成功兑换京豆时将发送推送通知消息（失败不发送），如想要静默不发送通知，请修改为 "true"
export JD_JOY_REWARD_NOTIFY="false"


################################## 定义宠汪汪是否自动给好友的汪汪喂食（选填） ##################################
## 默认 "false" 不会自动给好友的汪汪喂食，如想自动喂食，请改成 "true"
export JOY_HELP_FEED="false"


################################## 定义宠汪汪是否自动报名宠物赛跑（选填） ##################################
## 默认 "true" 参加宠物赛跑，如需关闭，请改成 "false"
export JOY_RUN_FLAG="ture"


################################## 定义宠汪汪参加比赛类型（选填） ##################################
## 当JOY_RUN_FLAG不设置或设置为 "true" 时生效
## 可选值：2,10,50，其他值不可以。其中2代表参加双人PK赛，10代表参加10人突围赛，50代表参加50人挑战赛，不填时默认为2
## 各个账号间请使用 & 分隔，比如：JOY_TEAM_LEVEL="2&2&50&10"
## 如果你有5个账号但只写了四个数字，那么第5个账号将默认参加2人赛，账号如果更多，与此类似
export JOY_TEAM_LEVEL="50&50&50&50&50&50&50"


################################## 定义宠汪汪赛跑获胜后是否推送通知（选填） ##################################
## 控制jd_joy.js脚本宠汪汪赛跑获胜后是否推送通知，"false" 为否(不推送通知消息)，"true" 为是(即：发送推送通知消息)，默认为 "true"
export JOY_RUN_NOTIFY="false"


################################## 定义摇钱树是否自动将金果卖出变成金币（选填） ##################################
## 金币有时效，默认为 "false"，不卖出金果为金币，如想希望自动卖出，请修改为 "true"
export MONEY_TREE_SELL_FRUIT="false"


################################## 定义东东萌宠是否静默运行（选填） ##################################
## 默认 "false"（不静默，发送推送通知消息），如想静默请修改为 true
## 每次执行脚本通知太频繁了，改成只在周三和周六中午那一次运行时发送通知提醒
## 除掉上述提及时间之外，均设置为 true，静默不发通知
## 特别说明：针对北京时间有效。
if [ $(date "+%w") -eq 6 ] && [ $(date "+%H") -ge 9 ] && [ $(date "+%H") -lt 14 ]; then
  export PET_NOTIFY_CONTROL="false"
elif [ $(date "+%w") -eq 3 ] && [ $(date "+%H") -ge 9 ] && [ $(date "+%H") -lt 14 ]; then
  export PET_NOTIFY_CONTROL="false"
else
  export PET_NOTIFY_CONTROL="true"
fi


################################## 定义京喜工厂控制哪个京东账号不运行此脚本（选填） ##################################
## 输入"1"代表第一个京东账号不运行，多个使用 & 连接，例："1&3" 代表账号1和账号3不运行京喜工厂脚本，注：输入"0"，代表全部账号不运行京喜工厂脚本
## 如果使用了 “临时屏蔽某个Cookie” TempBlockCookie 功能，编号会发生变化
export DREAMFACTORY_FORBID_ACCOUNT=""


################################## 定义东东工厂控制哪个京东账号不运行此脚本（选填） ##################################
## 输入"1"代表第一个京东账号不运行，多个使用 & 连接，例："1&3" 代表账号1和账号3不运行东东工厂脚本，注：输入"0"，代表全部账号不运行东东工厂脚本
## 如果使用了 “临时屏蔽某个Cookie” TempBlockCookie 功能，编号会发生变化
export JDFACTORY_FORBID_ACCOUNT=""


################################## 定义东东工厂心仪的商品（选填） ##################################
## 只有在满足以下条件时，才自动投入电力：一是存储的电力满足生产商品所需的电力，二是心仪的商品有库存，如果没有输入心仪的商品，那么当前你正在生产的商品视作心仪的商品
## 如果你看不懂上面的话，请去东东工厂游戏中查阅攻略
## 心仪的商品请输入商品的全称或能唯一识别出该商品的关键字
export FACTORAY_WANTPRODUCT_NAME=""


################################## 定义京喜农场通知级别（选填） ##################################
## 可用值： 0(不通知); 1(本次获得水滴>0); 2(任务执行); 3(任务执行+未种植种子)，默认为"3"
export JXNC_NOTIFY_LEVEL="3"


################################## 定义取关参数（选填） ##################################
## jd_unsubscribe这个任务是用来取关每天做任务关注的商品和店铺，默认在每次运行时取关20个商品和20个店铺
## 如果取关数量不够，可以根据情况增加，还可以设置 jdUnsubscribeStopGoods 和 jdUnsubscribeStopShop 
## 商品取关数量
goodPageSize="60"
## 店铺取关数量
shopPageSize="60"
## 遇到此商品不再取关此商品以及它后面的商品，需去商品详情页长按拷贝商品信息
jdUnsubscribeStopGoods=""
## 遇到此店铺不再取关此店铺以及它后面的店铺，请从头开始输入店铺名称
jdUnsubscribeStopShop=""


################################## 疯狂的JOY（选填） ##################################
## 疯狂的JOY循环助力，"true" 表示循环助力，"false" 表示不循环助力，默认 "false"
export JDJOY_HELPSELF="ture"

## 疯狂的JOY京豆兑换，目前最小值为500/1000京豆，默认为 "0" 不开启京豆兑换
export JDJOY_APPLYJDBEAN="2000"

## 疯狂的JOY自动购买什么等级的JOY，如需要使用请自行解除注释
 export BUY_JOY_LEVEL="30"


################################## 定义是否自动加购物车（选填） ##################################
## 口袋书店和东东小窝有些任务需要将商品加进购物车才能完成，默认 "false" 不做这些任务，如想做，请设置为 "true"
export PURCHASE_SHOPS="ture"


################################## Telegram 代理（选填） ##################################
## Telegram 代理的 IP，代理类型为 http，比如你代理是 http://127.0.0.1:1080，则填写 "127.0.0.1"
## 如需使用，请自行解除下一行的注释
# export TG_PROXY_HOST=""

## Telegram 代理的端口，代理类型为 http，比如你代理是 http://127.0.0.1:1080，则填写 "1080"
## 如需使用，请自行解除下一行的注释
# export TG_PROXY_PORT=""


################################## 是否添加DIY脚本（选填） ##################################
## 如果你自己会写shell脚本，并且希望在每次git_pull.sh这个脚本运行时，额外运行你的DIY脚本，请赋值为 "true"
## 同时，请务必将你的脚本命名为 diy.sh (只能叫这个文件名)，放在 config 目录下
## 我已定义好的变量，你如果想直接使用，可以参考本仓库下 git_pull.sh 文件
EnableExtraShell=""


################################## 互助码填法示例 ##################################
## **互助码是填在My系列变量中的，ForOther系统变量中只要填入My系列的变量名即可，按注释中的例子拼接，以东东农场为例，如下所示。**
## **实际上东东农场一个账号只能给别人助力3次，我多写的话，只有前几个会被助力。但如果前面的账号获得的助力次数已经达到上限了，那么还是会尝试继续给余下的账号助力，所以多填也是有意义的。**
## **ForOther系列变量必须从1开始编号，依次编下去。**

# MyFruit1="e6e04602d5e343258873af1651b603ec"  # 这是Cookie1这个账号的互助码
# MyFruit2="52801b06ce2a462f95e1d59d7e856ef4"  # 这是Cookie2这个账号的互助码
# MyFruit3="e2fd1311229146cc9507528d0b054da8"  # 这是Cookie3这个账号的互助码
# MyFruit4="6dc9461f662d490991a31b798f624128"  # 这是Cookie4这个账号的互助码
# MyFruit5="30f29addd75d44e88fb452bbfe9f2110"  # 这是Cookie5这个账号的互助码
# MyFruit6="1d02fc9e0e574b4fa928e84cb1c5e70b"  # 这是Cookie6这个账号的互助码
# MyFruitA="5bc73a365ff74a559bdee785ea97fcc5"  # 这是我和别人交换互助，另外一个用户A的互助码
# MyFruitB="6d402dcfae1043fba7b519e0d6579a6f"  # 这是我和别人交换互助，另外一个用户B的互助码
# MyFruitC="5efc7fdbb8e0436f8694c4c393359576"  # 这是我和别人交换互助，另外一个用户C的互助码

# ForOtherFruit1="${MyFruit2}@${MyFruitB}@${MyFruit4}"   # Cookie1这个账号助力Cookie2的账号的账号、Cookie4的账号以及用户B
# ForOtherFruit2="${MyFruit1}@${MyFruitA}@${MyFruit4}"   # Cookie2这个账号助力Cookie1的账号的账号、Cookie4的账号以及用户A
# ForOtherFruit3="${MyFruit1}@${MyFruit2}@${MyFruitC}@${MyFruit4}@${MyFruitA}@${MyFruit6}"  # 解释同上，东东农场实际上只能助力3次
# ForOtherFruit4="${MyFruit1}@${MyFruit2}@${MyFruit3}@${MyFruitC}@${MyFruit6}@${MyFruitA}"  # 解释同上，东东农场实际上只能助力3次
# ForOtherFruit5="${MyFruit1}@${MyFruit2}@${MyFruit3}@${MyFruitB}@${MyFruit4}@${MyFruit6}@${MyFruitC}@${MyFruitA}"
# ForOtherFruit6="${MyFruit1}@${MyFruit2}@${MyFruit3}@${MyFruitA}@${MyFruit4}@${MyFruit5}@${MyFruitC}"


################################## 额外的环境变量（选填） ##################################
## 请在以下补充你需要用到的额外的环境变量，形式：export 变量名="变量值"
