# docker-msf

Docker implementation of Metasploit framework based upon Debian stable image


## Description

Yeah, we know it's bigger than the official https://github.com/rapid7/metasploit-framework version, but:
* Debian stable as opposed to Alpine for use as a base image for other debian-based tools (think Veil)
* Smaller in size than Kali image with MSF installed
* Has functional Postgres instance installed inline without having to use a linked Postgres image instance
* Uses environment variables to configure defaults

This image has 2 build options with separate Dockerfiles:
* msf - main image (larger in size: ~1.5 GB); use for standalone MSF instances. .git repo and dependencies are left
intact so msfupdate will work. Also has Nmap installed
* msf-minimal - stripped down image (reduced size: ~800 MB); use for image base for other images. .git repo and
unnecessary dependencies are removed after install. msfupdate does not work in the minimal install so you
have to rebuild or re-pull to get framework updates.


## Build Notes
main image:

    docker build -t msf .
    
or

    ./build.sh
    
minimal image:

    docker build -t msf-minimal -f Dockerfile-min .
    
or

    ./build-minimal.sh
    

## Usage
Provided launcher scripts will automatically launch msfconsole with database support based
on environment variables. If any additional arguments are passed to the script, those will
be interpreted as opposed to launching msfconsole.

msfconsole with database support:

    # full version
    ./msf.sh
    
    # minimal version
    ./msf-minimal.sh

msfvenom:

    # full version
    ./msf.sh msfvenom
    
    # minimal version
    ./msf-minimal.sh msfvenom


--------------------------------------------------------------------------------

Copyright 2018

Matthew C. Jones, CPA, CISA, OSCP, CCFE

IS Audits & Consulting, LLC - <http://www.isaudits.com/>

TJS Deemer Dana LLP - <http://www.tjsdd.com/>

--------------------------------------------------------------------------------

Except as otherwise specified:

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.