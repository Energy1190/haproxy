#!/bin/bash

IFS=$'\r\n' GLOBIGNORE='*' command eval  'NODELIST=($(cat /etc/nodes))'

sed '/^.*server.*:3306.*$/d' /usr/local/etc/haproxy/haproxy.cfg | sed '/^$/d' > /haproxy.cfg
cp /haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

for (( i=0; i<${#NODELIST[@]}; i++ )); do
  IFS='+' read -ra PAIR <<< ${NODELIST[$i]}
  IFS='/' read -ra NAME <<< ${PAIR[0]}
  N=${NAME[-1]}
  P=${PAIR[-1]}
  sed "s/balance roundrobin/balance roundrobin\n    server $N $P:3306/g" /usr/local/etc/haproxy/haproxy.cfg > /haproxy.cfg
  cp /haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
done

/docker-entrypoint.sh "$@"
