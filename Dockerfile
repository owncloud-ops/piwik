FROM webhippie/php-caddy:latest-amd64

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
    org.label-schema.name="Piwik" \
    org.label-schema.vendor="ownCloud GmbH" \
    org.label-schema.schema-version="1.0"

ARG BUILD_VERSION=latest
ENV PIWIK_VERSION="${BUILD_VERSION:-latest}"
ENV CRON_ENABLED=true

ADD overlay/ /

RUN apk update && \
  apk add php7-ldap && \
  rm -rf /var/cache/apk/* && \
  PIWIK_VERSION="${PIWIK_VERSION##v}" && \
  echo "Installing Piwik version '${PIWIK_VERSION}' ..." && \
  curl -sLo - https://builds.piwik.org/piwik-${PIWIK_VERSION}.tar.gz | tar -xzf - --strip 1 -C /srv/www && \
  rm -f /srv/www/index.html && \
  chown -R caddy:caddy /srv/www

EXPOSE 8080

WORKDIR /srv/www
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]
