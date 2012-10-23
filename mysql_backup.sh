#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
#       mysql_backup.sh
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
### MySQL Server Login Info ###
MUSER="root"
MPASS="space123"
MHOST="localhost"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
BAK="./backup/mysql"
GZIP="$(which gzip)"

NOW=$(date +"%d-%m-%Y")
 
### See comments below ###
### [ ! -d $BAK ] && mkdir -p $BAK || /bin/rm -f $BAK/* ###
[ ! -d "$BAK" ] && mkdir -p "$BAK"
 
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do
 FILE=$BAK/$db.$NOW-$(date +"%T").gz
 $MYSQLDUMP --single-transaction -u $MUSER -h $MHOST -p$MPASS $db | $GZIP -9 > $FILE
done
 

