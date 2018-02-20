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
declare -a KEYS=('Humidity' 'Temperature');


which jq > /dev/null 2>&1
if [ $? == 1 ]; then
	echo "Install package jq"
    echo "sudo apt-get -y install jq"
else
	if [ "$#" -ne 3 ]; then
		echo "Illegal number of parameters"
		echo "Format is : Device ID Start Date:YY-MM-DD End Date:YY-MM-DD" 
		echo "Example: bash things.sh DEV1 2018-02-12 2018-02-18"
	else
		echo "Device ID:$1 Start Date:$2 End Date:$3" 
		if [[ $1 == "DEV1"  || $1 == "DEV2"  || $1 == "DEV3" ]]; then
			ID="${!1}"
			echo $ID
			date -d "$2" > /dev/null 2>&1
			if [ $? -eq 0 ]; then
			 # do something
			 #echo "Return zero $2"
			 SDATE=$(($(date -d "$2 " +%s%N)/1000000))
			 echo "SDATE is $SDATE"
			 date -d "$3" > /dev/null 2>&1
			 if [ $? -eq 0 ]; then
				#echo "Return zero $3"
				EDATE=$(($(date -d "$3 - 1 min" +%s%N)/1000000))
				echo "EDATE is $EDATE"
				JWT_TOKEN="$(curl -s -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"username":'\"$USER\"', "password":'\"$PASSWD\"'}' 'http://demo.thingsboard.io/api/auth/login'|jq -r '.token')"
				#echo $JWT_TOKEN
				#echo "SDATE is $SDATE and Edate is $EDATE"
				for (( i=0; i<${#KEYS[@]}; i++ ));
				do
					#Made curl silent
					curl -s -X GET "https://demo.thingsboard.io/api/plugins/telemetry/DEVICE/$ID/values/timeseries?keys=${KEYS[0]},${KEYS[1]}&startTs=$SDATE&endTs=$EDATE&interval=6000" --header "Content-Type:application/json" --header "X-Authorization: Bearer $JWT_TOKEN"|jq -r ".${KEYS[i]}|.[]|[(.ts|tostring),(.value|tostring)]| @csv" > ${KEYS[i]}.csv
					echo "${KEYS[i]} exported to ${KEYS[i]}.csv"
				done
				#DATA="$(curl -v -X GET "https://demo.thingsboard.io/api/plugins/telemetry/DEVICE/$DEV1/values/timeseries?keys=${KEYS[0]},${KEYS[1]}&startTs=$SDATE&endTs=$EDATE&interval=6000" --header "Content-Type:application/json" --header "X-Authorization: Bearer $JWT_TOKEN"|jq -r '.Humidity|.[]|[(.ts|tostring),(.value|tostring)]| @csv' > humidity.csv)"
				#echo $DATA
			 else
				echo "Date Format Error in $3"
			  fi
			else
			 # do something else
			  echo "Date Format Error in $2"
			fi
		else
			echo "Device ID Error"
		fi	
	fi
fi
