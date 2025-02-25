FROM debian:stable

ENV LC_ALL C.UTF-8
ENV STAGING_KEY=RANDOM
ENV DEBIAN_FRONTEND noninteractive

ARG BUILD_DATE
ARG VCS_REF
ARG MSF_VERSION

# Apt packages to install
ENV PACKAGES "apt-utils \
        curl \
        wget \
        gnupg2 \
        git-core \
        postgresql \
        postgresql-contrib \
        nmap"

RUN apt-get -y update && \
    apt-get install -y $PACKAGES && \
    echo 'deb http://apt.metasploit.com/ lucid main' > /etc/apt/sources.list.d/metasploit-framework.list && \
    wget -O - http://apt.metasploit.com/metasploit-framework.gpg.key | apt-key add - && \
    apt-get update && \
    apt-get -y install metasploit-framework && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV MSF_RPC_USER='admin' \
    MSF_RPC_PASS='changeyourpassword' \
    MSF_RPC_PORT='55553' \
    MSF_DB='msf' \
    MSF_DB_HOST='127.0.0.1' \
    MSF_DB_PORT='5432' \
    MSF_DB_USER='msf' \
    MSF_DB_PASS='msfdb' \
    MSF_LHOST='0.0.0.0' \
    MSF_LPORT='8443'

# Configure postgres
RUN /etc/init.d/postgresql start && \
    su postgres -c 'echo -e "$MSF_DB_PASS\n$MSF_DB_PASS" | createuser -SRPD $MSF_DB_USER' && \
    su postgres -c 'createdb -O $MSF_DB_USER $MSF_DB'

ADD scripts/ /opt/

WORKDIR /opt/metasploit/

CMD ["/bin/bash"]

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/isaudits/docker-msf" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version=$MSF_VERSION

