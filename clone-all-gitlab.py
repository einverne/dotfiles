#!/usr/bin/env python
# -*- coding: UTF-8 -*-

# https://stackoverflow.com/a/57412415/1820217
# pip install python-gitlab
# python clone-all-gitlab.py GITLAB_HOST GROUP_ID PERSONAL_ACCESS_TOKEN
import os
import sys
import gitlab
import subprocess

glab = gitlab.Gitlab(f'https://{sys.argv[1]}', f'{sys.argv[3]}')
groups = glab.groups.list()
groupname = sys.argv[2]
for group in groups:
    if group.name == groupname:
        projects = group.projects.list(all=True)

for repo in projects:
    command = f'git clone {repo.ssh_url_to_repo}'
    process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    output, _ = process.communicate()
    process.wait()
