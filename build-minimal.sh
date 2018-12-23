#!/bin/bash

#docker pull debian:stable
docker build -t msf-minimal -f Dockerfile-min . 
docker image prune -f