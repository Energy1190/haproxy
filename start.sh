#!/bin/bash

IFS=$'\r\n' GLOBIGNORE='*' command eval  'NODELIST=($(cat /etc/nodes))'

sed '/^.*server.*:3306.*$/d' /usr/local/etc/haproxy/haproxy.cfg | sed '/^$/d' > /haproxy.cfg
cp /haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

for (( i=0; i<${#NODELIST[@]}; i++ )); do
  IFS='+' read -ra PAIR <<< ${NODELIST[$i]}
  IFS='/' read -ra NAME <<< ${PAIR[0]}
  N=${NAME[-1]}
  P=${PAIR[-1]}
  echo "server ${N} ${P}:3306"
  sed "s/balance first/balance first\n    server $N $P:3306 check/g" /usr/local/etc/haproxy/haproxy.cfg > /haproxy.cfg
  cp /haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
done

/docker-entrypoint.sh "$@"
