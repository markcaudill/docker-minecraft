SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DOCKER = docker
REPO = markcaudill

help :  ## This message
	@grep -E '^[^>]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help

lint : Dockerfile  ## Lint
	@echo "+ $@"
	$(DOCKER) run --rm -i hadolint/hadolint < $<
.PHONY: lint

shellcheck : config_and_run.sh  ## Shellcheck
	@echo "+ $@"
	$(DOCKER) run --rm -v "$$PWD:/mnt" koalaman/shellcheck:stable $<

build : lint  ## Build image
	@echo "+ $@"
	$(DOCKER) build -t $(REPO)/minecraft:1.17 .

push : build  ## Push to $(REPO)
	@echo "+ $@"
	$(DOCKER) push $(REPO)/minecraft:1.17
.PHONY: push
