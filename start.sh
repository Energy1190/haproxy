#!/bin/bash

IFS=$'\r\n' GLOBIGNORE='*' command eval  'NODELIST=($(cat /etc/nodes))'

sed '/^.*server.*:3306.*$/d' /usr/local/etc/haproxy/haproxy.cfg | sed '/^$/d' > /haproxy.cfg
cp /haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

for i in ${#NODELIST[@]}; do
  IFS='---' read -ra PAIR <<< ${NODELIST[$i]}
  IFS='/' read -ra NAME <<< ${PAIR[0]}
  echo "    server ${NAME[-1]} ${PAIR[-1]}:3306" >> /usr/local/etc/haproxy/haproxy.cfg
done

/docker-entrypoint.sh "$@"
