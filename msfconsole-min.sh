#!/bin/bash

rm -r /var/run/postgresql/*
/etc/init.d/postgresql start
msfconsole -r /opt/msfconsole.rc