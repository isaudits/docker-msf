#!/bin/bash

#hooks/build
docker build -t isaudits/msf:latest .
docker image prune -f