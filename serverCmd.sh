#!/bin/bash
cd nodejssample/
export IMAGE=$1
# echo "Version : $IMAGE"
sudo docker-compose -f docker-compose.yml up -d