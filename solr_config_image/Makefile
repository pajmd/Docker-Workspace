# 
# This Makefile build the solr_data_olnly image based on solr:7, tags it and pushes to local docker repos
# This image is used for initializing the solr cluster only
#
NAME   := pjmd-ubuntu.com/solr_data_olnly
TAG    := $$(git describe --tag)
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:latest
 
build:
	@docker build -t ${IMG} --build-arg GIT_VERSION=${TAG} .
	@docker tag ${IMG} ${LATEST}

push:
	@docker ${IMG}

# login:
#   @docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}