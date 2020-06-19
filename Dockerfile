FROM alpine:latest

RUN apk add --no-cache git
RUN git clone --branch gh-pages --depth 1 https://github.com/keeweb/keeweb
RUN git clone --branch master --depth 1 https://github.com/keeweb/keeweb-plugins
RUN rm -r keeweb/.git
RUN mv keeweb-plugins/docs keeweb/plugins

RUN apk add --no-cache \
        lighttpd \
        apache2-utils \
        lighttpd-mod_auth \
        lighttpd-mod_webdav \
        openssl

RUN mv keeweb /var/www/html

ENV LDAPDRCPW LDAPDRCPW
ENV LDAPDRCIP LDAPDRCIP

WORKDIR /etc/lighttpd/
COPY start.sh .
RUN chmod +x start.sh
COPY lighttpd.conf .
RUN chmod 770 lighttpd.conf

ENTRYPOINT ["/bin/sh", "/etc/lighttpd/start.sh"]
