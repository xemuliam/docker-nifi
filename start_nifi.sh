#!/bin/bash

splash() {
  echo 'Environment:'
  echo "BANNER_TEXT=$BANNER_TEXT"
}

configure_common() {
  sed -i "s/nifi\.ui\.banner\.text=/nifi.ui.banner.text=${BANNER_TEXT}/g" $NIFI_HOME/conf/nifi.properties
}

configure_site2site() {
  # configure the receiving end of site2site
  sed -i "s/nifi\.remote\.input\.socket\.host=/nifi.remote.input.socket.host=${HOSTNAME}/g" $NIFI_HOME/conf/nifi.properties
  sed -i "s/nifi\.remote\.input\.socket\.port=/nifi.remote.input.socket.port=12345/g" $NIFI_HOME/conf/nifi.properties
  # unsecure for now so we don't complicate the setup with certificates
  sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" $NIFI_HOME/conf/nifi.properties
}

configure_cluster_node() {
  # can't set to 0.0.0.0, as this address is then sent verbatim to NCM, which, in turn
  # does not resolve it back to the node. If it's set to the ${HOSTNAME}, the cluster works,
  # but the node's web ui is not accessible on the external network
  #sed -i "s/nifi\.web\.http\.host=/nifi.web.http.host=0.0.0.0/g" $NIFI_HOME/conf/nifi.properties
  sed -i "s/nifi\.web\.http\.host=/nifi.web.http.host=${HOSTNAME}/g" $NIFI_HOME/conf/nifi.properties
  sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" $NIFI_HOME/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.address=/nifi.cluster.node.address=${HOSTNAME}/g" $NIFI_HOME/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.protocol\.port=/nifi.cluster.node.protocol.port=12346/g" $NIFI_HOME/conf/nifi.properties
  # the following properties point to the NCM - note we are using the network alias (implicitly created by docker-compose)
  sed -i "s/nifi\.cluster\.node\.unicast\.manager\.address=/nifi.cluster.node.unicast.manager.address=ncm/g" $NIFI_HOME/conf/nifi.properties
  sed -i "s/nifi\.cluster\.node\.unicast\.manager\.protocol\.port=/nifi.cluster.node.unicast.manager.protocol.port=20001/g" $NIFI_HOME/conf/nifi.properties
}

configure_cluster_manager() {
  sed -i "s/nifi\.web\.http\.host=/nifi.web.http.host=0.0.0.0/g" $NIFI_HOME/conf/nifi.properties
  sed -i "s/nifi\.cluster\.is\.manager=false/nifi.cluster.is.manager=true/g" $NIFI_HOME/conf/nifi.properties
  sed -i "s/nifi\.cluster\.manager\.address=/nifi.cluster.manager.address=${HOSTNAME}/g" $NIFI_HOME/conf/nifi.properties
  sed -i "s/nifi\.cluster\.manager\.protocol\.port=/nifi.cluster.manager.protocol.port=20001/g" $NIFI_HOME/conf/nifi.properties
}

splash
configure_common

# we don't configure acquisition node to serve site-to-site requests,
# the node initiates push/pull only

if [ "$NIFI_INSTANCE_ROLE" == "single-node" ]; then
  configure_site2site
fi

if [ "$NIFI_INSTANCE_ROLE" == "cluster-node" ]; then
  configure_site2site
  configure_cluster_node
fi

if [ "$NIFI_INSTANCE_ROLE" == "cluster-manager" ]; then
  configure_site2site
  configure_cluster_manager
fi

# must be an exec so NiFi process replaces this script and receives signals
${NIFI_HOME}/bin/nifi.sh run
