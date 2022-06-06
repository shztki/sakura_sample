#!/bin/bash

# @sacloud-once
# @sacloud-text maxlen=18 eth1_ip "ETH1 IPADDRESS(*.*.*.*/*)"

if [ $(grep -c "release 8" /etc/redhat-release) -eq 1 ] ;then
        sleep 30
else
        exit 0
fi

# eth1へのIPアドレス設定
IP=@@@eth1_ip@@@
nmcli con mod "System eth1" \
ipv4.method manual \
ipv4.address $IP \
connection.autoconnect "yes" \
ipv6.method ignore
# 反映
nmcli con down "System eth1"; nmcli con up "System eth1"

# NGINXのインストール
yum install -y nginx
systemctl enable nginx
echo -e "keepalive_requests 10;\ngzip_proxied any;\ngzip on;\ngzip_http_version 1.0;\ngzip_comp_level 9;\ngzip_types text/html;" > /etc/nginx/conf.d/gzip.conf
# 負荷をかけるためのテスト用コンテンツ。wikipediaのページをダウンロードして使います
curl https://ja.wikipedia.org/wiki/%E4%B8%96%E7%95%8C%E9%81%BA%E7%94%A3 > /usr/share/nginx/html/sekai.html
systemctl start nginx
echo "server name: $(hostname)" >  /usr/share/nginx/html/index.html
echo "OK" > /usr/share/nginx/html/live
firewall-cmd --permanent --add-service http
firewall-cmd --permanent --add-service ssh
firewall-cmd --reload

