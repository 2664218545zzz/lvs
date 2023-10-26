#! /bin/bash
# 自定义虚拟主机域名
# 示例:domain_name="www.pupu.com"
# 默认域名如下
domain_name="www.niubi.com"

# 自定义网页文件内容
page="This is RS2"

# 指定网卡名称,根据自己本机的网卡名称来定义
# 示例: network="ens33"
network="ens160"

# 设置你的vip
# 示例: vip="192.168.187.200"
vip="192.168.187.200"

# 1.创建虚拟主机文件
touch /etc/httpd/conf.d/vhosts.conf &&\
cat > /etc/httpd/conf.d/vhosts.conf <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/$domain_name"   
    ServerName $domain_name
    ErrorLog "/var/log/httpd/$domain_name-error_log"
    CustomLog "/var/log/httpd/$domain_name-access_log" common
</VirtualHost>
EOF


# 2.创建u虚拟主机家目录
mkdir -p /var/www/html/$domain_name
touch /var/www/html/$domain_name/index.html
echo "$page" > /var/www/html/$domain_name/index.html

# 3.重启httpd服务
systemctl restart httpd

yum -y install net-tools
cat >> /etc/sysctl.conf <<EOF
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
EOF
sysctl -p

ifconfig lo:0 $vip/32 broadcast $vip up
# 5.配置路由信息
route add -host $vip dev lo:0
