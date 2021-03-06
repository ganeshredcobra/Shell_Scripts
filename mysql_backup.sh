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
read -p "Do you want back up all databases [y/n] :" OPT
#echo $OPT
read -p "Enter the database username :" MUSER
read -p "Enter the database password :" MPASS
MHOST="localhost"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
BAK="./backup/mysql"
BZIP="$(which bzip2)"

NOW=$(date +"%d-%m-%Y")
 
### See comments below ###
### [ ! -d $BAK ] && mkdir -p $BAK || /bin/rm -f $BAK/* ###
[ ! -d "$BAK" ] && mkdir -p "$BAK"

if [ "$OPT" = "y" ] 
then
	DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
	for db in $DBS
	do
 		FILE=$BAK/$db.$NOW-$(date +"%T").bz2
 		$MYSQLDUMP --single-transaction -u $MUSER -h $MHOST -p$MPASS $db | $BZIP -z1 > $FILE
	done
else
	read -p "Enter the database name : " DBNAME
	FILE=$BAK/$DBNAME.$NOW-$(date +"%T").bz2
	$MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS $DBNAME | $BZIP -z1 > $FILE
	
fi
 

 

