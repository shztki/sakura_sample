#!/bin/bash

# @sacloud-once

# Apache Benchのインストール
yum install -y httpd-tools
# usacloud install
curl -fsSL https://github.com/sacloud/usacloud/releases/latest/download/install.sh | bash
firewall-cmd --permanent --add-service ssh
firewall-cmd --reload

