#!/bin/bash

create_host() {
  splash "Creating a node: $1"
  docker-machine create \
                -d virtualbox \
                    --virtualbox-memory 2048 \
                    --virtualbox-cpu-count 2 \
                    --virtualbox-disk-size 10240 \
                --swarm \
                --swarm-discovery="consul://$(docker-machine ip keystore):8500" \
                --engine-opt="cluster-store=consul://$(docker-machine ip keystore):8500" \
                --engine-opt="cluster-advertise=eth1:2376" \
                $1
}

splash() {
  echo -e "\n\n"
  echo "*************************************************"
  echo "   $1"
  echo "*************************************************"
}

splash "Creating a Keystore instance"
docker-machine create \
                -d virtualbox \
                --virtualbox-memory 512 \
                --virtualbox-cpu-count 1 \
                --virtualbox-disk-size 512 \
                keystore


splash "Starting a Consul store"
docker $(docker-machine config keystore) run -d \
          -p 8500:8500 \
          -h consul \
          --name consul \
          progrium/consul -server -bootstrap

splash "Creating a Swarm Master instance"
docker-machine create \
               -d virtualbox \
                   --virtualbox-memory 2048 \
                   --virtualbox-cpu-count 2 \
                   --virtualbox-disk-size 10240 \
               --swarm \
               --swarm-master \
               --swarm-discovery="consul://$(docker-machine ip keystore):8500" \
               --engine-opt="cluster-store=consul://$(docker-machine ip keystore):8500" \
               --engine-opt="cluster-advertise=eth1:2376" \
               host1

create_host host2
create_host host3
create_host host4

splash "Configuring for Swarm"
eval $(docker-machine env --swarm host1)

# we are creating a default overlay network in docker-compose.yml now
# splash "Creating overlay networks"
# docker network create -d overlay nifi
# docker network create -d overlay nifi-cluster

splash "Done"
echo 'Now run: eval $(docker-machine env --swarm host1)'
