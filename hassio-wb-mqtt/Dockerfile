ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

WORKDIR /usr/src

RUN  apk update && apk upgrade \
     && apk add --no-cache \
     libc6-compat mosquitto-dev jsoncpp-dev supervisor nodejs \
     && apk add --no-cache --virtual .build-dependencies \
     git gcc g++ curl-dev make nodejs-npm \
     && mkdir /usr/include/jsoncpp \
     && ln -s /usr/include/json /usr/include/jsoncpp/json \
     && git clone https://github.com/contactless/libwbmqtt \
     && cd libwbmqtt/ \
     && make install \
     && ln -s /usr/lib/libjsoncpp.so /usr/lib/libjsoncpp.so.1 \
     && git clone https://github.com/contactless/wb-mqtt-serial \ 
     && cd wb-mqtt-serial/ \
     && make install DESTDIR=/ \
     && rm -fr /usr/src/libwbmqtt \
     && rm -fr /usr/src/wb-mqtt-serial \
     &&  mkdir /app && cd /app && npm install express fs --production \
     &&  npm prune --production \
     &&  apk del .build-dependencies

COPY /build/ /app/
COPY supervisord.conf /etc/supervisord.conf
COPY data/run.sh /
COPY data/options.json /data/options.json

RUN chmod a+x /run.sh
CMD ["/run.sh"]