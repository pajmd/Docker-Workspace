## Docker 

```
Install
see https://phoenixnap.com/kb/how-to-install-docker-on-ubuntu-18-04 or https://docs.docker.com/install/linux/docker-ee/ubuntu/
```

```
Test
$ sudo docker run hello-world
```

* To run docker without sudo: 
  * create a docker group: sudo groupadd docker
  * add user to group: sudo usermod -aG docker $USER

* Commands
  * docker run hello-world
  * docker image ls
  * docker container ls --all (--all shows info even if conatiner not running)
  * docker container --help
  * docker daemon log sudo journalctl -fu docker.service

### Containers
#### Dockerfile
* Dockerfile defines what goes on in the environment inside your container. 
  * you need to map ports to the outside world, and be specific about what files you want to “copy in” to that environment.

  * To build image named using the --tag in your machine’s local Docker image registry: 

  ```
   docker build --tag=friendlyhello .
  ```
  
  * docker image ls
  * to version the TAG: --tag=friendlyhello:v0.0.1
  * Run the app, mapping your machine’s port 4000 to the container’s published port 80 using -p
  ```
  docker run -p 4000:80 friendlyhello
  ```

#### Running containers
  * running a container in interactive mode, i.e. get prompt from running container
  ```
    docker run -d -p 27017-27019:27017-27019 --name mongodb mongo:4.0.4
    docker exec -it mongodb bash

  ```

  * docker run -d -p 4000:80 friendlyhello :  -d runs container as a deamon. Internal to the container port 80 is expoted as 4000 to the machine

  * docker container ls : ps equivalent
  * docker container stop <container id>
  * debug a build:
  ```
     ---> 0fe1404b0ffa
  Step 10/16 : COPY nhs-server/ /app
  COPY failed: stat /var/lib/docker/tmp/docker-builder436911997/nhs-server: no such file or directory
  ```
  * to run a container in interactive mode and remove it when command is done
  ```
	docker run --rm -it 0fe1404b0ffa sh
  ```

  *  remove all stopped containers, all dangling images, and all unused networks:
  ```
  docker system prune
  ```
  
#### Service
  * Services are really just “containers in production.” It codifies the way that image runs—what ports it should use, how many replicas of the container should run so the service has the capacity it needs, and so on. 
  * Spec is defined in a docker-compose.yml file:
  ```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: username/repo:tag
    deploy:
    # This single service stack is running 5 container instances of our deployed image on one host.
    #  load-balancing happens with each request. One of the 5 tasks is chosen, in a round-robin fashion.
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "80:80"
    networks:
      - webnet
networks:
  webnet:
  ```
  * Commands:
    * docker swarm init: first to initialize the swarm
    * docker stack deploy -c docker-compose.yml mystack: to deploy the service (myapp is a name given to this stack/service)
    * docker service ls
    * docker service ps myapp_web (running this command after modifyinhg docker-compose.yml will automatically restart the app)
    * docker container ls -q
    * docker stack rm getstartedlab: to take down the app
    * docker swarm leave --force: to take down the swarm
    * docker service logs -f <serviceid> to see logs that are redirected to stderr/out

#### Swarms
```
A swarm is a group of machines that are running Docker and joined into a cluster. After that has happened, you continue to run the Docker commands you’re used to, but now they are executed on a cluster by a swarm manager. The machines in a swarm can be physical or virtual. After joining a swarm, they are referred to as nodes.
```
###### Prerequisite: install dodkcer-machine (well only if we wnat to create virtual machines)
  * Initialize the manager: docker swarm init
  * Ask a node to join: docker swarm join --token  ...
  * list the nodes: docker node ls

##### local registry
https://docs.docker.com/registry/deploying/
A registry is an instance of the registry image, and runs within Docker.

For using TLS SEE: https://docs.docker.com/registry/insecure/

Use a command like the following to start the registry container:
Worked fine for host pjmd-ubuntu and a /etc/docker/daemon.json (insecure). Self assigned Cert didn't do it.
Don't forget to restart docker on all hosts:
```
sudo service docker restart
```

```
$ docker run -d -p 5000:5000 --restart=always --name registry registry:2
```
  * Tag the local image with a repo on the registry: 
    * To the Docker public registry: docker tag image username/repository:tag
    * To a hosted registry: docker tag image:tag localhost:5000/new_image_name:tag
  * Publish the image 
    * to docker registry: docker push username/repository:tag
    * to local hosted reggistry: docker push localhost:5000/my-ubuntu

##### Commands using local registry
  * docker login registry.example.com:
  see https://docs.docker.com/engine/reference/commandline/login/
  and  https://docs.docker.com/registry/insecure/
  * docker stack deploy --with-registry-auth -c docker-compose.yml getstartedlab

  * to list all the repositories (i.e. images): 
  ```
  $> curl -X GET http(s)://localhost:5000/v2/_catalog
  {"repositories":["nhs-server-app"]}
  ```
  * to list all the tags for a repository: 
  ```
  curl -X GET http://localhost:5000/v2/nhs-server-app/tags/list
  {"name":"nhs-server-app","tags":["0.1"]}
  ```


##### stack command:
  * https://pauledenburg.com/deploy-docker-stack/

### DockerCompose

docker-compose is another script that makes it easy to test/run a docker-compose.yml file in a non swarm mode

* to start the set of containner (cd where the docker-compose.yml is)
```
docker-compose up -d
```
* to stop the containers
```
docker-compose down
```
* to less the logs
```
docker-compose logs --no-color | less
```
* hook in a running container
```
docker exec -it zoo1 bash (where zoo1 in the name of the container)
```


### To read

Life cycle of a container and more
https://medium.com/devopsion/life-and-death-of-a-container-146dfc62f808

