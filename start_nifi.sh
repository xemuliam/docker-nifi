#!/bin/sh

set -e

do_site2site_configure() {
  sed -i "s/nifi\.ui\.banner\.text=/nifi.ui.banner.text=${BANNER_TEXT}/g" ${NIFI_HOME}/conf/nifi.properties
#  sed -i "s/nifi\.remote\.input\.host=/nifi.remote.input.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.socket\.port=/nifi.remote.input.socket.port=11111/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
}

do_cluster_node_configure() {
# NiFi properties
#  sed -i "s/nifi\.web\.http\.port=/nifi.web.http.port=8080/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.address=/nifi.cluster.node.address=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.protocol\.port=/nifi.cluster.node.protocol.port=22222/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=false/nifi.state.management.embedded.zookeeper.start=true/g" ${NIFI_HOME}/conf/nifi.properties
#  sed -i "s/nifi\.state\.management\.provider\.cluster=/nifi.state.management.provider.cluster=zk-provider/g" ${NIFI_HOME}/conf/nifi.properties
#  sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.properties=/nifi.state.management.embedded.zookeeper.properties=./conf/zookeeper.properties/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.zookeeper\.connect\.string=/nifi.zookeeper.connect.string=${ZOOKEEPER_CONNECT}/g" ${NIFI_HOME}/conf/nifi.properties

# State management
  sed -i "s/<property name=\"Connect String\">/<property name=\"Connect String\">${ZOOKEEPER_CONNECT}/g" ${NIFI_HOME}/conf/state-management.xml

# MyId zookeeper
  mkdir ${NIFI_HOME}/state
  mkdir ${NIFI_HOME}/state/zookeeper
  echo ${MYID} > ${NIFI_HOME}/state/zookeeper/myid
}


if [ "$INSTANCE_ROLE" == "single-node" ]; then
  do_site2site_configure
fi

if [ "$INSTANCE_ROLE" == "cluster-node" ]; then
  do_site2site_configure
  do_cluster_node_configure
fi


tail -F ${NIFI_HOME}/logs/nifi-app.log &
${NIFI_HOME}/bin/nifi.sh run
