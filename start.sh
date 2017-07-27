#!/bin/bash

IFS=$'\r\n' GLOBIGNORE='*' command eval  'NODELIST=($(cat /etc/nodes))'

sed '/^.*server.*:3306.*$/d' /usr/local/etc/haproxy/haproxy.cfg | sed '/^$/d' > /haproxy.cfg
cp /haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

for (( i=0; i<${#NODELIST[@]}; i++ )); do
  IFS='+' read -ra PAIR <<< ${NODELIST[$i]}
  IFS='/' read -ra NAME <<< ${PAIR[0]}
  sed 's/balance roundrobin/balance roundrobin\n    server $NAME[-1] $PAIR[-1]:3306/g' /usr/local/etc/haproxy/haproxy.cfg > /haproxy.cfg
  cp /haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
  echo "    server ${NAME[-1]} ${PAIR[-1]}:3306" >> /usr/local/etc/haproxy/haproxy.cfg
done

/docker-entrypoint.sh "$@"
