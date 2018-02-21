#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
#       things.sh
#       
#       Copyright 2018 Ganesh <ganeshredcobra@gmail.com>
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

USER="renjith@beginow.in"
PASSWD="renjith88"
DEV1="d21f5600-0cd0-11e8-b10e-03e9461109ca"
DEV2="5453e3b0-08ef-11e8-9141-1d8d2edf4f93"
DEV3="3c69e6a0-1196-11e8-a6c4-03e9461109ca"
ID=""
sdateCal="NULL"
edateCal="NULL"
declare -a KEYS=('Humidity' 'Temperature');

function CHCKPKGS {
which jq > /dev/null 2>&1
if [ $? == 1 ]; then
	echo "Install package jq"
    echo "sudo apt-get -y install jq"
    exit
else
	which zenity > /dev/null 2>&1
	if [ $? == 1 ]; then
		echo "Install package zenity"
		echo "sudo apt-get -y install zenity"
		exit
	fi
	
	echo "Package Dependency met"
fi

}

CHCKPKGS
selDev=$(zenity  --list  --text "Select a Device ID" --radiolist  --column "Pick" --column "Device" TRUE DEV1 FALSE DEV2 FALSE DEV3 2> /dev/null)		
if [[ $selDev == "DEV1"  || $selDev == "DEV2"  || $selDev == "DEV3" ]]; then
	ID="${!selDev}"
	sdateCal=$(zenity --calendar --title="Select Start Date" --date-format=%Y-%m-%d 2> /dev/null)
	edateCal=$(zenity --calendar --title="Select End Date" --date-format=%Y-%m-%d 2> /dev/null)
	if [  -z "$sdateCal"  ]; then
	 	echo "Date Format Error in Start date"
	 else				
		# do something
	 #echo "Return zero $2"
	 SDATE=$(($(date -d "$sdateCal " +%s%N)/1000000))
	 fi
	 if [  -z "$edateCal" ]; then
		echo "Date Format Error in End date"
	else
	 # do something else			  
	  #echo "Return zero $3"
		EDATE=$(($(date -d "$edateCal - 1 min" +%s%N)/1000000))
		JWT_TOKEN="$(curl -s -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"username":'\"$USER\"', "password":'\"$PASSWD\"'}' 'http://demo.thingsboard.io/api/auth/login'|jq -r '.token')"
		echo "Device ID:$selDev Start Date:$sdateCal End Date:$edateCal" 
		for (( i=0; i<${#KEYS[@]}; i++ ));
		do
			#Made curl silent
			fileName="$selDev-${KEYS[i]}$(date  +"-%d-%m-%Y-%I:%M%p").csv"
			curl -s -X GET "https://demo.thingsboard.io/api/plugins/telemetry/DEVICE/$ID/values/timeseries?keys=${KEYS[0]},${KEYS[1]}&startTs=$SDATE&endTs=$EDATE&interval=6000" --header "Content-Type:application/json" --header "X-Authorization: Bearer $JWT_TOKEN"|jq -r "select(.${KEYS[i]} != null)|.${KEYS[i]}|.[]|[(.ts|tostring),(.value|tostring)]| @csv" > $fileName
			if [ -s "$fileName" ]
			then 
			   echo "${KEYS[i]} data exported to $fileName "
			else
			   rm $fileName
			   echo "${KEYS[i]} data does not exist for given dates"
			fi
		done				
	fi
else
	echo "Device ID Error"
fi	

