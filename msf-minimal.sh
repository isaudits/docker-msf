#!/bin/bash

# If command arguments are passed, run command as-is;
# otherwise, auto-run msfconsole
if [ "$#" -ne 0 ]; then
    COMMAND=$@
else
    COMMAND="sh /opt/msfconsole-min.sh"
fi

if [[ $(uname -s) == Linux ]]
then
    HOST_IP=$(ifconfig eth0 | awk '/ *inet /{print $2}')
    echo "detected host ip: $HOST_IP"
    docker run -it --rm \
    --net=host \
    -e MSF_LHOST=$HOST_IP \
    -v $HOME/.msf4:/root/.msf4 \
    -v msf_pg_data:/var/lib/postgresql/13/main \
    isaudits/msf:minimal $COMMAND
else
    HOST_IP=$(ifconfig en0 | awk '/ *inet /{print $2}')
    echo "detected host ip: $HOST_IP"
    docker run -it --rm \
    -p 80:80 -p 443:443 -p 4443:4443 -p 4444:4444 -p 8080:8080 -p 8443:8443 -p 55553:55553 \
    -e MSF_LHOST=$HOST_IP \
    -v $HOME/.msf4:/root/.msf4 \
    -v msf_pg_data:/var/lib/postgresql/13/main \
    isaudits/msf:minimal $COMMAND
fi

