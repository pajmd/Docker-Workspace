# 
# This Makefile build the solr_data_olnly image based on solr:7, tags it and pushes to local docker repos
# This image is used for initializing the solr cluster only
#
APP    := solr_data_olnly
PUBLIC_REPO := pajmd
NAME   := pjmd-ubuntu.com/${APP}
TAG    := $$(git describe --tag)
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:latest
PUBLIC_IMG := ${PUBLIC_REPO}/${APP}:${TAG}

all: push
 
build:
	@git fetch origin
	@docker build -t ${IMG} --build-arg GIT_VERSION=${TAG} .
	@docker tag ${IMG} ${LATEST}
	@docker tag ${IMG} ${PUBLIC_IMG}

push: build
	@docker ${IMG}

# login:
#   @docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}