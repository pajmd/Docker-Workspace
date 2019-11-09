# this image is just to get a full directory tree of configuration files for the solr schema
# into a container at deploy time to be used in a k8s initContainers and emptyDir mounts
FROM solr:7.5.0
COPY conf /nhs_solr_schema
COPY /solr_mongo_fields /solr_mongo_fields
USER root
RUN apt-get update
RUN apt-get install -y --no-install-recommends  jq