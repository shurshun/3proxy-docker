#!/bin/sh

CONF=/etc/3proxy.cfg

# consul-template \
# 	-template "/etc/3proxy.ctmpl:/etc/3proxy.cfg" -exec "3proxy /etc/3proxy.cfg"

eth=$(ip -4 route  | grep default | grep -Eo -m 1 'dev (\S+) '|awk '{print $2}')

aliases=$(ip -f inet addr|grep inet|grep ${eth}:|awk '{print $2 "|" $NF}'|sed -e "s#${eth}:##g"|sort -nk 2 -t"|")

for alias in $aliases; do
    IP=$(echo $alias|cut -f 1 -d "|"|cut -f 1 -d "/")
    #I=$(echo $alias|cut -f 2 -d "|")
    echo proxy -n -a -i$IP -e$IP -p$PROXY_PORT >> $CONF
    echo socks -n -a -i$IP -e$IP -p$SOCKS_PORT >> $CONF
done

echo $IP > /etc/healthcheck

3proxy $CONF
