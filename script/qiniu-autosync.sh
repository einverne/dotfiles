#!/bin/sh

# Writen by 404 - <https://github.com/why404>

# 此脚本可监控 Linux/Unix 上指定的文件夹，并将此文件夹内的新增或改动文件自动同步到七牛云存储，可设定同步删除。

# 1. 需先安装 inotify-tools - <https://github.com/rvoicilas/inotify-tools/wiki>
# 2. 然后下载 qboxrsctl - <http://docs.qiniutek.com/v3/tools/qboxrsctl/>

# 获取七牛云存储 ACCESS_KEY 和 SECRET_KEY 以及 BUCKET_NAME (空间名称) 请登录：<https://dev.qiniutek.com>

# 用法（反斜杠用于排版换行需要，实际情况下可忽略）:
#
#   ./qiniu-autosync.sh -a /PATH/TO/appkey.json \     # appkey.json 写明 {"access_key":"YOUR_ACCESS_KEY", "secret_key": "YOUR_SECRET_KEY"}
#                       -b BUCKET_NAME \              # 用于存储文件的七牛空间名称
#                       -c /PATH/TO/qboxrsctl \       # qboxrsctl 可执行命令所在路径
#                       -d /PATH/TO/WATCH_DIR \       # 要监控的目录，绝对路径
#                       -e ALLOW_DELETE_TrueOrFalse \ # 是否允许自动删除，缺省为 false
#                       -f FILE_BLOCK_SIZE \          # 文件切片分块大小，超过这个大小启用并行断点续上传，缺省为 4194304 (4MB)
#                       -g INOTIFY_IGNORE_PATTERN     # 忽略列表(正则)，缺省为 "^(.+(\~|\.sw.?)|4913)$" (即 vim 临时文件)
#


# 超过这个大小启用并行断点续上传，缺省 4 MB
QINIU_BLOCK_SIZE=4194304

# 是否允许自动删除，缺省不允许
ALLOW_DELETE=false

# 忽略 vim 创建的临时文件，这里可以自定义忽略正则
INOTIFY_IGNORE_PATTERN="^(.+(\~|\.sw.?)|4913)$"

# inotifywait 可执行命令所在路径
INOTIFY_BIN=/usr/bin/inotifywait

INOTIFY_EVENTS="moved_to,create,delete,close_write,close"
INOTIFY_TIME_FMT="%d/%m/%y %H:%M"
INOTIFY_FORMAT="%T %e %w%f"

while getopts a:b:c:d:e:f:g: option
do
    case "${option}"
    in
        a) QINIU_APPKEY_FILE=${OPTARG};;
        b) QINIU_BUCKET=${OPTARG};;
        c) QINIU_CMD=${OPTARG};;
        d) WATCH_DIR=${OPTARG};;
        e) ALLOW_DELETE=${OPTARG};;
        f) QINIU_BLOCK_SIZE=${OPTARG};;
        g) INOTIFY_IGNORE_PATTERN=${OPTARG};;
    esac
done

getFileKey() {
    dir=$1
    file=$2
    key=${file##*$dir}
    if [ `echo $key | cut -c1-1` = "/" ]; then
        key=`echo $key | cut -c2-${#key}`
    fi
    echo $key
}

$INOTIFY_BIN --exclude "$INOTIFY_IGNORE_PATTERN" -mre "$INOTIFY_EVENTS" --timefmt "$INOTIFY_TIME_FMT" --format "$INOTIFY_FORMAT" $WATCH_DIR | while read date time event file
do

    case "$event" in

        CLOSE_WRITE,CLOSE | MOVED_TO)

            key=`getFileKey $WATCH_DIR "$file"`
            echo "start uploading ${file}"

            if [ `stat -c %s "$file"` -gt $QINIU_BLOCK_SIZE ]; then
                $QINIU_CMD -a $QINIU_APPKEY_FILE put -c $QINIU_BUCKET "$key" "$file"
            else
                $QINIU_CMD -a $QINIU_APPKEY_FILE put $QINIU_BUCKET "$key" "$file"
            fi

            echo "successfully uploaded $QINIU_BUCKET:$key"
            ;;

        DELETE)
            echo "deleting file: ${file}"
            if $ALLOW_DELETE; then
                key=`getFileKey $WATCH_DIR "$file"`
                echo "deleting key: ${key}"
                $QINIU_CMD -a $QINIU_APPKEY_FILE del $QINIU_BUCKET "$key"
                echo "successfully deleted $QINIU_BUCKET:$key"
            else
                echo "${date} ${time} ${file} ${event}"
                echo "\"$QINIU_BUCKET:$key\" will not be deleted."
            fi
            ;;

        *)
            echo "${date} ${time} ${file} ${event}"
            ;;

    esac

done
