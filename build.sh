#!/bin/bash

#docker pull debian:stable
docker build -t msf .
docker image prune -f