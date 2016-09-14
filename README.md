# docker-nifi ![](https://images.microbadger.com/badges/version/xemuliam/docker-nifi.svg) ![](https://images.microbadger.com/badges/image/xemuliam/docker-nifi.svg)
Docker image for Apache NiFi 0.7.0 based on CentOs 7 and OpenJDK 8

                      ##          .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\____/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~~ /  ===- ~~~
           \______ o   NiFi     __/
             \    \   0.7.0  __/
              \____\________/

# Overview

Dockerized single- and multi-host NiFi.
No SSL!

Deployment options:
- Standalone NiFi node (by default built directly from image)
- Multi-host NiFi cluster which contains NiFi Cluster Manager (NCM) node and NiFi Worker node built on different Docker network hosts
- NiFi worker nodes can be scaled up and down via a standard `docker-compose scale worker=N` command, e.g. `worker=2` after standard multi-host deployment will create second worker node on different Docker network host (if available) and connct this new node to existing NiFi cluster.

# Docker Networking
Creating an overlay network in advance is **no longer required**.

Additional information about Docker overlay networking: https://github.com/docker/docker/blob/master/docs/userguide/networking/get-started-overlay.md

# Ports
- 11111 - site to site communication port
- 22222 - cluster namager/unicast protocol port
- 33333 - cluster node protocol port
- 9999 - NiFi web application port

# Exposed ports
- 8080 - web http port
- 8081 - port for web-based processors
- 10000 - additional port for external applications

# Pre-Requisites
Ensure the following pre-requisites are met (due to some blocker bugs in earlier versions). As of today, the latest Docker Toolbox and Homebrew are fine.

# Pre-Requisites
- Docker 1.10+
- Docker Compose 1.6.1+
- Docker Machine 0.6.0+
- Docker Swarm 1.1+

(all downloadable as a single Docker Toolbox package as well)

# Automated Environment bootstrap
Go to your checkout directory.
Run the `create_vms.sh` in the root folder to create required set of virtual machines.

# Attaching console session to swarm master
`eval $(docker-machine env --swarm host1)`

# Pull images on every host
To ensure smooth operations of `docker-compose` it is recommended to cache a container image on every node:
`docker-compose pull`

# Start the containers
`docker-compose up` for forground (interactive) mode
or
`docker-compose up -d` for background (detached) mode

# Where's my UI?
If you are running `docker-compose` in a foreground, open a new terminal and execute these commands:
```
$> eval $(docker-machine env --swarm host1)`
$> docker-compose ps
```
Now you can see all containers with status and bind ports.

# Flex the Cluster
Change the number of processing nodes in a cluster (`worker` is the worker node service name from our `docker-compose.yml`):
`♨ >  docker-compose scale worker=2
♨> docker-compose ps`
Now go to the NCM host and click on the `Cluster` menu item on the right. New nodes will appear shortly after registering with the
manager.
