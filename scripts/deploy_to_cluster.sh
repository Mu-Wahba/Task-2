#!/bin/bash
#We assumed here that we set our swarm managers and workers by executing the following command on the manager
#docker swarm init , the command will generate token to run on workers

#search for the service name first
srv_name=$(docker service ls --filter name=java_srv --quiet | wc -l)
if [[ "$srv_name" -eq 0 ]]
then
#if it exists, remove it to recreate a new one 
 docker network rm java_srv || true
 docker network create --driver overlay --attachable java_ntw
#You can define no of replicas to run on you cluster.
 docker service create --replicas $1 --network java_ntw --name java_srv  ${DOCKER_USER}/my-app:${BUILD_NUMBER}
else
#Update the service if it already exists
 docker service update  --update-parallelism 2 --update-delay 40s --image ${DOCKER_USER}/my-app:${BUILD_NUMBER} java_srv
fi
         
