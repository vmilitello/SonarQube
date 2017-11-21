
FROM sonarqube:6.5-alpine

LABEL MAINTAINER="Vincenzo Militello <v.militello@902software.com>"

ENV TERM=xterm-color
RUN apk --update --no-cache add \
        su-exec \
        nano \
        bash \
        curl

#Copy some bash defaults
COPY bash.default .bashrc
RUN chmod 755 .bashrc

ENV SONARQUBE_JDBC_URL= \
    WEB_PLUGIN_VERSION=2.5.0.476 \
    LDAP_PLUGIN_VERSION=2.2.0.608  \
    TS_PLUGIN_VERSION=1.1.0.1079 \
    SONARQUBE_HOME=/opt/sonarqube 

# remove LDAP, WEB AND TS plugins (if exist)
RUN \
	rm -rf $SONARQUBE_HOME/extensions/plugins/sonar-ldap-*.jar \
    && rm -rf $SONARQUBE_HOME/extensions/plugins/sonar-web-*.jar  \
    && rm -rf $SONARQUBE_HOME/extensions/plugins/sonar-typescript-*.jar  


#INSTALL LDAP_PLUGIN_VERSION, WEB_PLUGIN_VERSION AND TS_PLUGIN_VERSION
RUN cd $SONARQUBE_HOME/extensions/plugins/ && \
    curl -sLo ./sonar-ldap-plugin-${LDAP_PLUGIN_VERSION}.jar \
    https://sonarsource.bintray.com/Distribution/sonar-ldap-plugin/sonar-ldap-plugin-${LDAP_PLUGIN_VERSION}.jar \
	&& curl -sLo sonar-web-plugin-plugin-${WEB_PLUGIN_VERSION}.jar \
    https://sonarsource.bintray.com/Distribution/sonar-web-plugin/sonar-web-plugin-${WEB_PLUGIN_VERSION}.jar \
	&& curl -sLo sonar-typescript-plugin-${TS_PLUGIN_VERSION}.jar \
    https://sonarsource.bintray.com/Distribution/sonar-typescript-plugin/sonar-typescript-plugin-${TS_PLUGIN_VERSION}.jar 

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]