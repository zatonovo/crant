PACKAGE = $(shell pwd | xargs basename)
REPOSITORY = $(PACKAGE)
VERSION ?= 1.0.0
IMAGE ?= $(REPOSITORY):$(VERSION)
PORT ?= 8004

HOST_DIR = $(shell pwd)
MOUNT_HOSTDIR = -v ${HOST_DIR}:/app/${PACKAGE}

CONTAINER_ID = $(shell docker ps | grep '${REPOSITORY}' | awk '{print $$1}')

.PHONY: all run test clean
all:
	docker build -t ${IMAGE} .
	docker tag ${IMAGE} ${REPOSITORY}:latest

# Open http://localhost:8004/ocpu/library/${PACKAGE}
run: all
	crant -SCi
	docker run -d -p ${PORT}:8004 ${MOUNT_HOSTDIR} ${REPOSITORY}

run-isolated: all
	docker run -d -p ${PORT}:8004 ${REPOSITORY}

stop:
	docker stop ${CONTAINER_ID}

bash:
	docker exec -it ${CONTAINER_ID} bash

notebook: all
	@mkdir -p notebooks
	docker run -it -p 8888:8888 ${MOUNT_HOSTDIR} -w /app/${PACKAGE}/notebooks ${REPOSITORY} jupyter notebook --allow-root

shiny:
	R --vanilla -e "library(shiny); shiny::runApp('shiny')"

