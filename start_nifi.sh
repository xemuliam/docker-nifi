#!/bin/sh

set -e

do_site2site_configure() {
  if [ -z "$S2S_PORT" ]; then S2S_PORT=2881; fi
  sed -i "s/nifi\.remote\.input\.socket\.host=.*/nifi.remote.input.socket.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.socket\.port=.*/nifi.remote.input.socket.port=${S2S_PORT}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
}

do_cluster_manager_configure() {
  sed -i "s/nifi\.web\.http\.host=.*/nifi.web.http.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.is\.manager=false/nifi.cluster.is.manager=true/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.manager\.address=.*/nifi.cluster.manager.address=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties

  if [ -z "$MANAGER_PROTOCOL_PORT" ]; then MANAGER_PROTOCOL_PORT=2883; fi
  sed -i "s/nifi\.cluster\.manager\.protocol\.port=.*/nifi.cluster.manager.protocol.port=${MANAGER_PROTOCOL_PORT}/g" ${NIFI_HOME}/conf/nifi.properties
}

do_cluster_node_configure() {
  sed -i "s/nifi\.web\.http\.host=.*/nifi.web.http.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.protocol\.is\.secure=true/nifi.cluster.protocol.is.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.address=.*/nifi.cluster.node.address=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties

  if [ -z "$NODE_PROTOCOL_PORT" ]; then NODE_PROTOCOL_PORT=2882; fi
  sed -i "s/nifi\.cluster\.node\.protocol\.port=.*/nifi.cluster.node.protocol.port=${NODE_PROTOCOL_PORT}/g" ${NIFI_HOME}/conf/nifi.properties

  sed -i "s/nifi\.cluster\.node\.unicast\.manager\.address=.*/nifi.cluster.node.unicast.manager.address=${NCM}/g" ${NIFI_HOME}/conf/nifi.properties
  if [ -z "$MANAGER_PROTOCOL_PORT" ]; then MANAGER_PROTOCOL_PORT=2883; fi
  sed -i "s/nifi\.cluster\.node\.unicast\.manager\.protocol\.port=.*/nifi.cluster.node.unicast.manager.protocol.port=${$MANAGER_PROTOCOL_PORT}/g" ${NIFI_HOME}/conf/nifi.properties
}

sed -i "s/nifi\.ui\.banner\.text=.*/nifi.ui.banner.text=${BANNER_TEXT}/g" ${NIFI_HOME}/conf/nifi.properties
do_site2site_configure

if [ ! -z "$IS_CLUSTER_MANAGER" ]; then
  do_cluster_manager_configure
fi

if [ ! -z "$IS_CLUSTER_NODE" ]; then
  do_cluster_node_configure
fi

tail -F ${NIFI_HOME}/logs/nifi-app.log &
${NIFI_HOME}/bin/nifi.sh run
