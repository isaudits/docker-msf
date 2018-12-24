#!/bin/bash

#docker pull debian:stable
docker build -t isaudits/msf .
docker image prune -f