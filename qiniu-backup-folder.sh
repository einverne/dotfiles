#!/bin/bash

# https://github.com/Ecareyu/backup2qiniu
# 在官网找最新版 https://developer.qiniu.com/kodo/tools/1302/qshell
QSHELL_URL="https://dn-devtools.qbox.me/2.1.5/qshell-linux-x64"

## 备份配置信息 ##

# qshell路径
QSHELL="/usr/local/bin/qshell"
# 备份名称，用于文件名标记
BACKUP_NAME="test"
# 需要备份的目录，多个请空格分隔
BACKUP_SRC="/home/mi/Pictures"
# 备份文件临时存放目录，一般不需要更改
BACKUP_DIR="/tmp/backuptoqiniu"
# 备份文件压缩密码确保压缩包的安全
BACKUP_FILE_PASSWD=""
# 子目录名,为空时获取服务器hostname作为子目录名
SUB_DIR_NAME=""

## 备份配置信息 End ##

## 七牛配置信息 ##

# 存放空间对应我们在七牛上创建的容器
QINIU_BUCKET=""
QINIU_ACCESS_KEY=""
QINIU_SECRET_KEY=""

## 七牛配置信息 End ##

# 修复crontab执行时的报错
cd `dirname $0`

# 设置子目录名
if [ ! -n "$SUB_DIR_NAME" ]; then
    SUB_DIR_NAME=`hostname`
fi

if [ ! -f "$QSHELL" ]; then
    echo "qshell not found, install from this link https://github.com/qiniu/qshell"
    wget -O qshell $QSHELL_URL
    mv qshell /usr/local/bin/
    chmod +x /usr/local/bin/qshell
fi

# qshell设置用户
$QSHELL account $QINIU_ACCESS_KEY $QINIU_SECRET_KEY

if [ 0 != $? ]; then
    echo "Authorization error"
    exit;
fi

#精确到秒，同一秒内上传的文件会被覆盖
NOW=$(date +"%Y-%m-%d-%H-%M-%S") 

mkdir -p $BACKUP_DIR

# 打包
echo "start tar"
BACKUP_FILENAME="$BACKUP_NAME-backup-$NOW.zip"
tarCommand="zip -q -r"

# 判定是否需要密码参数
if [ -n "$BACKUP_FILE_PASSWD" ]; then
    tarCommand="$tarCommand -P $BACKUP_FILE_PASSWD"
fi

# 到目录中压缩，防止压缩包出现过多目录结构
pushd $BACKUP_DIR && $tarCommand $BACKUP_FILENAME *.sql $BACKUP_SRC && popd
echo "tar ok"

# 上传,默认100条线程,管它呢
echo "start upload"
$QSHELL rput $QINIU_BUCKET $SUB_DIR_NAME/$BACKUP_FILENAME $BACKUP_DIR/$BACKUP_FILENAME
echo "upload ok"

# 清理备份文件
rm -rf $BACKUP_DIR
echo "backup clean done"
