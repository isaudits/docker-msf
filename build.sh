#!/bin/bash

#hooks/build
#docker build -t isaudits/msf:base .
docker build -t isaudits/msf:full -t isaudits/msf:latest -f Dockerfile.full .
#docker build -t isaudits/msf:minimal -f Dockerfile.min .
docker image prune -f