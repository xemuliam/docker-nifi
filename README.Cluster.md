# Zero-master clustering paradigm

There are two significant changes in comparison with 0.x version:
- There is no longer a NiFi Cluster Manager (NCM)
- Cluster will now auto elect a Cluster Coordinator to oversee the cluster

Useful arcticle can be found [here](http://hortonworks.com/blog/apache-nifi-1-0-0-zero-master-clustering).


# Zookeeper limitations

Zookeeper is included in NiFi libs. So it is **not required** to use external Zookeper server/cluster to be able to build NiFi cluster.

However please bear in mind that Zookeeper cluster can work only in _flat_ configuration without scaling. Thus if you want to build NiFi cluster with embedded Zookeeper you should forget about scaling of NiFi nodes with embedded Zookeeper.

**Only nodes _without_ embedded Zookeeper can be scaled up and down**. 


# Additional cluster-related environment properties

To add more flexibility in configuration there are some environment variables have been added to the image.  
All of them are hidden however can be used in `docker-compose`.  

- IS_CLUSTER_NODE - If _**not**_ empty, NiFi instance will be treated as part of NiFi cluster
- NODE_PROTOCOL_PORT - NiFi cluster nodes intercommunication port. If empty, following value will be used: 2882
- ZK_NODES_LIST - List of Zookeeper nodes divided by commas or spaces. Can contain list of NiFi nodes or external Zookeeper nodes. If empty, cluster will not work (see above "Zero master clustering paradigm")
- ZK_CLIENT_PORT - Port for Zookeeper client. If empty, following value will be used: 2181
- ZK_MYID - ID of embedded Zookeper node and switching on embedded Zookeper starting when NiFi starts. If empty, embedded Zookeper will not start with NiFi
- ZK_MONITOR_PORT - Port for Zookeeper monitoring of NiFi nodes' availability. If empty, following value will be used: 2888
- ZK_ELECTION_PORT - Port for Zookeeper election of NiFi Cluster Coordinator node. If empty, following value will be used: 3888


# Docker compose reference

To get all official information about docker compose please go to [Docker documentation](http://docs.docker.com/compose/).


# Single-Host cluster

NiFi Cluster within one docker-machine. Can be runned and observed from Kitematic.
To be able to play with all of below options you should increase amount of memory for your Docker VM  at least up to 2GB.

## Preliminary steps

- Pull image from DockerHub `docker pull xemuliam/nifi`
- Download zipped [nifi-cluster](http://minhaskamal.github.io/DownGit/#/home?url=http://github.com/xemuliam/docker-nifi/tree/1.x/nifi-cluster) folder and store it in place accessible from docker-machine 
- Unpack content from downloaded zip
- Run docker client
- Go to directory with extracted YML-files
- Ensure your copy of docker image is up to date by pulling image again. If smth. has been changed in image since last pull, latest image version willl be downloaded

## Minimal cluster

Contents:
- One NiFi node with embedded Zookeeper
- One NiFi node with ability to scale up and down

How to play:
- Start cluster `docker-compose -f docker-compose.minimal.yml up -d`
- Check containers from Kitematic or by command `docker-compose -f docker-compose.minimal.yml ps`
- Scale up `node` service `docker-compose -f docker-compose.minimal.yml scale node=2`
- Scale down `node` service `docker-compose -f docker-compose.minimal.yml scale node=1`
- Check containers from Kitematic or by command `docker-compose -f docker-compose.minimal.yml ps`
- Stop specific containers through Kitematic or all containers by command `docker-compose -f docker-compose.minimal.yml stop`
- Run specific containers through Kitematic or all containers by command `docker-compose -f docker-compose.minimal.yml up -d`
- To remove all docker stuff related to YML file (such as networks, containers and data from them) run `docker-compose -f docker-compose.minimal.yml down`


## Basic cluster

Contents:
- Three NiFi node with embedded Zookeeper
This option can be extended by addition of scalable NiFi node (like `node` service from previous option)

You can play with this options in very similar way as playing with previous. Please use `docker-compose.basic.yml` in your commands.

Only one exception is unavailability of scaling nodes with Zookeeper.

As additional playing procedure you can inspect YML file more tightly to learn how to work with image parameters. Also please pay attention on ZK_NODES_LIST declaration on different nodes.

And certainly you can add scaling capabilities to this option by addition next section in YML-file:
```
  node:
    image: xemuliam/nifi
    ports:
      - 8080
    environment:
      IS_CLUSTER_NODE: 1
      ZK_NODES_LIST: 'node1,node-2,node_3'
```
After that scaling capability will be available for `node` service.


## Advanced cluster

Contents:
- Three Zookeeper nodes
- One NiFi node with ability to scale up and down

Use `docker-compose.advanced.yml` in your commands. Then play as with "Basic" option.


# Multi-Host cluster

This option is very similar to "Single-host Basic", however each NiFi node will be created on separate docker-machine inside docker overlay network.

## Docker Networking

Creating an overlay network in advance is **no longer required**.

Additional information about Docker overlay networking is [here](https://docs.docker.com/engine/userguide/networking/get-started-overlay/).

## Automated Environment bootstrap

Go to directory with YML-files.
Run the `create_vms.sh` in the root folder to create required set of virtual machines.


## Attaching console session to swarm master
`eval $(docker-machine env --swarm host1)`


## Pull images on every host
To ensure smooth operations of `docker-compose` it is recommended to cache a container image on every node:

`docker-compose -f docker-compose.multi.yml pull`


## Start the containers
`docker-compose -f docker-compose.multi.yml up` for forground (interactive) mode

or

`docker-compose -f docker-compose.multi.yml up -d` for background (detached) mode


## Where's my UI?
If you are running `docker-compose` in a foreground, open a new terminal and execute these commands:
```
$> eval $(docker-machine env --swarm host1)
$> docker-compose -f docker-compose.multi.yml ps
```
Now you can see all containers with status and bind ports. Use ip and port in your web-browser.
