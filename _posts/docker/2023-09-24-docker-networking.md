---
layout: post
title:  "Docker Networking"
author: commando
categories: [ Docker, Networking ]
# image: assets/images/docker-networking.jpeg
featured: false
---

**What is Docker Networking?**  
Docker containers communicate within the host and outside of the host world via the host machine, there has to be a layer of networking involved.  Docker networking is one of the core functionality in the docker era. It allows and define which container can talk to which and which are all container can be combine together. This is a pluggable subsystem using drivers.

Types of Docker networking
- bridge
- host
- none
- Overlays
<!-- - ipvlan -->
<!-- - macvlan -->


In this page, I am going to discuss about each networking options one-by-one.

Let's start 

## bridge
Bridge network is the Link layer device which forwards all the traffic between network segments. Docker uses a software based bridge networking device.

Bridge networking allows container to communicate with each other which are connected to the same bridge network. This also isolate these containers from outside which are not connected to the same bridge network.

Here, the idea is if we want to group together some containers and do not want them to be accesses by others' container on the same host then we can spin up all these containers under a bridge network.

We can create multiple bridge network, so container belongs to network bridge-A will not be able to those connected to network bridge-B.

This is de-facto default network type. When we do not provide any network by `--network` flags during `docker run` command, then docker by default create the container in `bridge` host.

`docker run --rm -d --network bridge --name my_nginx nginx`

Bridge network apply to those containers running on **same** docker host machine.

**Check the networks**  
`docker network ls`

Output
```shell
$ docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
21fdfd7ad08c   bridge    bridge    local
fb231c81ea6a   host      host      local
e7861043a1f3   none      null      local
```

By default, docker comes up with default bridge network.If we want we can create user define bridge network as well.

Difference between default and user define bridge network
- **Communication**  
Container within default bridge network can communicate to each other using IP Address on the other hand in case of user define bridge network they can communicate using containers name.
Imagine an application with a web front-end and a database back-end. If you call your containers web and db, the web container can connect to the db container at db, no matter which Docker host the application stack is running on.

- **Better Isolation**  
By default, when we spin a new container they all connect to a default one, where we might be creating all other containers hence does not provide better isolation. But you'll get the better isolation in case of user define bridge network.

- **Better Control**  
We cannot control or change anything in default bridge network as it is outside of control of docker and also require restart of docker itself. But on the other hand we get better control on user define one and we can also attach/detach containers on the fly without even restarting the docker.

## host
Host networking is the link layer between the docker container's host and the docker host itself, meaning it is a link between the containers and the host machine. If there is a service running on host machine and you want to access that from your docker container then you will have to connect your docker container to the host network. Once done you can access the service via `localhost` or `127.0.0.1`.

`docker run --rm -d --network host --name my_nginx nginx`

## None
The third type is the none network. In this type of network docker container do not attach to any network and will not have access to ant containers inside the docker host and or any other service running on host.

`docker run --rm -d --network none --name my_nginx nginx`

## Overlays  
This is a special type of network which create an extra additional layer on the top of physical network layer. Using this type of networking we can connect the multiple docker host, or may be multiple cloud as well.

To create an overlay network named my-overlay-net, you’ll also need the `--subnet` parameter to specify the network block that Docker will use to assign IP addresses to the containers:

`docker network create -d overlay --subnet=172.70.10.1/24 my-overlay-net`

**Common Operations**
- Create a new network
`docker create network`

- Remove a network
`docker network rm`

- List all networks
`docker network ls`

- Run a container in a network
`docker run -it -d <Image-ID> --network <network-name>`

- Inspect a network
`docker network inspect <network-name>`

- Disconnect a container from a network: 
`docker network disconnect`.