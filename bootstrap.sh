#!/bin/sh

# 環境変数
AMQP_URI=${AMQP_URI:-amqp://rabbitmq:rabbitmq@rabbitmq.local:5672}
HEART_BEAT_INTERVAL_SEC=${HEART_BEAT_INTERVAL_SEC:-30}
LOG_LEVEL=${LOG_LEVEL:-INFO}
TOMCAT_MAX_THREADS=${TOMCAT_MAX_THREADS:-2000}
TOMCAT_MAX_CONNECTIONS=${TOMCAT_MAX_CONNECTIONS:-2000}
TOMCAT_SCHEME=${TOMCAT_SCHEME:-http}
TOMCAT_SECURE=${TOMCAT_SECURE:-false}
TOMCAT_PROXY_PORT=${TOMCAT_PROXY_PORT:-}

TOMCAT_CONN_OTHER_CFGS=
if [ -n "$TOMCAT_PROXY_PORT" ]; then
    TOMCAT_CONN_OTHER_CFGS="proxyPort=\"$TOMCAT_PROXY_PORT\""
fi

# Tomcat server.xml設定
cat server.template.xml \
    | sed "s/%TOMCAT_MAX_THREADS%/$TOMCAT_MAX_THREADS/" \
    | sed "s/%TOMCAT_MAX_CONNECTIONS%/$TOMCAT_MAX_CONNECTIONS/" \
    | sed "s/%TOMCAT_SCHEME%/$TOMCAT_SCHEME/" \
    | sed "s/%TOMCAT_SECURE%/$TOMCAT_SECURE/" \
    | sed "s/%TOMCAT_CONN_OTHER_CFGS%/$TOMCAT_CONN_OTHER_CFGS/" \
    > /opt/tomcat/conf/server.xml

# 設定ファイル生成
cat /etc/ssepush/config.template.xml \
    | sed "s#%AMQP_URI%#$AMQP_URI#" \
    | sed "s/%HEART_BEAT_INTERVAL_SEC%/$HEART_BEAT_INTERVAL_SEC/" \
    > /etc/ssepush/config.xml
 
# logback設定ファイル生成
cat /etc/ssepush/logback.template.properties \
    | sed "s/%LOG_LEVEL%/$LOG_LEVEL/" \
    > /etc/ssepush/logback.properties
 
# tomcat 起動 (foreground)
exec /opt/tomcat/bin/catalina.sh run
