#!/bin/sh

set -e

do_site2site_configure() {
  if [ -z "$S2S_PORT" ]; then S2S_PORT=2881; fi
  sed -i "s/nifi\.remote\.input\.host=.*/nifi.remote.input.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.socket\.port=.*/nifi.remote.input.socket.port=${S2S_PORT}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
}

do_cluster_node_configure() {
  ZK_NODES=$(echo ${ZK_NODES_LIST} | sed -e "s/\s/,/g" -e "s/\(,\)*/\1/g")

  if [ -z "$ZK_CLIENT_PORT" ]; then ZK_CLIENT_PORT=2181; fi
  sed -i "s/clientPort=.*/clientPort=${ZK_CLIENT_PORT}/g" ${NIFI_HOME}/conf/zookeeper.properties
  ZK_CONNECT_STRING=$(echo $ZK_NODES | sed -e "s/,/:${ZK_CLIENT_PORT},/g" -e "s/$/:${ZK_CLIENT_PORT}/g")

  sed -i "s/nifi\.web\.http\.host=.*/nifi.web.http.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.protocol\.is\.secure=true/nifi.cluster.protocol.is.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.address=.*/nifi.cluster.node.address=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties

  if [ -z "$NODE_PROTOCOL_PORT" ]; then NODE_PROTOCOL_PORT=2882; fi
  sed -i "s/nifi\.cluster\.node\.protocol\.port=.*/nifi.cluster.node.protocol.port=${NODE_PROTOCOL_PORT}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.zookeeper\.connect\.string=.*/nifi.zookeeper.connect.string=$ZK_CONNECT_STRING/g" ${NIFI_HOME}/conf/nifi.properties

  sed -i "s/<property name=\"Connect String\">.*</<property name=\"Connect String\">$ZK_CONNECT_STRING</g" ${NIFI_HOME}/conf/state-management.xml
 
  if [ ! -z "$ZK_MYID" ]; then
    sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=false/nifi.state.management.embedded.zookeeper.start=true/g" ${NIFI_HOME}/conf/nifi.properties

    mkdir -p ${NIFI_HOME}/state/zookeeper
    echo ${ZK_MYID} > ${NIFI_HOME}/state/zookeeper/myid
  else 
    sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=true/nifi.state.management.embedded.zookeeper.start=false/g" ${NIFI_HOME}/conf/nifi.properties
  fi

  if [ -z "$ZK_NODE_CHECK_PORT" ]; then ZK_NODE_CHECK_PORT=2888; fi
  if [ -z "$ZK_ELECTION_PORT" ]; then ZK_ELECTION_PORT=3888; fi
  sed -i "/^server\./,$ d" ${NIFI_HOME}/conf/zookeeper.properties
  srv=1; IFS=","; for node in $ZK_NODES; do sed -i "\$aserver.$srv=$node:${ZK_NODE_CHECK_PORT}:${ZK_ELECTION_PORT}" ${NIFI_HOME}/conf/zookeeper.properties; let "srv+=1"; done
}

do_site2site_configure

if [ ! -z "$IS_CLUSTER_NODE" ]; then
  do_cluster_node_configure
fi

tail -F ${NIFI_HOME}/logs/nifi-app.log &
${NIFI_HOME}/bin/nifi.sh run
