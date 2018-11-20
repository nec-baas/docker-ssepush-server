#!/bin/sh

# 環境変数
export AMQP_URI=${AMQP_URI:-amqp://rabbitmq:rabbitmq@rabbitmq.local:5672}
export HEART_BEAT_INTERVAL_SEC=${HEART_BEAT_INTERVAL_SEC:-30}

export LOG_LEVEL=${LOG_LEVEL:-INFO}

export TOMCAT_MAX_THREADS=${TOMCAT_MAX_THREADS:-2000}
export TOMCAT_MAX_CONNECTIONS=${TOMCAT_MAX_CONNECTIONS:-2000}
export TOMCAT_SCHEME=${TOMCAT_SCHEME:-http}
export TOMCAT_SECURE=${TOMCAT_SECURE:-false}
export TOMCAT_PROXY_PORT=${TOMCAT_PROXY_PORT:-}

export TOMCAT_CONN_OTHER_CFGS=
if [ -n "$TOMCAT_PROXY_PORT" ]; then
    export TOMCAT_CONN_OTHER_CFGS="proxyPort=\"$TOMCAT_PROXY_PORT\""
fi

# Tomcat server.xml設定
cat server.template.xml | envsubst > /opt/tomcat/conf/server.xml

# SSE push 設定ファイル生成
cat /etc/ssepush/config.template.xml | envsubst > /etc/ssepush/config.xml
 
# logback設定ファイル生成
cat /etc/ssepush/logback.template.properties | envsubst > /etc/ssepush/logback.properties
 
# tomcat 起動 (foreground)
exec /opt/tomcat/bin/catalina.sh run
