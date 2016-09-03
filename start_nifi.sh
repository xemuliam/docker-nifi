#!/bin/sh
set -e

do_ssl_enable() {

#

}
do_ssl_disable() {

sed -i -e 's|^nifi.security.keystore=.*$|nifi.security.keystore=|' ${NIFI_HOME}/conf/nifi.properties
sed -i -e 's|^nifi.security.keystoreType=.*$|nifi.security.keystoreType=|' ${NIFI_HOME}/conf/nifi.properties
sed -i -e 's|^nifi.security.keystorePasswd=.*$|nifi.security.keystorePasswd=|' ${NIFI_HOME}/conf/nifi.properties
sed -i -e 's|^nifi.security.truststore=.*$|nifi.security.truststore=|' ${NIFI_HOME}/conf/nifi.properties
sed -i -e 's|^nifi.security.truststoreType=.*$|nifi.security.truststoreType=|' ${NIFI_HOME}/conf/nifi.properties
sed -i -e 's|^nifi.security.truststorePasswd=.*$|nifi.security.truststorePasswd=|' ${NIFI_HOME}/conf/nifi.properties

}
do_s2s_configure() {

sed -i "s/nifi\.remote\.input\.socket\.host=/nifi.remote.input.socket.host=${HOSTNAME}/g" $NIFI_HOME/conf/nifi.properties
sed -i "s/nifi\.remote\.input\.socket\.port=/nifi.remote.input.socket.port=12345/g" $NIFI_HOME/conf/nifi.properties
sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" $NIFI_HOME/conf/nifi.properties
}
do_cluster_node_configure() {

#

}
if [[ "$SSL_ENABLE" == "true" ]]; then
    do_ssl_enable
else
    do_ssl_disable
fi


if [ "$INSTANCE_ROLE" == "single-node" ]; then
  do_s2s_configure
fi

if [ "$NIFI_INSTANCE_ROLE" == "cluster-node" ]; then
  do_s2s_configure
  echo ${HOSTNAME}
  do_cluster_node_configure
fi
tail -F ${NIFI_HOME}/logs/nifi-app.log &
${NIFI_HOME}/bin/nifi.sh run
