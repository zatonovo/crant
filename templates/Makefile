PACKAGE = $(shell pwd | xargs basename)
REPOSITORY = $(PACKAGE)
VERSION ?= 1.0.0
IMAGE ?= $(REPOSITORY):$(VERSION)

HOST_DIR = $(shell pwd)
MOUNT_HOSTDIR = -v ${HOST_DIR}:/app/${PACKAGE}

CONTAINER_ID = $(shell docker ps | grep '${REPOSITORY}' | awk '{print $$1}')

.PHONY: all run test clean
all:
	docker build -t ${IMAGE} .
	docker tag ${IMAGE} ${REPOSITORY}:latest

# Open http://localhost:8004/ocpu/library/${PACKAGE}
run: all
	docker run -d -p 8004:8004 ${MOUNT_HOSTDIR} ${REPOSITORY}

notebook:
	docker run -it --rm -p 8888:8888 ${REPOSITORY} start-notebook.sh

stop:
	docker stop ${CONTAINER_ID}

bash:
	docker exec -it ${CONTAINER_ID} bash

