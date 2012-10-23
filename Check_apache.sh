#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
#       Check_apache.sh
#       
#       Copyright 2012 Ganesh <ganeshredcobra@gmail.com>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.


# RHEL / CentOS / Fedora Linux restart command
#RESTART="/sbin/service httpd restart"
 
# uncomment if you are using Debian / Ubuntu Linux
RESTART="/etc/init.d/apache2 restart"
 
#path to pgrep command
PGREP="/usr/bin/pgrep"
 
# Httpd daemon name,
# Under RHEL/CentOS/Fedora it is httpd
# Under Fedora it is httpd
HTTPD="apache2"
 
# find httpd pid
$PGREP ${HTTPD}
 
if [ $? -ne 0 ] # if apache not running
then
 # restart apache
 $RESTART
fi
