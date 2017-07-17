#!/bin/bash

sed '/^.*server.*:3306.*$/d' /usr/local/etc/hroxy/haproxy.cfg | sed '/^$/d' >> /haproxy.cfg
IFS=' ' read -ra RESULT <<< ${NODELIST} 
for i in ${#RESULT[@]}; do
  IFS=':' read -ra PAIR <<< $i
  IFS='/' read -ra NAME <<< ${PAIR[0]}
  echo "    server ${NAME[-1]} ${PAIR[-1]}:3306" >> /usr/local/etc/hroxy/haproxy.cfg
done

/docker-entrypoint.sh "$@"