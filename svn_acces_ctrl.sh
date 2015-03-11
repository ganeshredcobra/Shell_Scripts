#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
#       svn_acces_ctrl.sh
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

SVN_ACESS_CTRL=/etc/apache2/svn_access_control
TEMP_CONF=/tmp/tmp.txt

function EXIT {
	exit
		}
function ADD_REPO_FIRST {
    touch $TEMP_CONF
    REPO=$(zenity --entry --text "Please enter Repository name" --title "Enter name")
    echo " " >> $TEMP_CONF
    echo "[$REPO:/]" >> $TEMP_CONF
    echo "dts = rw" >> $TEMP_CONF
    ACCESS=$(zenity --entry --text "Enter user to be added" --title "Enter username")
    echo "$ACCESS  = rw" >> $TEMP_CONF
		}
function ACC {
	ACCESS=$(zenity --entry --text "Enter user to be added" --title "Enter username")
    echo "$ACCESS  = rw" >> $TEMP_CONF
    ADD_LOOP
		}
function ADD_LOOP {
    zenity --question --title="Question" --text="Do you want to add another user?"
    if [[ $? == 0 ]]
    then
        ACC
    else
        cat "$TEMP_CONF" >> $SVN_ACESS_CTRL
        rm $TEMP_CONF
        zenity --question --title="Question" --text="Do you want to add another Repository?"
        if [[ $? == 0 ]]
        then
            ADD_REPO_FIRST
            ADD_LOOP
        else    
            EXIT
        fi
    fi	
		}
function CHECK_ROOT {
    if [ "$(id -u)" != "0" ];
    then
       echo "This script must be run as root" 1>&2
       exit 1
    fi
		}
		
CHECK_ROOT
ADD_REPO_FIRST
ADD_LOOP

