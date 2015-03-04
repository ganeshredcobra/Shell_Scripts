#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
#       scanimage.sh
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

SCANDIR=~/Scanned_Documents/
#scanimage --device-name=$C_DEVICE --mode Gray --source=ADF -x 210 -l 0 -y 297 --resolution=$C_RESOLUTION -t 0 --batch=$C_SCANDIR/%d$1 --format=pnm | tee >(zenity --progress --title "$S_TITLE" --text "$S_SCANNING" --pulsate --auto-close)
ENTRY=$(zenity --entry --text "Please enter your name" --title "Enter your name")
scanimage| tee >(zenity --progress --title "TITLE" --text "SCANNING" --pulsate --auto-close) > $SCANDIR/$ENTRY.pnm
cd $SCANDIR
convert $ENTRY.pnm $ENTRY.jpg
convert $ENTRY.pnm $ENTRY.pdf
rm $ENTRY.pnm 
usb_modeswitch -R -v 04a9 -p 2759| tee >(zenity --progress  --text "Resetting" --pulsate --auto-close)
