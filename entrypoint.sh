#!/bin/bash

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi
 
SONARQUBE_LDAP_ENABLE=${SONARQUBE_LDAP_ENABLE:-false}
SONARQUBE_BASE_DN=${SONARQUBE_BASE_DN}
SONARQUBE_LDAP_PASSWORD=${SONARQUBE_LDAP_PASSWORD}

SONARQUBE_REALM=${REALM:-SAMDOM.EXAMPLE.COM}
SONARQUBE_LDAP_BINDDN=${SONARQUBE_LDAP_BINDDN:-"administrator@$SONARQUBE_REALM"}
SONARQUBE_LDAP_URL=${SONARQUBE_LDAP_URL:-"ldap://localhost:389"}
SETUP_LOCK_FILE="/opt/sonarqube/conf/.setup.lock.do.not.remove"

if [ ! -f "${SETUP_LOCK_FILE}" ]; then
    echo "No Setup file has been found..."
    echo "SONARQUBE_LDAP_ENABLE: $SONARQUBE_LDAP_ENABLE"
    echo "SONARQUBE_LDAP_PASSWORD: $SONARQUBE_LDAP_PASSWORD"
    echo "SONARQUBE_BASE_DN: $SONARQUBE_BASE_DN"

    if [  "${SONARQUBE_LDAP_ENABLE}" != "false" ] && [  ! -z "$SONARQUBE_LDAP_PASSWORD" ]  && [  ! -z "$SONARQUBE_BASE_DN" ] ; then
        echo "Setup SonarQube LDAP Plugin..."

        LDAP_CONFIG="# LDAP configuration \n
        # General Configuration\n
        sonar.security.realm=LDAP\n
        ldap.url=$SONARQUBE_LDAP_URL\n
        ldap.bindDn=$SONARQUBE_LDAP_BINDDN\n
        ldap.bindPassword=$SONARQUBE_LDAP_PASSWORD\n\n

        # User Configuration\n
        ldap.user.baseDn=$SONARQUBE_BASE_DN\n
        ldap.user.request=(&(objectClass=user)(sAMAccountName={login}))\n
        ldap.user.realNameAttribute=cn\n\n

        # Group Configuration\n
        ldap.group.baseDn=$SONARQUBE_BASE_DN\n
        ldap.group.request=(&(objectClass=group)(member={dn}))\n
        #ldap.group.idAttribute=sAMAccountName"
        
        echo '======================================'
        echo -e $LDAP_CONFIG
        echo '======================================'

        echo -e $LDAP_CONFIG >>  /opt/sonarqube/conf/sonar.properties
    fi   
    touch "${SETUP_LOCK_FILE}"
fi
  
exec su-exec sonarqube \
  java -jar lib/sonar-application-6.5.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"