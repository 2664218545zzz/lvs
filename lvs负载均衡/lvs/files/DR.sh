#! /bin/bash

# 指定网卡名称,根据自己本机的网卡名称来定义
# 示例: network="ens33"
network="ens160"

# 设置你的vip
# 示例: vip="192.168.187.200"
vip="192.168.187.200"

# 添加两台RS机的ip
RS1="192.168.187.140"
RS2="192.168.187.150"

# 1.安装ifconfig命令
yum -y install net-tools

# 2.添加vip
ifconfig $network:0 $vip/32 broadcast $vip up

# 3.配置路由信息
route add -host $vip dev $network:0

# 4.设置规则
yum -y install ipvsadm
ipvsadm -A -t $vip:80 -s wrr
ipvsadm -a -t $vip:80 -r $RS1:80 -g
ipvsadm -a -t $vip:80 -r $RS2:80 -g
ipvsadm -S > /etc/sysconfig/ipvsadm

