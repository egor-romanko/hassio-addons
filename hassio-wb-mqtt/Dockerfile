ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

WORKDIR /usr/src

RUN  apk update && apk upgrade \
     && apk add --no-cache \
     libc6-compat mosquitto-dev jsoncpp-dev supervisor \
     && apk add --no-cache --virtual .build-dependencies \
     git gcc g++ curl-dev make \
     && mkdir /usr/include/jsoncpp \
     && ln -s /usr/include/json /usr/include/jsoncpp/json \
     && git clone https://github.com/contactless/libwbmqtt \
     && cd libwbmqtt/ \
     && make install \
     && ln -s /usr/lib/libjsoncpp.so /usr/lib/libjsoncpp.so.1 \
     && git clone https://github.com/contactless/wb-mqtt-serial \ 
     && cd wb-mqtt-serial/ \
     && git checkout b58278b0ed9b53028316f74dd836842f4bccf937 \
     && make install DESTDIR=/ \
     && rm -fr /usr/src/libwbmqtt \
     && rm -fr /usr/src/wb-mqtt-serial \
     &&  apk del .build-dependencies

COPY supervisord.conf /etc/supervisord.conf
COPY data/run.sh /
COPY data/options.json /data/options.json

RUN chmod a+x /run.sh
CMD ["/run.sh"]