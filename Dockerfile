FROM owncloudops/nginx:latest

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
    org.label-schema.name="Matomo" \
    org.label-schema.vendor="ownCloud GmbH" \
    org.label-schema.schema-version="1.0"

ARG BUILD_VERSION=latest
ENV MATOMO_VERSION="${BUILD_VERSION:-latest}"

ADD overlay/ /

RUN apk --update add --virtual .build-deps tar curl && \
    apk --update add php7-cli php7-ctype php7-curl php7-dom php7-iconv php7-fpm php7-gd \
    php7-json php7-ldap php7-mbstring php7-opcache php7-openssl php7-pdo php7-pdo_mysql \
    php7-redis php7-session php7-simplexml php7-xml php7-zlib php7-zip && \
    rm -rf /var/www/localhost && \
    rm -f /etc/php7/php-fpm.d/www.conf && \
    mkdir -p /var/www/app && \
    MATOMO_VERSION="${MATOMO_VERSION##v}" && \
    echo "Installing Matomo version '${MATOMO_VERSION}' ..." && \
    curl -SsL "https://builds.matomo.org/matomo-${MATOMO_VERSION}.tar.gz" | \
        tar xz -C /var/www/app/ --strip-components=1 && \
    curl -SsL -o /etc/php7/browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /root/.composer/ && \
    mkdir -p /var/run/php && \
    chown -R nginx /var/run/php && \
    mkdir -p /var/lib/php/tmp_upload && \
    mkdir -p /var/lib/php/soap_cache && \
    mkdir -p /var/lib/php/session && \
    chown -R nginx /var/lib/php && \
    chown nginx /etc/php7/php.ini && \
    chown -R nginx:nginx /var/www/app

VOLUME /var/www/app/config
VOLUME /var/www/app/misc
VOLUME /var/www/app/plugins

EXPOSE 8080

USER nginx

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/bin/entrypoint"]
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD /usr/bin/healthcheck
WORKDIR /var/www/app
CMD []
