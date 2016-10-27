
## MultiHost cluster

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
