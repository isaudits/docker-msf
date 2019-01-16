#!/bin/bash

rm -r /var/run/postgresql/*
/etc/init.d/postgresql start
msfupdate
clear
msfconsole -r /opt/msfconsole.rc $@