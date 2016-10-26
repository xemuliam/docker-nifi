#!/bin/sh

set -e

do_site2site_configure() {
  sed -i "s/nifi\.remote\.input\.host=.*/nifi.remote.input.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.socket\.port=.*/nifi.remote.input.socket.port=2881/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
}

do_cluster_node_configure() {
  ZK_NODES=$(echo ${ZK_NODES_LIST} | sed -e "s/\s/,/g" -e "s/\(,\)*/\1/g")

  if [ ! -z "$ZK_CLIENT_PORT" ]; then
    ZK_CONNECT_STRING=$(echo $ZK_NODES | sed -e "s/,/:${ZK_CLIENT_PORT},/g" -e "s/$/:${ZK_CLIENT_PORT}/g")
    sed -i "s/clientPort=.*/clientPort=${ZK_CLIENT_PORT}/g" ${NIFI_HOME}/conf/zookeeper.properties
  else
    ZK_CONNECT_STRING=$(echo $ZK_NODES | sed -e "s/,/:2181,/g" -e "s/$/:2181/g")
  fi

  sed -i "s/nifi\.web\.http\.host=.*/nifi.web.http.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.protocol\.is\.secure=true/nifi.cluster.protocol.is.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.address=.*/nifi.cluster.node.address=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.protocol\.port=.*/nifi.cluster.node.protocol.port=2882/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.zookeeper\.connect\.string=.*/nifi.zookeeper.connect.string=$ZK_CONNECT_STRING/g" ${NIFI_HOME}/conf/nifi.properties

  sed -i "s/<property name=\"Connect String\">.*</<property name=\"Connect String\">$ZK_CONNECT_STRING</g" ${NIFI_HOME}/conf/state-management.xml
 
  if [ ! -z "$ZK_MYID" ]; then
    sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=false/nifi.state.management.embedded.zookeeper.start=true/g" ${NIFI_HOME}/conf/nifi.properties

    mkdir -p ${NIFI_HOME}/state/zookeeper
    echo ${ZK_MYID} > ${NIFI_HOME}/state/zookeeper/myid
  else 
    sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=true/nifi.state.management.embedded.zookeeper.start=false/g" ${NIFI_HOME}/conf/nifi.properties
  fi

  if [ -z "$ZK_INTERCOM_PORT" ]; then
    ZK_INTERCOM_PORT=2888
  elif [ -z "$ZK_ELECTION_PORT" ]; then
    ZK_ELECTION_PORT=3888
  fi
  sed -i "/^server\./,$ d" ${NIFI_HOME}/conf/zookeeper.properties
  srv=1; IFS=","; for node in $ZK_NODES; do sed -i "\$aserver.$srv=$node:${ZK_INTERCOM_PORT}:${ZK_ELECTION_PORT}" ${NIFI_HOME}/conf/zookeeper.properties; let "srv+=1"; done
}

do_site2site_configure

if [ ! -z "$IS_CLUSTER_NODE" ]; then
  do_cluster_node_configure
fi

tail -F ${NIFI_HOME}/logs/nifi-app.log &
${NIFI_HOME}/bin/nifi.sh run
