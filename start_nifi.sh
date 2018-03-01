#!/bin/sh

set -e

do_site2site_configure() {
  sed -i "s/nifi\.web\.http\.port=.*/nifi.web.http.port=${NIFI_WEB_HTTP_PORT:-8080}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.host=.*/nifi.remote.input.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.socket\.port=.*/nifi.remote.input.socket.port=${S2S_PORT:-2881}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
}

do_cluster_node_configure() {
  sed -i "s/nifi\.web\.http\.host=.*/nifi.web.http.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties

  ZK_NODES=$(echo ${ZK_NODES_LIST} | sed -e "s/\s/,/g" -e "s/\(,\)*/\1/g")

  sed -i "s/clientPort=.*/clientPort=${ZK_CLIENT_PORT:-2181}/g" ${NIFI_HOME}/conf/zookeeper.properties
  ZK_CONNECT_STRING=$(echo $ZK_NODES | sed -e "s/,/:${ZK_CLIENT_PORT:-2181},/g" -e "s/$/:${ZK_CLIENT_PORT:-2181}/g")

  sed -i "s/nifi\.cluster\.protocol\.is\.secure=true/nifi.cluster.protocol.is.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.address=.*/nifi.cluster.node.address=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties

  if [ -z "$ELECTION_TIME" ]; then ELECTION_TIME="5 mins"; fi
  sed -i "s/nifi\.cluster\.flow\.election\.max\.wait\.time=.*/nifi.cluster.flow.election.max.wait.time=${ELECTION_TIME}/g" ${NIFI_HOME}/conf/nifi.properties
  
  sed -i "s/nifi\.cluster\.node\.protocol\.port=.*/nifi.cluster.node.protocol.port=${NODE_PROTOCOL_PORT:-2882}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.zookeeper\.connect\.string=.*/nifi.zookeeper.connect.string=$ZK_CONNECT_STRING/g" ${NIFI_HOME}/conf/nifi.properties

  if [ -z "$ZK_ROOT_NODE" ]; then ZK_ROOT_NODE="nifi"; fi
  sed -i "s/nifi\.zookeeper\.root\.node=.*/nifi.zookeeper.root.node=\/$ZK_ROOT_NODE/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/<property name=\"Connect String\">.*</<property name=\"Connect String\">$ZK_CONNECT_STRING</g" ${NIFI_HOME}/conf/state-management.xml
 
  if [ ! -z "$ZK_MYID" ]; then
    sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=false/nifi.state.management.embedded.zookeeper.start=true/g" ${NIFI_HOME}/conf/nifi.properties
    mkdir -p ${NIFI_HOME}/state/zookeeper
    echo ${ZK_MYID} > ${NIFI_HOME}/state/zookeeper/myid
  fi

  sed -i "/^server\./,$ d" ${NIFI_HOME}/conf/zookeeper.properties
  srv=1; IFS=","; for node in $ZK_NODES; do sed -i "\$aserver.$srv=$node:${ZK_MONITOR_PORT:-2888}:${ZK_ELECTION_PORT:-3888}" ${NIFI_HOME}/conf/zookeeper.properties; let "srv+=1"; done
}

sed -i "s/nifi\.ui\.banner\.text=.*/nifi.ui.banner.text=${BANNER_TEXT}/g" ${NIFI_HOME}/conf/nifi.properties
do_site2site_configure

if [ ! -z "$IS_CLUSTER_NODE" ]; then do_cluster_node_configure; fi

tail -F ${NIFI_HOME}/logs/nifi-app.log &
${NIFI_HOME}/bin/nifi.sh run
