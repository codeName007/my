docker
-
<br>24.0.4
<br>17.09.1
<br>1.12.5

[compose](https://docs.docker.com/compose)
[compose-file](https://docs.docker.com/compose/compose-file)
[moby](https://mobyproject.org)

````sh
ls /Users/k/Library/Group\ Containers/group.com.docker/settings.json
````

## Overview

Docker - an open platform for developing, shipping, and running applications.
It helps to separate apps from infrastructure so you can deliver software quickly
(reproducibility, isolation, security, scaling, docker hub, simple CI).
<br>
Docker used LinuX Containers (LXC), but later switched to runC (aka libcontainer),
which runs in the same operating system as its host,
this allows to share a lot of the host operating system resources.
Also, it uses a layered filesystem (AuFS) and manages networking.

Image - (template) OS configuration (FS, tools, etc.) which is used to create containers.

Container - (an instance of an image) OS Process namespace, also it's loosely isolated environment.
Containers are lightweight because they don’t need the extra load of a hypervisor,
but run directly within the host machine’s kernel.

Hypervisor (supervisor of the supervisors) - kind of emulator (software, firmware or hardware)
that creates and runs VM.

Container is not VM: VM uses hypervisor(hyperkit or virtualbox) but docker not,
VMs use a separate kernel to run the OS, In Docker containers share same kernel.
VMs - houses, docker containers - apartments.
<br>Containers should be ephemeral (can be stopped and destroyed and a new one built and put in place).
<br>Hence container must be stateless.
<br>Each container should have only one concern (1 process per container).
<br>`Ctrl + P + Q # ‼️ detach from container`.

Docker Engine - client-server app with:
* Daemon (dockerd) - it's a server.
* REST API - interfaces to daemon.
* Client - CLI `docker` command.

Docker registry - stores Docker images.

Docker objects: images, containers, networks, volumes, etc.

Docker file sharing implementation:
* VirtioFS
* gRPC FUSE (Filesystem in Userspace server running over gRPC over Hypervisor sockets)
* osxfs (Legacy)

````sh
host.docker.internal         # connect to host machine from container.
docker.for.mac.host.internal # ↑
gateway.docker.internal
````

````sh
# ddos
docker run -it --rm alpine/bombardier -c 1000 -d 3600s -l https://realtimelog.herokuapp.com/
````

````sh
# on ubuntu
sudo pkill dockerd
sudo dockerd

docker login -u $DOCKER_USER -p $DOCKER_PASSWORD

docker pull cn007b/pi

# build image from Dokerfile in dir ./examples/mydockerbuild
# -t - tag
# .  - current directory
docker build -t cn007b/pi -f Dockerfile .
# push to docker hub
docker push cn007b/pi

docker tag $srcImage $targetImage

docker build -t nphp https://raw.githubusercontent.com/cn007b/my/master/docker/php-nginx/Dockerfile?latest

# ARG ENV in Dockerfile
docker build --build-arg ENV=prod -f Dockerfile .
#
ARG DOCKER_BUILD_IMAGE="gcr.io/org-$ENV/golang:latest"
FROM $DOCKER_BUILD_IMAGE AS build

# THE BEST COMMAND
docker inspect $name

docker scout quickview $img

# shows CPU/MEM usage
docker stats $cId

# run an interactive container from an image
# -t - terminal
# -i - interactive connection
# -P - publish all exposed ports to random ports
docker run -P -t -i ubuntu:latest /bin/bash

docker run --gpus all ...

# run a web application
# -d - runs the container as daemon
# -p - maps any required network ports, $portInContainer:$portOnHostMachine
docker run -d -p 8081:80 cn007b/ubuntu
docker run -d -p 192.168.0.32:1111:1111 cn007b/ubuntu

docker run --cpus=4 ...

docker attach container_name

# exec
docker exec -it xsh
docker exec -it xsh bash
cd /opt/docker/etc/supervisor.d

docker-machine ip

# list containers (default shows just running)
# -a - show all
docker ps -a

# top
docker top CONTAINER_ID # show all containers (default shows just running)

# shows the standard output of a container
docker logs
docker logs --details # ENV variables
docker logs -f # follow

# list images
docker images
# only IDs
docker images -q

docker image rm $img

# list containers
docker container ls

docker volume ls

# stop the running container
docker stop

# stop all containers
docker stop $(docker ps -a -q)

# start stopped container (starts a container)
docker start $cId

# remove container
docker rm $cId

# remove image
docker rmi -f $cId

# layers of image
# less commands in dockerfile - least layers
docker history $img

# shows used ports
docker port $cId

````

````sh
# no space left on device
docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs docker rmi

# remove unused data
docker system prune -a
docker volume prune
docker builder prune
docker images purge
# check
du -sh $HOME/Library/Containers/com.docker.docker/Data
````

Copy container manually:
````sh
# on machine 1
docker commit {CONTEINER_ID} $imgName
docker save -o img.dump.tar $imgName

# on machine 2
docker load -i img.dump.tar
````

## Dockerfile

````
FROM        `FROM scratch`.
MAINTAINER  V.K. <cn007b@gmail.com>.
ARG         `ARG CODE_VERSION=latest`.
ENV         `ENV NODE_PORT=3000`.
ADD         `ADD ./healthCheck.js /app/healthCheck.js`, allows `<src>` to be a URL.
COPY        `COPY ./healthCheck.js /app/healthCheck.js`, same as `ADD`, but without the tar and remote URL handling.
VOLUME      Mount point with the specified name.
WORKDIR     `WORKDIR /app`.
RUN         `RUN ls - la /app/healthCheck.js`.
EXPOSE      `EXPOSE $NODE_PORT`.
CMD         Provide default (default arguments) for an executing container (ENTRYPOINT),
            `CMD ["php"]`, in Dockerfile can be only 1 CMD instruction,
            if list more than one CMD then only last CMD will take effect,
            `CMD echo "This is a test." | wc -` # execute in shell `/bin/sh -c`,
            `CMD ["/usr/bin/wc","--help"]` # run without shell (preferred).
ENTRYPOINT  Configure a container that will run as an executable,
            `ENTRYPOINT ["sh", "-c", "echo $HOME"]`
            `ENTRYPOINT service memcached start`.
            `ENTRYPOINT` will be started as a subcommand of `/bin/sh -c`, which does not pass OS signals
            command line arguments to `docker run <image>` will be appended to `ENTRYPOINT`
            `ENTRYPOINT ["/bin/sh", "-c", "curl -i -XPOST 'https://realtimelog.herokuapp.com:443/rkc8q6llprn' -H 'Content-Type: application/json' -d '{\"code\": 200, \"status\": \"ok\"}'"]`.
````

Less instructions in Dockerfile - least layers in built image.

## Compose

Compose - tool for defining and running multi-container Docker applications.

````sh
docker-compose build $serviceName
# --no-cache - do not use cache
# --force-rm - remove intermediate containers
docker-compose build --no-cache --force-rm $serviceName

# shutdown/cleanup
docker-compose down
docker-compose down --volumes --remove-orphans

# builds, (re)creates, starts, and attaches to containers for a service.
docker-compose up
docker-compose -f dkr/docker-compose.yml up
# build the project and detache container
docker-compose up -d

# runs a one-time command against a service (will start service if needed)
docker-compose run \
-T              # disable pseudo-tty allocation
--rm            # remove container after run
--service-ports # run with service's ports enabled and mapped to the host

docker-compose ps

# equivalent of `docker exec`
docker-compose exec php-cli php /gh/x.php
docker-compose exec mysql /bin/bash

# start stopped container
docker-compose start

docker-compose restart $cId

docker-compose stop
````

## docker-compose.yml

````yaml
version: '3'
services:
  webapp:
    build:
      context: ./dir
      dockerfile: Dockerfile-alternate
    image: myImg:latest
    restart: always|on-failure
````

## Network

````sh
# list these networks
docker network ls

docker network create --driver bridge x_node_mongo
docker network inspect x_node_mongo
````

## Machine

Use [machine](https://docs.docker.com/machine) to create Docker hosts on your local box,
on your company network, in your data center,
or on cloud providers like AWS or Digital Ocean.

````sh
docker-machine version

docker-machine ls

docker-machine create --driver virtualbox manager1

docker-machine ip default
docker-machine status default
docker-machine stop default
````

## Swarm

Docker [Swarm](https://docs.docker.com/swarm) is native clustering for Docker.
It turns a pool of Docker hosts into a single, virtual Docker host.

Non-finished swarm:

````sh
# init rabbit

#
# docker run -it --rm --name php-cli-rabbitmq-c -v $PWD/ed:/gh/ed --link rabbit php-cli

#
# docker-machine create --driver virtualbox manager1
# docker-machine ip manager1
# 192.168.99.100
# docker-machine ssh manager1
docker swarm init --advertise-addr 192.168.99.100
docker node ls
#
# docker service create --replicas 3 --name php-cli-rabbitmq-swarm php-cli-rabbitmq-c \
#     php /gh/ed/php/examples/rabbitmq/tutorials/workQueue/worker.php
docker service ls
# docker service ps php-cli-rabbitmq-swarm

#
# docker-machine create --driver virtualbox worker1
# docker-machine ssh worker1
docker swarm join \
    --token SWMTKN-1-3ie1vxyfmvh1756tv37dyp8datyyfcsfrnkhmzofwk3nsle7ud-cblwlb51iv251evjiudwxs6li \
    192.168.99.100:2377
docker node ls
````
