#!/bin/bash

# 发邮件方式备份网站数据
# 脚本会创建一个压缩包，包含备份的目录和MySQL 数据库备份
# Feel free to use this script wherever you want, however you want. We produce open source, GPLv2 licensed stuff.
# https://theme.fm/a-shell-script-for-a-complete-wordpress-backup/

# 设置备份文件名
NOW=$(date +"%Y-%m-%d-%H-%M")
FILE="www.einverne.info.$NOW.tar"
GZ_FILE=$FILE.gz
# 备份文件压缩包存放路径
BACKUP_DIR="/root/backups"
# 需要备份的路径文件夹
WWW_DIR="/var/www/www.einverne.info/html"
# 接受者邮箱
EMAIL_ADDR="username@gmail.com"

# MySQL 数据库相关配置
DB_USER=""
DB_PASS=""
DB_NAME=""
DB_FILE="www.einverne.info.$NOW.sql"

# 将Tar压缩包内内容，分别保存到 html 和 database 两个文件夹下
WWW_TRANSFORM='s,^var/www/www.einverne.info/html,html,'
DB_TRANSFORM='s,^root/backups,database,'

# 以上内容需要自定义

mkdir -p $BACKUP_DIR
# Create the archive and the MySQL dump
tar -cvf $BACKUP_DIR/$FILE --transform $WWW_TRANSFORM $WWW_DIR
mysqldump -u$DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/$DB_FILE

# Append the dump to the archive, remove the dump and compress the whole archive.
tar --append --file=$BACKUP_DIR/$FILE --transform $DB_TRANSFORM $BACKUP_DIR/$DB_FILE
rm $BACKUP_DIR/$DB_FILE
gzip -9 $BACKUP_DIR/$FILE

# Split file and send by email
split -b 5M $BACKUP_DIR/$GZ_FILE $BACKUP_DIR/$GZ_FILE.
rm $BACKUP_DIR/$GZ_FILE

for filename in $BACKUP_DIR/*; do
    echo $filename
    echo "backup" | mutt -s "$GZ_FILE" $EMAIL_ADDR -a $filename
done

rm -rf $BACKUP_DIR
