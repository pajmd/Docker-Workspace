# Dockerfile for Mongo Connector

# Use my bionic mongo python base (bionic has bash preinstalled)

FROM bionic-mongo-python

RUN pip install mongo-connector==3.1.1 solr-doc-manager==0.1.0

COPY start_mongo_connector.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/start_mongo_connector.sh"]
CMD ["localhost", "localhost"]
