#!/bin/bash -x

# start_mongo_connector.sh
# $1 must be set with db host
# $2 must be set with the solr host

if [ -z $1 ]; then
	exit 1
elif [ -z $2 ]; then
	exit 2
fi

DB_HOST=$1
SOLR_HOST=$2

check_mongod_up() {
	attempts_left=5
	mongo_hostname=$1
	while (( attempts_left > 0 )); do

		(( attempts_left-- ))
		if (( attempts_left == 0 )); then
			echo "Mongo still not running. Giving up"
			exit 1
		fi
		mongo_session=`/usr/bin/mongo "mongodb://$mongo_hostname:27017" --eval "quit()" | grep "Implicit session"`
		echo "mongo_session= $mongo_session"
		if [ -z "$mongo_session" ]; then
			echo "Waiting for Mongo another " $attempts_left " times"
			sleep 5
		else
			break
		fi
	done
	echo "$mongo_hostname is running!"
}


check_solr_up() {
	attempts_left=12
	solr_url=$1
	while (( attempts_left > 0 )); do

		(( attempts_left-- ))
		if (( attempts_left == 0 )); then
			echo "$solr_url still not running or nhsCollection not ready. Giving up"
			exit 1
		fi
		echo "==========================================="
		# wget -o /dev/null -O - "http://solr1:8983/solr/nhsCollection/admin/luke/?show=schema&wt=json" | grep "stuff"
		# res=`wget -o /dev/null -O - "$solr_url/solr/nhsCollection/select?q=*%3A*&spellcheck=on" | grep response`
		res=`wget -o /dev/null -O - "$solr_url/solr/nhsCollection/admin/luke/?show=schema&wt=json" | grep "VMPP Snomed Code"`
		# res=`wget -q -O - "$solr_url" | grep -i solr`
		echo "wget result: $res"
		if [ -z "$res" ] ; then
			echo "Waiting for $solr_url and nhsCollection another " $attempts_left " times"
			sleep 5
		else
		    break
		fi
	done
	echo " $solr_url is running and nhsCollection ready!"

}

check_solr_up "http://$SOLR_HOST:8983"
check_mongod_up $DB_HOST

echo "Connecting mongo-connector --stdout --unique-key=id --namespace-set=nhsdb.nhsCollection -m $DB_HOST:27017 -t http://$SOLR_HOST:8983/solr/nhsCollection -d solr_doc_manager -v --auto-commit-interval=2"
mongo-connector --stdout --unique-key=id --namespace-set=nhsdb.nhsCollection -m $DB_HOST:27017 -t http://$SOLR_HOST:8983/solr/nhsCollection -d solr_doc_manager -v --auto-commit-interval=2