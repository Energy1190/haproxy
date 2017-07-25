FROM haproxy:1.7

ADD start.sh /start.sh
ADD haproxy.cfg /usr/local/etc/hroxy/haproxy.cfg

RUN chmod +x /start.sh 

ENTRYPOINT ["/start.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]