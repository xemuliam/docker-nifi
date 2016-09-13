#!/bin/sh

do_site2site_configure() {
  sed -i "s/nifi\.ui\.banner\.text=.*/nifi.ui.banner.text=${BANNER_TEXT}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.web\.http\.host=.*/nifi.web.http.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.socket\.host=.*/nifi.remote.input.socket.host=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.socket\.port=.*/nifi.remote.input.socket.port=11111/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" ${NIFI_HOME}/conf/nifi.properties
}

do_cluster_manager_configure() {
  sed -i "s/nifi\.cluster\.is\.manager=false/nifi.cluster.is.manager=true/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.manager\.address=.*/nifi.cluster.manager.address=ncm/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.manager\.protocol\.port=.*/nifi.cluster.manager.protocol.port=22222/g" ${NIFI_HOME}/conf/nifi.properties
}

do_cluster_node_configure() {
  sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.address=.*/nifi.cluster.node.address=${HOSTNAME}/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.unicast\.manager\.address=.*/nifi.cluster.node.unicast.manager.address=ncm/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.unicast\.manager\.protocol\.port=.*/nifi.cluster.node.unicast.manager.protocol.port=22222/g" ${NIFI_HOME}/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.protocol\.port=.*/nifi.cluster.node.protocol.port=33333/g" ${NIFI_HOME}/conf/nifi.properties
}

if [ "$NIFI_INSTANCE_ROLE" == "single-node" ]; then
  do_site2site_configure
fi

if [ "$NIFI_INSTANCE_ROLE" == "cluster-manager" ]; then
  do_site2site_configure
  do_cluster_manager_configure
fi

if [ "$NIFI_INSTANCE_ROLE" == "cluster-node" ]; then
  do_site2site_configure
  do_cluster_node_configure
fi

tail -F ${NIFI_HOME}/logs/nifi-app.log &
${NIFI_HOME}/bin/nifi.sh run
