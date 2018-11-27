FROM alpine:latest

# install openntp
# Configure ustc alpine software source and timezone
RUN sed -i "s#http://dl-cdn.alpinelinux.org/#https://mirrors.ustc.edu.cn/#g" /etc/apk/repositories \
    && apk update \
    && apk add --no-cache openntpd \
    && apk --no-cache add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" >  /etc/timezone \
    && rm -rf /var/cache/apk/*
    
# use custom ntpd config file
COPY assets/ntpd.conf /etc/ntpd.conf

# ntp port
EXPOSE 123/udp

# let docker know how to test container health
HEALTHCHECK CMD ntpctl -s status || exit 1

# start ntpd in the foreground
ENTRYPOINT [ "/usr/sbin/ntpd", "-v", "-d", "-s" ]
