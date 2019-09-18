#!/bin/bash

# start stop nhs-full-stack


usage() {
	cat << EOF
To start or stop nhs full stack:

usage: $0 [start [-c|--clean]|stop|suspend]

EOF
	exit 0
}

if [ -z $1 ]; then
	usage
elif [[ $1 = "start" ]]; then
	if [[ -z $2 ]]; then
		echo "start"
		docker-compose up -d
	elif [[ $2 =~ ^-c(lean)?$ ]]; then
		echo "start clean"
		if [[ -d $HOME/tmp/fullstack/data/db ]]; then
			sudo -u mongodb rm -rf $HOME/tmp/fullstack/data/db/* && docker-compose up -d
		else 
			mkdir -p $HOME/tmp/fullstack/data/db
			sudo chown mongodb:mongodb $HOME/tmp/fullstack/data/db
			docker-compose up -d
		fi
	else
		echo "$2 option unknown"
		usage
	fi
elif [[ $1 = "stop" ]]; then
	echo "stop"
	docker-compose down
elif [[ $1 = "suspend" ]]; then
	echo "suspend"
	docker-compose stop
else
	echo "$1 unknown command"
fi