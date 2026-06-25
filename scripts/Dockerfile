FROM registry.cn-hangzhou.aliyuncs.com/mirror/ubuntu:22.04

RUN apt-get update && apt-get install -y procps

COPY daily_health.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/daily_health.sh

CMD ["/usr/local/bin/daily_health.sh"]
