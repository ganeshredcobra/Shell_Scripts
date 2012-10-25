#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
#       mysql_restore.sh
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
BAK="./db.txt"
BZIP="$(which bzip2)"

NOW=$(date +"%d-%m-%Y")
 
### See comments below ###
### [ ! -d $BAK ] && mkdir -p $BAK || /bin/rm -f $BAK/* ###
[ -f "$BAK" ] && rm "$BAK"

if [ "$OPT" = "y" ] 
then
	for i in `ls *.bz2`
	do
		echo $i|cut -d. -f1 >> db.txt
	done
	for db in $(cat db.txt);
	do
 		$MYSQL -u $MUSER -h $MHOST -p$MPASS -e "create database $db;"
	done
	for db in $(cat db.txt);
	do
		$BZIP -cd $db*.bz2|$MYSQL -u $MUSER -h $MHOST -p$MPASS $db
	done
else
	read -p "Enter the database name : " db
	$MYSQL -u $MUSER -h $MHOST -p$MPASS -e "create database $db;"
	$BZIP -cd $db*.bz2|$MYSQL -u $MUSER -h $MHOST -p$MPASS $db	
fi
 

 

