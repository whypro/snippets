#docker run --name shadowsocks --network host -v ${HOME}/gfw/ss-local.json:/etc/shadowsocks/config.json -d shadowsocks/shadowsocks-libev:v3.3.0 ss-local -c /etc/shadowsocks/config.json
#docker run --name polipo --network host -d --entrypoint polipo vimagick/polipo proxyAddress=127.0.0.1 proxyPort=8123 socksParentProxy=127.0.0.1:1080
docker-compose up -d
