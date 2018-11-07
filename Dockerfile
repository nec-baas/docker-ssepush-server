FROM necbaas/tomcat

# Add config files
RUN mkdir /etc/ssepush /var/log/ssepush
ADD config.template.xml /etc/ssepush/
ADD logback.template.properties /etc/ssepush/
ADD server.template.xml /

# Fix permission
RUN chmod -R ugo+rwx /etc/ssepush /opt /var/log/ssepush

# Add startup script
ADD bootstrap.sh /
RUN chmod +x /bootstrap.sh

# Volume options
VOLUME ["/opt/tomcat/logs", "/var/log/ssepush"]
 
# Open Tomcat port
EXPOSE 8080

# Install SSEPush Server
ENV SSEPUSH_VERSION 7.5.0
ADD files/ssepush-server-$SSEPUSH_VERSION/ssepush.war /opt/tomcat/webapps/
 
CMD /bootstrap.sh

