#!/bin/bash

# @sacloud-once
# @sacloud-text maxlen=15 loopback_ip "LOOPBACK IPADDRESS(*.*.*.*)"

if [ $(grep -c "release 8" /etc/redhat-release) -eq 1 ] ;then
        sleep 180
else
        exit 0
fi

# ループバックインターフェースへのVIPアドレス設定
LOOPBACK_IP=@@@loopback_ip@@@ 	# *.*.*.*
nmcli connection add type dummy ifname vip01 ipv4.method manual ipv4.addresses $LOOPBACK_IP/32 ipv6.method ignore

# バーチャルサーバー宛のARPに応答しないようにする
cat <<EOL >> /etc/sysctl.conf
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
EOL

# 反映
sysctl -p

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

