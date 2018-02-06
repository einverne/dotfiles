#!/bin/bash

# This script creates a compressed backup archive of the given directory and the given MySQL table. More details on implementation here: http://theme.fm
# Feel free to use this script wherever you want, however you want. We produce open source, GPLv2 licensed stuff.
# Author: Konstantin Kovshenin exclusively for Theme.fm in June, 2011
# https://theme.fm/a-shell-script-for-a-complete-wordpress-backup/

# Set the date format, filename and the directories where your backup files will be placed and which directory will be archived.
NOW=$(date +"%Y-%m-%d-%H-%M")
FILE="www.einverne.info.$NOW.tar"
GZ_FILE=$FILE.gz
BACKUP_DIR="/root/backups"
WWW_DIR="/var/www/www.einverne.info/html"
EMAIL_ADDR="username@gmail.com"

mkdir -p $BACKUP_DIR

# MySQL database credentials
DB_USER=""
DB_PASS=""
DB_NAME=""
DB_FILE="www.einverne.info.$NOW.sql"

# Tar transforms for better archive structure.
WWW_TRANSFORM='s,^var/www/www.einverne.info/html,html,'
DB_TRANSFORM='s,^root/backups,database,'

# 以上内容需要自定义

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
