#!/bin/bash

# TASK

# 1. Build a Docker image for the Node.js app located here:
#    https://gitlab.com/dan-it/groups/devops_soft/-/tree/main/Monitoring-2?ref_type=heads

# 2. Prepare a docker-compose.yml file and run the EFK stack using it.

# 3. Run the Node.js app in Docker and configure it to send logs to the EFK stack.

# 4. Make sure that you can see the logs in Kibana.


# SOLUTION NOTES

# The docker-compose.yml file includes the 'node-app' service, 
# but it may throw an error on startup.

# It is recommended to check that it runs with the correct IP address of the Fluentd container.

# Use one of the following commands to find Fluentd container IP address:

docker network inspect <your_docker_compose_default_network>
# or
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' fluentd

# Then, run the node-app container separately, using your own image name, for example:

docker run -d \
  --name src-node-app \
  --network src_default \
  --log-driver=fluentd \
  --log-opt fluentd-address=172.18.0.4:24224 \
  --log-opt tag="nodejs-app" \
  -p 3000:3000 \
  src-node-app:latest

# After that, open Kibana at http://localhost:5601 and verify logs are visible via "Discover" tab.



