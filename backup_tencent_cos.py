#!/usr/bin/env python
# -*- coding: utf-8 -*-
# pip install -U cos-python-sdk-v5
import os

from qcloud_cos import CosConfig
from qcloud_cos import CosS3Client

secret_id = ''
secret_key = ''
region = ''
bucket = ''
token = ''


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

    put(client, '')
    get(client, '')

