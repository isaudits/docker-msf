# Idea from https://github.com/watersalesman/docker-images/tree/master/debian-metasploit
# Basically the same thing but compressed the Metasploit layer and added some cleanup to reduce size
# Build size ~ 1.25 GB
# Note - once we automate build consider deleting .git folder to further reduce size
# This will probably break msfupdate capability?

FROM debian:stable

ENV LC_ALL C.UTF-8
ENV STAGING_KEY=RANDOM
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /opt/

RUN apt-get -y update && \
    apt-get install -y \
        # keep this stuff
        apt-utils \
        curl \
        git-core \
        libxml2 \
        nmap \
        openssl \
        postgresql \
        postgresql-contrib \
        ruby \
        #tmux \
        #vim-tiny \
        wget \
        zlib1g \
        # remove this stuff after install and bundler is done?
        autoconf \
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
        zlib1g-dev && \
    # Install metasploit
    git clone --depth=1 https://github.com/rapid7/metasploit-framework /opt/metasploit && \
    gem install os bundler && \
    git config --global user.name 'msf' && git config --global user.email 'msf@example.org' && \
    cd /opt/metasploit && bundler install && ./msfupdate && \
    ln -sf /opt/metasploit/msf* /usr/bin/ && \
    apt-get remove -y -f \
        autoconf \
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
        zlib1g-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure postgres
RUN /etc/init.d/postgresql start && \
    su postgres -c 'echo -e "msfdb\nmsfdb" | createuser -SRPD msf' && \
    su postgres -c 'createdb -O msf msf'

ENV MSF_RPC_USER='admin' \
    MSF_RPC_PASS='changeyourpassword' \
    MSF_RPC_PORT='55553' \
    MSF_LHOST='0.0.0.0' \
    MSF_LPORT='8443'

ADD msfconsole.sh /opt/msfconsole.sh
ADD msfconsole.rc /opt/msfconsole.rc
ADD database.yml /opt/metasploit/config/database.yml

WORKDIR /opt/metasploit/

#CMD sh /opt/init.sh
#CMD ["./msfconsole", "-r", "docker/msfconsole.rc", "-y", "config/database.yml"]
CMD ["/bin/bash"]

