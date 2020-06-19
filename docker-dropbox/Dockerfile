# Based on Debian-slim (minimal)
FROM debian:buster-slim

# Maintainer
#fork https://github.com/otherguy/docker-dropbox
LABEL maintainer "Marllus Lustosa <marllus.lustosa@sti.ufc.br>"

# Build arguments
ARG VCS_REF=master
ARG BUILD_DATE=""

# http://label-schema.org/rc1/
LABEL org.label-schema.schema-version "1.0"
LABEL org.label-schema.name           "Dropbox"
LABEL org.label-schema.build-date     "${BUILD_DATE}"
LABEL org.label-schema.description    "Standalone Dropbox client"
LABEL org.label-schema.vcs-url        "https://github.com/otherguy/docker-dropbox"
LABEL org.label-schema.vcs-ref        "${VCS_REF}"

# Required to prevent warnings
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true

# Install prerequisites
#dirmngr
RUN apt-get update \
 && apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl gnupg2 \
                                               software-properties-common gosu locales locales-all \
                                               libc6 libglapi-mesa libxdamage1 libxfixes3 libxcb-glx0 \
                                               libxcb-dri2-0 libxcb-dri3-0 libxcb-present0 libxcb-sync1 \
                                               libxshmfence1 libxxf86vm1 tzdata

# Create user and group
RUN mkdir -p /opt/dropbox /opt/dropbox/.dropbox /opt/dropbox/Dropbox \
 && useradd --home-dir /opt/dropbox --comment "Dropbox Daemon Account" --user-group --shell /usr/sbin/nologin dropbox \
 && chown -R dropbox:dropbox /opt/dropbox

# Set language
ENV LANG     "pt_BR.UTF-8"
ENV LANGUAGE "pt_BR.UTF-8"
ENV LC_ALL   "pt_BR.UTF-8"

# Generate locales
RUN sed --in-place '/pt_BR.UTF-8/s/^# //' /etc/locale.gen \
 && locale-gen

# Change working directory
WORKDIR /opt/dropbox/Dropbox

# Not really required for --net=host
EXPOSE 17500

# https://help.dropbox.com/installs-integrations/desktop/linux-repository
#caso nao esteja com a porta 11371 aberta para saida, entao mudar para hkp://keyserver.ubuntu.com:80
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FC918B335044912E \
 && add-apt-repository 'deb http://linux.dropbox.com/debian stretch main' \
 && apt-get update \
 && apt-get -qqy install python3-gpg dropbox \
 && apt-get -qqy autoclean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Dropbox insists on downloading its binaries itself via 'dropbox start -i'
RUN echo "y" | gosu dropbox dropbox start -i

# Dropbox has the nasty tendency to update itself without asking. In the processs it fills the
# file system over time with rather large files written to /opt/dropbox/ and /tmp.
#
# https://bbs.archlinux.org/viewtopic.php?id=191001
RUN mkdir -p /opt/dropbox/bin/ \
 && mv /opt/dropbox/.dropbox-dist/* /opt/dropbox/bin/ \
 && rm -rf /opt/dropbox/.dropbox-dist \
 && install -dm0 /opt/dropbox/.dropbox-dist \
 && chmod u-w /opt/dropbox/.dropbox-dist \
 && chmod o-w /tmp \
 && chmod g-w /tmp

# Create volumes
VOLUME ["/opt/dropbox/.dropbox", "/opt/dropbox/Dropbox"]

# Install init script and dropbox command line wrapper
COPY docker-entrypoint.sh /

# Set entrypoint and command
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/opt/dropbox/bin/dropboxd"]
