# Makefile for pymock-example
# Common tasks: install, run locally, build/run docker, etc.

SHELL := /usr/bin/env bash

# Docker-related variables
IMAGE_NAME := pymock-example
CONTAINER_NAME := pymock-example-container
PORT := 8085

# Declare these as PHONY so that make doesn't look for actual files named after these targets
.PHONY: all install run test clean docker-build docker-run docker-stop docker-logs docker-clean

all: install run

## ------- LOCAL TASKS ------- ##

install:
	@echo ">>> Installing Python dependencies"
	pip install --upgrade pip
	pip install -r requirements.txt

run:
	@echo ">>> Running PyMock with main.py"
	python main.py

test:
	@echo ">>> (Optional) Running tests..."
	# Example: if you have a tests/ folder, you'd do:
	pytest tests

clean:
	@echo ">>> Removing Python build artifacts"
	rm -rf __pycache__ *.pyc .pytest_cache
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete

## ------- DOCKER TASKS ------- ##

dcb:
	@echo ">>> Building Docker image: $(IMAGE_NAME)"
	docker build -t $(IMAGE_NAME) .

dcr: dcb
	@echo ">>> Running Docker container on port $(PORT)"
	docker run --rm -d \
		--name $(CONTAINER_NAME) \
		-p $(PORT):$(PORT) \
		-v $(PWD)/logs:/logs \
		-e PYMOCK__DEBUG=true \
		-e PYMOCK__LOG_LEVEL=DEBUG \
		-e PYMOCK__LOG_FILE=/logs/pymock.log \
		$(IMAGE_NAME)

dcs:
	@echo ">>> Stopping Docker container: $(CONTAINER_NAME)"
	-docker stop $(CONTAINER_NAME)

dcl:
	@echo ">>> Tail logs for Docker container: $(CONTAINER_NAME)"
	docker logs -f $(CONTAINER_NAME)

dcc: dcs
	@echo ">>> Removing Docker container and image"
	-docker rm $(CONTAINER_NAME) || true
	-docker rmi $(IMAGE_NAME) || true
