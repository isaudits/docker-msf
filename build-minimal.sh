#!/bin/bash

#docker pull debian:stable
docker build -t isaudits/msf-minimal -f Dockerfile-min . 
docker image prune -f