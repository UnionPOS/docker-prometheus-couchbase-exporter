-include $(shell curl -sSL -o .build-harness "https://raw.githubusercontent.com/unionpos/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)

export DOCKER_ORG ?= unionpos
export DOCKER_IMAGE ?= $(DOCKER_ORG)/prometheus-couchbase-exporter
export DOCKER_TAG ?= 0.8.1
export DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)
export DOCKER_BUILD_FLAGS =

build: docker/build

run:
	docker container run --rm \
		--publish "9191:9191" \
		--attach STDOUT ${DOCKER_IMAGE_NAME}

it:
	docker run -it ${DOCKER_IMAGE_NAME} /bin/bash
