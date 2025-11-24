#!/bin/bash

rm -r /var/run/postgresql/*
rm /usr/share/keyrings/metasploit-framework.gpg
/etc/init.d/postgresql start
msfupdate
clear
msfconsole -r /opt/msfconsole.rc $@