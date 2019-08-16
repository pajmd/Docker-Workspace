# Docker Compose

This docker-compose file is based on both zookeeper and solr official images  
* https://github.com/docker-solr/docker-solr/tree/master/7.7
* https://github.com/31z4/zookeeper-docker/blob/c978f835bc33509324b51cb210c8c5c9934c38ff/3.4.14/Dockerfile
as well as the solr - zookeeper docker-compose example 
* https://github.com/docker-solr/docker-solr-examples/blob/master/docker-compose/docker-compose.yml

Here we want to run solr in solrcloud mode connected to 3 zookeeper instances and create the nhs collection.

In this version of docker compose we added 2 services:

* upconfig: this is used as a pre-solr configuration. It:
	* creates a znode for solr: my_solr_conf
	* uploads a configuration set to this znode
* createcollection:
	* wait for at least one instance of solr to run: solr1
	* create a duplicate of this config set that we will use to create a collection (the original 
	config set won't be affected as we feed the collection)
	* create the nhsCollection
	* add fields to the collection schema


Along with this docker-compose file, this folder contains the base config set and the mongodb fields to add the collection schema

