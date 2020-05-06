ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

#Install Icecast
RUN set -ex \
	&& useradd -mUs /bin/bash icecast \
	&& groups icecast

RUN set -ex \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	build-essential \
	icecast2 supervisor \
 && apt-get purge --auto-remove -y \
        curl \
        gcc \
	build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

COPY mopidy.conf /var/lib/mopidy/.config/mopidy/mopidy.conf
COPY icecast.xml /etc/icecast/icecast.xml
COPY supervisord.conf /etc/supervisord.conf

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh
RUN mkdir -p /data/icecast2/logs
RUN touch /data/icecast2/logs/error.log
RUN touch /data/icecast2/logs/access.log
#USER icecast

EXPOSE 6600 6680 8000
CMD [ "/run.sh" ]
