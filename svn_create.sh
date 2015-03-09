#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
#       svn_create.sh
#       
#       Copyright 2015 Ganesh <ganeshredcobra@gmail.com>
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
 
REPOS_URL=http://localhost
REPOS_PATH=/var/subversion
SCRIPTS_PATH=/home/$USER/SCRIPTS
APACHE_USER=www-data
 
SVNADMIN=`which svnadmin`
EXPECTED_ARGS=1
E_BADARGS=65
REPO=$1
TEMP_CONF=/tmp/tmp.txt
DAV_CONF=/etc/apache2/mods-available/dav_svn.conf
 
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: $0 reponame"
  exit $E_BADARGS
fi

if [ "$(id -u)" != "0" ];
then
   echo "This script must be run as root" 1>&2
   exit 1
fi

touch $TEMP_CONF
echo " " >> $TEMP_CONF
echo "<Location /$REPO>" >> $TEMP_CONF
echo "DAV svn" >> $TEMP_CONF
echo "SVNPath /var/subversion/$REPO" >> $TEMP_CONF
echo "AuthType Basic" >> $TEMP_CONF
echo "AuthName \"Subversion Repository\"" >> $TEMP_CONF
echo "AuthUserFile /etc/apache2/dav_svn.passwd" >> $TEMP_CONF
echo "Require valid-user" >> $TEMP_CONF
echo "#SSLRequireSSL" >> $TEMP_CONF
echo "</Location>" >> $TEMP_CONF

cat "$TEMP_CONF" >> $DAV_CONF
rm $TEMP_CONF
 
$SVNADMIN create --fs-type fsfs $REPOS_PATH/$REPO
 
rm -rf /tmp/subversion-layout/
mkdir -pv /tmp/subversion-layout/{trunk,branches,tags}
 
#ln -s $SCRIPTS_PATH/pre-commit $REPOS_PATH/$1/hooks/pre-commit
#ln -s $SCRIPTS_PATH/post-commit $REPOS_PATH/$1/hooks/post-commit
 
chown $APACHE_USER:$APACHE_USER -R $REPOS_PATH/$1
chmod -R 777 $REPOS_PATH/$1

service apache2 restart
 
svn import -m "Initial Import" /tmp/subversion-layout/ $REPOS_URL/$REPO
rm -rf /tmp/subversion-layout/
