#!/bin/bash

attempts_left=5

check_mongod_up() {
	while (( attempts_left > 0 )); do

		(( attempts_left-- ))
		if (( attempts_left == 0 )); then
			echo "Mongo still not running. Giving up"
			exit 1
		fi
		mongo_session=`/usr/bin/mongo "mongodb://mongo_db:27017" --eval "quit()" | grep "Implicit session"`
		if [ -z "$mongo_session" ]; then
			echo "Waiting for Mongo another " $attempts_left " times"
			sleep 5
		else
			break
		fi
	done
	echo "Mongo is running!"
}

check_mongod_up

echo "initiate replica set"
# mongo "mongodb://mongodb0.example.com:27017"
/usr/bin/mongo "mongodb://mongo_db:27017" --eval "rs.initiate()"
