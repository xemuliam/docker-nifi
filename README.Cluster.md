# Zero-master clustering paradigm

There are two significant changes in comparison with 0.x version:
- There is no longer a NiFi Cluster Manager (NCM)
- Cluster will now auto elect a Cluster Coordinator to oversee the cluster

Useful arcticle can be found [here](http://hortonworks.com/blog/apache-nifi-1-0-0-zero-master-clustering).


# Zookeeper limitations

Zookeeper is included in NiFi libs. So it is not required to use external Zookeper server/cluster to be able to build NiFi cluster.
However plese bear in mind that Zookeeper cluster can work only in _flat_ configuration without scaling. Thus if you want to build NiFi cluster with embedded Zookeeper you should forget about scaling of NiFi nodes with embedded Zookeeper. **Only nodes _without_ embedded Zookeeper can be scaled up and down**. 


# Docker Networking

Creating an overlay network in advance is **no longer required**.

Additional information about Docker overlay networking is [here](https://github.com/docker/docker/blob/master/docs/userguide/networking/get-started-overlay.md)


# Additional image environment properties

To add more flexibility in configuration there are some environment variables have been added to the image.  
All of them are hidden however can be used in `docker-compose`.  

- S2S_PORT - NiFi Site-to-site communication port. If empty, default value will be used: 2881
- IS_CLUSTER_NODE - If _**not**_ empty, NiFi instance will be treated as part of NiFi cluster
- NODE_PROTOCOL_PORT - NiFi cluster nodes intercommunication port. If empty, default value will be used: 2882
- ZK_NODES_LIST - List of Zookeeper nodes divided by commas or spaces. Can contain list of NiFi nodes or external Zookeeper nodes. If empty, cluster will not work (see above "Zero master clustering paradigm")
- ZK_CLIENT_PORT - Port for Zookeeper client. If empty, default value will be used: 2181
- ZK_MYID - ID of embedded Zookeper node and switch on embedded Zookeper starting when NiFi starts. If empty, embedded Zookeper will not start
- ZK_MONITOR_PORT - Port for Zookeeper monitoring of NiFi nodes' availability. If empty, default value will be used: 2888
- ZK_ELECTION_PORT - Port for Zookeeper election of NiFi Cluster Coordinator node. If empty, default value will be used: 3888


# Single-Host cluster

## TBD


# Multi-Host cluster

## Automated Environment bootstrap

Go to your checkout directory.
Run the `create_vms.sh` in the root folder to create required set of virtual machines.


## Attaching console session to swarm master
`eval $(docker-machine env --swarm host1)`


## Pull images on every host
To ensure smooth operations of `docker-compose` it is recommended to cache a container image on every node:

`docker-compose pull`


## Start the containers
`docker-compose up` for forground (interactive) mode

or

`docker-compose up -d` for background (detached) mode


## Where's my UI?
If you are running `docker-compose` in a foreground, open a new terminal and execute these commands:
```
$> eval $(docker-machine env --swarm host1)
$> docker-compose ps
```
Now you can see all containers with status and bind ports. Use ip and port in your web-browser.
