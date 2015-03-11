#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
#       svn_add_user.sh
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

function ADD_SVN_USER {
	SVN_USER=$(zenity --entry --text "Please enter User Name" --title "Enter name")
	#echo $SVN_USER
	if [ "$S_CHOICES" == "Delete User" ]
	then
		htpasswd -D /etc/apache2/dav_svn.passwd $SVN_USER 	
	else
		PASSWD="$(zenity --password --title=Authentication)\n"
		#echo $PASSWD
		htpasswd -mb /etc/apache2/dav_svn.passwd $SVN_USER $PASSWD		
	fi
	SVN_LOOP	
		}
function SVN_FIRST_USER {
	S_CHOICES=$(zenity --list --checklist --title="User Action" --column="" --column="User Action" FALSE "Add User" FALSE "Delete User" FALSE "Change Password");
	#echo $S_CHOICES
	if [ "$S_CHOICES" == "Add User" ]
	then
		#echo $S_CHOICES
		ADD_SVN_USER
	elif [ "$S_CHOICES" == "Delete User" ]
	then
		#echo $S_CHOICES
		ADD_SVN_USER
	elif [ "$S_CHOICES" == "Change Password" ]
	then
		#echo $S_CHOICES
		ADD_SVN_USER
	else
		#echo "None"
		#EXIT
		zenity --error --text "Wrong Selection! "
	fi

		}
function SVN_LOOP {
	CONDN=$(zenity --question --title="Question" --text "Do you want to add another user")
	if [[ $? == 0 ]] ; then
		SVN_FIRST_USER
	else
   		EXIT
	fi
		}
function EXIT {
	exit
		}

SVN_FIRST_USER


