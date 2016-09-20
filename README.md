# docker-nifi ![](https://images.microbadger.com/badges/version/xemuliam/docker-nifi:1.0.0.svg) ![](https://images.microbadger.com/badges/image/xemuliam/docker-nifi:1.0.0.svg)
Docker image for Apache NiFi based on CentOs and OpenJDK


                      ##           .
                  ## ## ##         ==
               ## ## ## ## ##     ===
           /"""""""""""""""""\____/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~~ /  ===- ~~~
           \______ o   NiFi     __/
             \    \   1.0.0  __/
              \____\________/


# Overview

Dockerized single- and multi-host NiFi.
No SSL! No scaling!

Deployment options:
- Standalone NiFi node (by default built directly from image)
- Multi-host NiFi cluster which contains three NiFi nodes on different Docker network hosts


# Migration from 0.7.0

All required information acn be found here:
http://cwiki.apache.org/confluence/display/NIFI/Migration+Guidance


# Known issues

Web-interfface is working only on NiFi Cluster primary node. You should pick up from logs information about proper node or just try to enter on each of three cluster nodes.

Web http host value is empty or 0.0.0.0. So only "localhost" or "0.0.0.0" addreesses are visible for all cluster nodes in NiFi Cluster information. Assigning any value for web http host property makes web-interface inaccessible. 

Unable to flex cluster by using `docker-compose scale` command. Implementation of Zero Cluster Management startegy requires information about all cluster nodes before starting the cluster.


# Docker Networking
Creating an overlay network in advance is **no longer required**.

Additional information about Docker overlay networking: https://github.com/docker/docker/blob/master/docs/userguide/networking/get-started-overlay.md


# Ports
- 11111 - site to site communication port
- 33333 - cluster node protocol port
- 9999 - NiFi web application port


# Exposed ports
- 8080 - web http port
- 8081 - port for web-based processors
- 10000 - additional port for external applications

== Official Apache NiFi Documentation and Guides

- https://nifi.apache.org/docs.html[Overview]
- https://nifi.apache.org/docs/nifi-docs/html/user-guide.html[User Guide]
- https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html[Expression Language]
- https://nifi.apache.org/quickstart.html[Development Quickstart]
- https://nifi.apache.org/developer-guide.html[Developer's Guide]
- https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html[System Administrator]


# ListenHTTP Processor

The standard library has a built-in processor for an HTTP endpoint listener. That processor is named ![ListenHTTP]https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.ListenHTTP/index.html. You should set the *Listening Port* of the instantiated processor to `8081` if you follow the instructions from above.

# Usage

This image can either be used as a base image for building on top of NiFi or just to experiment with. I personally have not attempted to use this in a production use case.


# Pre-Requisites
Ensure the following pre-requisites are met (due to some blocker bugs in earlier versions). As of today, the latest Docker Toolbox and Homebrew are fine.

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
$> eval $(docker-machine env --swarm host1)
$> docker-compose ps
```
Now you can see all containers with status and bind ports. Use ip and port in your web-browser.
