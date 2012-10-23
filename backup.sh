#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
#       backup.sh
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

SRCDIR="/home/<username>/Documents" #Enter Source Dir
DESTDIR="/home/<username>/Backups/" #Enter Destination Dir
echo $SRCDIR | cut -c3-5
[ ! -d "$BAK" ] && mkdir -p "$DESTDIR"
FILENAME=ug-$(date +"%d-%m-%Y").tgz
#tar --create --gzip --file=$DESTDIR$FILENAME $SRCDIR
(tar cf - $SRCDIR | pv -n -s `du -sb $SRCDIR | awk '{print $1}'` | gzip -9 > $DESTDIR$FILENAME.tgz) 2>&1 | dialog --gauge 'Progress' 7 70

