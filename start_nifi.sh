#!/bin/sh
set -e

#setting ports!
#sed -i "s/nifi.cluster.manager.protocol.port=/nifi.cluster.manager.protocol.port=9000/g" ${NIFI_HOME}/conf/nifi.properties
#sed -i "s/nifi.cluster.node.protocol.port=/nifi.cluster.node.protocol.port=9001/g" ${NIFI_HOME}/conf/nifi.properties
#sed -i "s/nifi.cluster.node.unicast.manager.protocol.port=/nifi.cluster.node.unicast.manager.protocol.port=9000/g" ${NIFI_HOME}/conf/nifi.properties
#sed -i "s/nifi.cluster.node.unicast.manager.address=/nifi.cluster.node.unicast.manager.address=${NIFI_MASTER}/g" ${NIFI_HOME}/conf/nifi.properties

sed -i "s/nifi.web.http.host=/nifi.web.http.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties

#password
sed -i "s/nifi.sensitive.props.key=/nifi.sensitive.props.key=${PASSWORD}/g" ${NIFI_HOME}/conf/nifi.properties

#if [ ! -z "$ISMANAGER" ]; then
#  sed -i "s/nifi.cluster.is.manager=false/nifi.cluster.is.manager=true/g" ${NIFI_HOME}/conf/nifi.properties
#  sed -i "s/nifi.cluster.manager.address=/nifi.cluster.manager.address=nifi_master/g" ${NIFI_HOME}/conf/nifi.properties
#elif [ ! -z "$ISNODE" ]; then
#  sed -i "s/nifi.cluster.is.node=false/nifi.cluster.is.node=true/g" ${NIFI_HOME}/conf/nifi.properties
#  sed -i "s/nifi.cluster.node.address=/nifi.cluster.node.address=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
#fi

tail -F ${NIFI_HOME}/logs/nifi-app.log &
${NIFI_HOME}/bin/nifi.sh run
