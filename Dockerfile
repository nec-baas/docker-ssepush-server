FROM necbaas/tomcat:9.0.62

# Install SSEPush Server
ENV SSEPUSH_VERSION 7.5.1
RUN cd /opt \
    && aria2c -x5 --check-certificate=false https://github.com/nec-baas/ssepush-server/releases/download/v$SSEPUSH_VERSION/ssepush-server-$SSEPUSH_VERSION.tar.gz \
    && tar xzf ssepush-server-$SSEPUSH_VERSION.tar.gz \
    && cp ssepush-server-$SSEPUSH_VERSION/ssepush.war /opt/tomcat/webapps/ \
    && /bin/rm -rf ssepush-server-$SSEPUSH_VERSION*
 
# Add config files
RUN mkdir /etc/ssepush /var/log/ssepush
ADD config.template.xml /etc/ssepush/
ADD logback.template.properties /etc/ssepush/
ADD server.template.xml /

# Fix permission
RUN chmod -R ugo+rwx /etc/ssepush /var/log/ssepush

# Add startup script
ADD bootstrap.sh /
RUN chmod +x /bootstrap.sh

# Volume options
VOLUME ["/opt/tomcat/logs", "/var/log/ssepush"]
 
# Open Tomcat port
EXPOSE 8080

CMD ["/bootstrap.sh"]

