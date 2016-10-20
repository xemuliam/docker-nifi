#!/bin/sh

set -e

do_site2site_configure() {
  sed -i "s/nifi\.remote\.input\.socket\.port=.*/nifi.remote.input.socket.port=1010${MYID}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
}

do_cluster_node_configure() {
# NiFi properties
  sed -i "s/nifi\.cluster\.protocol\.is\.secure=true/nifi.cluster.protocol.is.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.protocol\.port=.*/nifi.cluster.node.protocol.port=1020${MYID}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.zookeeper\.connect\.string=.*/nifi.zookeeper.connect.string=${ZK_NODES_LIST}/g" ${NIFI_HOME}/conf/nifi.properties
  if ["$USE_EMBEDDED_ZK" == "true"]; then
    sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=false/nifi.state.management.embedded.zookeeper.start=true/g" ${NIFI_HOME}/conf/nifi.properties
  else 
    sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=true/nifi.state.management.embedded.zookeeper.start=false/g" ${NIFI_HOME}/conf/nifi.properties
  fi

# State management
  sed -i "s/<property name=\"Connect String\">.*</<property name=\"Connect String\">${ZK_NODES_LIST}</g" ${NIFI_HOME}/conf/state-management.xml

# MyId zookeeper
  mkdir -p ${NIFI_HOME}/state/zookeeper
  echo ${MYID} > ${NIFI_HOME}/state/zookeeper/myid

# Zookeeper properties
#  sed -i "/^server\.1=/q" ${NIFI_HOME}/conf/zookeeper.properties; sed -i "s/^server\.1=.*/server.1=/g" ${NIFI_HOME}/conf/zookeeper.properties
}

do_site2site_configure

if ["$INSTANCE_ROLE" == "cluster-node"]; then
  do_cluster_node_configure
fi

tail -F ${NIFI_HOME}/logs/nifi-app.log &
${NIFI_HOME}/bin/nifi.sh run
