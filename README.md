# docker-msf
[![](https://images.microbadger.com/badges/image/isaudits/msf.svg)](https://microbadger.com/images/isaudits/msf)
[![](https://images.microbadger.com/badges/version/isaudits/msf:full.svg)](https://microbadger.com/images/isaudits/msf:full)
[![](https://images.microbadger.com/badges/version/isaudits/msf:latest.svg)](https://microbadger.com/images/isaudits/msf)

[![](https://images.microbadger.com/badges/image/isaudits/msf:minimal.svg)](https://microbadger.com/images/isaudits/msf:minimal)
[![](https://images.microbadger.com/badges/version/isaudits/msf:minimal.svg)](https://microbadger.com/images/isaudits/msf:minimal)

Docker implementation of Metasploit framework based upon Debian stable image

## Description

Yeah, we know it's bigger than the official https://github.com/rapid7/metasploit-framework version, but:
* Debian stable as opposed to Alpine for use as a base image for other debian-based tools (think Veil)
* Smaller in size than Kali image with MSF installed
* Has functional Postgres instance installed inline without having to use a linked Postgres image instance
* Uses environment variables to configure defaults
* Includes nmap

This image has 2 build tags with separate Dockerfiles:
* full / latest - main image (larger in size: ~1.6 GB); use for standalone MSF instances. .git repo and dependencies are left
intact so msfupdate will work. 
* minimal - stripped down image (reduced size: ~900 MB); use for image base for other images. .git repo and
unnecessary dependencies are removed after install. msfupdate does not work in the minimal install so you
have to rebuild or re-pull to get framework updates.

If you are viewing this on docker hub, clone the full repo at https://github.com/isaudits/docker-msf
to get the launcher scripts and alias files described below.

To see how the minimal version is used as a base image for other docker images, check out
https://github.com/isaudits/docker-veil

## Build Notes

build images locally (this will build both versions; if you only need one, you can just pull that):

    git clone https://github.com/isaudits/docker-msf
    ./build.sh
    
pull main image only:

    docker pull isaudits/msf
    
pull minimal image only:

    docker pull isaudits/msf:minimal
    

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

### Aliases
Or, alias the commands in aliases to your .bash_aliases (kali) or .bash_profile (osx) and launch with aliases
    source /path/to/docker-msf/aliases
    
Commands on the host machine will look like:

    # basic msfconsole
    msfconsole
    
    # add some options
    msfconsole <options>
    
    # launch msfconsole with automatic windows reverse_https listener and msgrpc listener:
    msflisten
    
    # generate some shellcode
    msfvenom <options>

Refer to aliases file to see all the available commands
    
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