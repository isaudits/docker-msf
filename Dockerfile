# Idea from https://github.com/watersalesman/docker-images/tree/master/debian-metasploit
# Basically the same thing but compressed the Metasploit layer and added some cleanup to reduce size
# Build size ~ 1.25 GB
# Note - once we automate build consider deleting .git folder to further reduce size
# This will probably break msfupdate capability?

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
        git-core \
        nmap \
        libxml2 \
        openssl \
        postgresql \
        postgresql-contrib \
        ruby \
        wget \
        zlib1g"

# Metasploit packages to install and remove at end of minimal build
ENV PACKAGES_MSF "autoconf \
        bison \
        build-essential \
        libapr1 \
        libaprutil1 \
        libcurl4-openssl-dev \
        libgmp3-dev \
        libpcap-dev \
        libpq-dev \
        libreadline6-dev \
        libsqlite3-dev \
        libssl-dev \
        libsvn1 \
        libtool \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        locate \
        ncurses-dev \
        ruby-dev \
        xsel \
        zlib1g-dev"

RUN apt-get -y update && \
    apt-get install -y $PACKAGES && \
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
      org.label-schema.vcs-url="https://github.com/isaudits/msf" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version=$MSF_VERSION

