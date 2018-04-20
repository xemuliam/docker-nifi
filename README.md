![nifi-logo](https://s15.postimg.org/sfsfqg45n/nifi_logo_uni_500.png)

# NiFi

Since version 1.5.0 you can use [NiFi Registry](https://hub.docker.com/r/xemuliam/nifi-registry/) service to maintain flow versions.

## 1.x
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.6.0.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.6.0.svg) __1.6.0 = 1.6 = latest__
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.5.0.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.5.0.svg) __1.5.0 = 1.5 = latest__
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.4.0.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.4.0.svg) __1.4.0 = 1.4__
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.3.0.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.3.0.svg) __1.3.0 = 1.3__
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.2.0.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.2.0.svg) __1.2.0 = 1.2__
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.1.2.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.1.2.svg) __1.1.2 = 1.1__
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.1.1.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.1.1.svg)
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.1.0.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.1.0.svg)
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.0.1.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.0.1.svg) __1.0.1 = 1.0__
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:1.0.0.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:1.0.0.svg)


## 0.x
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:0.7.4.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:0.7.4.svg) __0.7.4 = 0.7__
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:0.7.3.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:0.7.3.svg)
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:0.7.2.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:0.7.2.svg)
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:0.7.1.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:0.7.1.svg)
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:0.7.0.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:0.7.0.svg)
- ![Version](https://images.microbadger.com/badges/version/xemuliam/nifi:0.6.1.svg) ![Layers](https://images.microbadger.com/badges/image/xemuliam/nifi:0.6.1.svg)  __0.6.1 = 0.6__


[Docker](https://www.docker.com/what-docker) image for [Apache NiFi](https://nifi.apache.org/).

- ![Docker builds](https://img.shields.io/docker/automated/xemuliam/nifi.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/xemuliam/nifi.svg) ![Docker Stars](https://img.shields.io/docker/stars/xemuliam/nifi.svg)
 
Created from NiFi [base image](https://hub.docker.com/r/xemuliam/nifi-base) to minimize traffic and deployment time in case of changes should be applied on top of NiFi


## Why base image is required?

DockerHub does not cache image layers while compilation. Thus creation of base image (with pure NiFi) mitigates this issue and let us to experiment/play with NiFi settings w/o downloading full NiFi archive (more than 800MB) each time when we change smth. in configuration (or libs, add-ons, etc.) and recompile docker image. Only our changes will be pulled out from Docker Hub instead of full image.

```
 ______
< NiFi >
 ------
    \
     \
      \
                    ##        .
              ## ## ##       ==
           ## ## ## ##      ===
       /""""""""""""""""___/ ===
  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
       \______ o          __/
        \    \        __/
          \____\______/
```

*__Please use corresponding branches from this repo to play with code.__*

# Overview

&#x1F535; Dockerized and parametrized single- and multi-host NiFi.  
&#x1F535; Site-to-site communication is switched on.  
&#x1F535; Scalability is supported.  
&#x1F534; SSL implementation sholud be the next step.


Deployment options:
- Standalone NiFi node (by default built directly from image)
- Single-host NiFi cluster (within sigle docker-machine) 
- Multi-host NiFi cluster (within several physical hosts and/or several docker-machines)


## Migration from 0.x version

All required information can be found [here](http://cwiki.apache.org/confluence/display/NIFI/Migration+Guidance)


## Used ports (all of them are configurable)

- 2883 - **_0.x only_** NiFi Cluster Manager/unicast manager protocol port
- 2881 - NiFi site to site communication port
- 2882 - NiFi cluster node protocol port
- 2181 - Zookeeper client port
- 2888 - Zookeeper port for monitoring NiFi nodes availability
- 3888 - Zookeeper port for NiFi Cluster Coordinator election


## Exposed ports

- 8080 - NiFi web application port
- 8443 - NiFi web application secure port
- 8081 - NiFi ListenHTTP processor port

## !!! Important note !!!

In version 1.5.0 "http request header check" has been implemented on NiFi side. Thus it breaches native Docker functionality with automatic ports assignment. At the moment NiFi web http port and docker port should be equal.

So you can use dockerized NiFi 1.5 in two ways:

1. Use static Docker port (8080) which equal to default NiFi web http port
```
docker run -d -p 8080:8080 xemuliam/nifi
```

2. Use NIFI_WEB_HTTP_PORT environment variable with value which is equal to Docker port
(mentioned environment variable let NiFi to be ran at specified web http port): 
```
docker run -d -p 9999:9999 -e NIFI_WEB_HTTP_PORT=9999 xemuliam/nifi
``` 

## Volumes

All below volumes can be mounted to docker host machine folders or shared folders to easy maintain data inside them. 

NiFi-specific:
- /opt/nifi/logs
- /opt/nifi/flowfile_repository
- /opt/nifi/database_repository
- /opt/nifi/content_repository
- /opt/nifi/provenance_repository

User-specific:
- /opt/datafiles
- /opt/scriptfiles
- /opt/certfiles


## Additional environment properties

To add more flexibility in configuration there are some environment variables have been added to the image.  

- BANNER_TEXT - NiFi instance banner text to be able to easily recognize instance from first look on UI
- S2S_PORT - NiFi Site-to-site communication port. If empty, following value will be used: 2881


## Official Apache NiFi Documentation and Guides

- [Wiki](https://cwiki.apache.org/confluence/display/NIFI/Apache+NiFi)
- [Overview](https://nifi.apache.org/docs.html)
- [User Guide](https://nifi.apache.org/docs/nifi-docs/html/user-guide.html)
- [Expression Language](https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html)
- [Development Quickstart](https://nifi.apache.org/quickstart.html)
- [Developer's Guide](https://nifi.apache.org/developer-guide.html)
- [System Administrator](https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html)


## ListenHTTP Processor

The standard library has a built-in processor for an HTTP endpoint listener. That processor is named [ListenHTTP](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.ListenHTTP/index.html). You should set the *Listening Port* of the instantiated processor to `8081` if you follow the instructions from above.


# Usage

This image can either be used as a image for building on top of NiFi or just to experiment with. I personally have not attempted to use this in a production use case.


## Pre-Requisites
Ensure the following pre-requisites are met (due to some blocker bugs in earlier versions). As of today, the latest Docker Toolbox and Homebrew are fine.

- Docker 1.10+
- Docker Compose 1.6.1+
- Docker Machine 0.6.0+

(all downloadable as a single [Docker Toolbox](https://www.docker.com/products/docker-toolbox) package as well)


## How to use from Kitematic

1. Start Kitematic
2. Enter `xemuliam` in serach box
3. Choose `nifi` image
4. Click `Create` button

Kitematic will assign all ports and you'll be able to run NiFi web-interface directly from Kitematic.


## How to use from Docker CLI

1. Start Docker Quickstart Terminal
2. Run command  `docker run -d -p 8080:8080 -p 8081:8081 -p 8443:8443 xemuliam/nifi`
3. Check Docker machine IP  `docker-machine ls`
4. Use IP from previous step in address bar of your favorite browser, e.g. `http://192.168.99.100:8080/nifi`


## How to use NiFi in cluster mode

Please read [explanation](https://github.com/xemuliam/docker-nifi/blob/main/README.Cluster.md).


# Enjoy! :)
