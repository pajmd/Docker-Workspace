#!/bin/bash 

mongo_host=${1-"mongo_db"}
echo "mongo host: "$mongo_host

attempts_left=5
a_number="^[0-9]+$"

is_number() {
	val=$1
	# initialize to False
	local rc=0
	if ! [[ $val =~ ^[0-9]+$ ]]; then
		printf "\n$val is not a number" >&2
	else
		printf "\n$val is a number" >&2
		rc=1
	fi
	echo $rc
}

check_mongod_up() {
	while (( attempts_left > 0 )); do

		(( attempts_left-- ))
		if (( attempts_left == 0 )); then
			echo "Mongo still not running. Giving up" >&2
			exit 1
		fi
		mongo_session=`/usr/bin/mongo "mongodb://$mongo_host:27017" --eval "quit()" | grep "Implicit session"`
		echo "mongo_session: ""$mongo_session" >&2
		if [ -z "$mongo_session" ]; then
			echo "Waiting for Mongo another " $attempts_left " times" >&2
			sleep 5
		else
			break
		fi
	done
	echo "Mongo is running!" >&2
	# echo "Mongo is rs initiate" >&2
	# echo $(/usr/bin/mongo "mongodb://$mongo_host:27017" --eval "rs.initiate(); rs.add($mongo_host)") >&2
	# local nshcount=`/usr/bin/mongo "mongodb://$mongo_host:27017" --quiet  --eval "db = db=db.getSiblingDB('nhsdb'); db.nhsCollection.find().count()"`
	# echo $nshcount
}


res=$(check_mongod_up $mongo_host)
res=0

printf "\nnshCollection count = $res"

if [[ $(is_number "$res") != 1 ]]; then
	printf "\nSome error occured while checking nhscollection"
	exit 1
elif [[ $res != 0 ]]; then
	printf "\nNhscollection exist. No need to initialize the db"
	# /usr/bin/mongo "mongodb://$mongo_host:27017" --eval "rs.initiate();"
else
	printf "\ninitiate replica set"
	# mongo "mongodb://mongodb0.example.com:27017"
	# Another way to create db and collections would be mongo nhdsb create_collections.js
	/usr/bin/mongo "mongodb://$mongo_host:27017" --eval "rs.initiate();"
	printf "\initiate done!"
	/usr/bin/mongo "mongodb://$mongo_host:27017" --eval "rs.add($mongo_host); db=db.getSiblingDB('nhsdb'); db.createCollection('nhsCollection'); db.createCollection('nhsUsers')"
fi

