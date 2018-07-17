#!/usr/bin/env python
# -*- coding: utf-8 -*-
# pip install -U cos-python-sdk-v5
import os

import sys
import tarfile

import subprocess
from qcloud_cos import CosConfig
from qcloud_cos import CosS3Client

secret_id = ''
secret_key = ''
region = ''
bucket = ''
token = ''

backup_dir = "/home/mi/Public"  # 需要备份的目录
backup_filename = "backup.tar.gz"
temp_dir = "/tmp/backup/"
sql_filename = "backup.sql"
MYSQL_USER = "root"
MYSQY_PASSWORD = "password"

def put(client, file_path):
    if not os.path.exists(file_path):
        raise Exception("file not exist")
    with open(file_path, 'rb') as f:
        r = client.put_object(
            Bucket=bucket,
            Body=f,
            Key=os.path.basename(file_path),
        )
    print r


def get(client, file_name):
    r = client.get_object(
        Bucket=bucket,
        Key=file_name,
    )
    r['Body'].get_stream_to_file(file_name)
    # r['Body'].get_raw_stream()  流

if __name__ == '__main__':
    config = CosConfig(Secret_id=secret_id, Secret_key=secret_key, Region=region)
    client = CosS3Client(conf=config)

    try:
        if not os.path.isdir(temp_dir):
            os.mkdir(temp_dir)
    except IOError, err:
        print err
        sys.exit()

    full_temp = os.path.join(temp_dir, backup_filename)
    tar = tarfile.open(name=full_temp, mode='w:gz')
    for dirpath, dirnames, filenames in os.walk(backup_dir):
        for file in filenames:
            full_path = os.path.join(dirpath, file)
            tar.add(full_path, arcname=file, recursive=False)


    try:
        # 请自行更改mysqldump路径
        cmd = '/usr/bin/mysqldump -u' + MYSQL_USER + ' -p' + MYSQY_PASSWORD + ' --all-databases > ' + temp_dir + '/' + sql_filename
        h = subprocess.call(cmd)
        if h[0] != 0:
            print "error mysql backup"
        else:
            full_path = os.path.join(temp_dir, sql_filename)
            tar.add(full_path, arcname=sql_filename, recursive=False)
    except IOError, error:
        print error

    tar.close()

    put(client, full_temp)
    # get(client, '')
    os.remove(full_temp)

