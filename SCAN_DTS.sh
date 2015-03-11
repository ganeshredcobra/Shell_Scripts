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

i=0
START=0
SCANDIR=~/Scanned_Documents/
BOOL_MULTI=false
PDFUNITE=pdfunite

function SAV_CONV {
	cd $SCANDIR
	convert $ENTRY.pnm $ENTRY.jpg
	convert $ENTRY.pnm out.pdf
	ps2pdf -dPDFSETTINGS=/ebook out.pdf $ENTRY.pdf
	rm $ENTRY.pnm
	rm out.pdf
	usb_modeswitch -R -v 04a9 -p 2759| tee >(zenity --progress  --text "Resetting" --pulsate --auto-close)
	zenity --question --title="Question" --text="Do you want to scan again?"
	if [[ $? == 0 ]] ; then
		BOOL_MULTI=true
		PROCESS
	else
		if [ "$BOOL_MULTI" = true ] ;
		then
			zenity --question --title="Question" --text="Do you want to merge all PDF to One Page?"
			if [[ $? == 0 ]] ; then
				$PDFUNITE ${FIL_ARRAY[@]} final.pdf
				if [[ $? == 0 ]] ; then
					zenity --info --text "Merging PDF's done.Check for final.pdf."
					nautilus $SCANDIR
				else
					zenity --info --text "Merging PDF's Failed."
					nautilus $SCANDIR
				fi					
			else
				nautilus $SCANDIR
			fi	
		else		
	   		nautilus $SCANDIR
		fi
	fi	  
       }
function EXIT {
	exit
		}
function PROCESS {
	ENTRY=$(zenity --entry --text "Please enter Document name" --title "Enter name")
	if [ "$BOOL_MULTI" = true ] ;
	then
		#ENTRY_CNT={#FIL_ARRAY[@]}
		NEW_CNT=$OLD_CNT+1
		echo $NEW_CNT
		echo "${#FIL_ARRAY[@]}"
		FIL_ARRAY[$NEW_CNT]=$ENTRY.pdf 
		OLD_CNT=$NEW_CNT
		echo "${FIL_ARRAY[@]}"
	else
		FIL_ARRAY[START]=$ENTRY.pdf
		echo ${FIL_ARRAY[START]}
		OLD_CNT=$START		
	fi
	#scanimage| tee >(zenity --progress --title "TITLE" --text "SCANNING" --pulsate --auto-close) > $SCANDIR/$ENTRY.pnm
	S_CHOICES=$(zenity --list --checklist --title="Output Type" --column="" --column="Export Format" FALSE "Grayscale" FALSE "Color");
	#echo $S_CHOICES
	if [ "$S_CHOICES" == "Grayscale" ]
	then
		#echo "Grayscale"
		while [ $i -ne 1 ]
		do
			scanimage --mode gray > $SCANDIR/$ENTRY.pnm
			i=1
		done | (zenity --progress --title "TITLE" --text "SCANNING" --pulsate --auto-close)
		SAV_CONV	
	elif [ "$S_CHOICES" == "Color" ]
	then
	 	#echo "Color"
		while [ $i -ne 1 ]
		do
			scanimage --mode color --resolution 300 > $SCANDIR/$ENTRY.pnm
			i=1
		done | (zenity --progress --title "TITLE" --text "SCANNING" --pulsate --auto-close)
		SAV_CONV	
	else
		#echo "None"
		#EXIT
		zenity --error --text "Wrong Selection! "
	fi
		exit
		}
usb_modeswitch -R -v 04a9 -p 2759
PROCESS
