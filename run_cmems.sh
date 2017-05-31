#! /bin/bash

echo "Running compose "
docker-compose up -d postgres
echo "Going to sleep"
sleep 10
docker-compose up -d
