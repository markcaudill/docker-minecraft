SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --jobs=$(shell nproc)
MAKEFLAGS += --load-average=$(shell nproc)

DOCKER_REPO = markcaudill/minecraft

# Commands
CURL = curl
DOCKER = docker
JQ = jq
LINT = $(DOCKER) run --rm -i hadolint/hadolint <
MKDIR = mkdir
TOUCH = touch
XARGS = xargs

# Directories for Make state
IMAGE_DIR = image
PUSH_DIR = push
STATE_DIRS = $(IMAGE_DIR) $(PUSH_DIR)

help :  ## This message
	@grep -E '^[^>]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help

$(STATE_DIRS) :
	@echo "+ $@"
	$(MKDIR) $@

$(IMAGE_DIR)/% : server_urls.json Dockerfile lint | $(IMAGE_DIR)  ## Build an image
	@echo "+ $@"
	@$(DOCKER) build \
		-t $(DOCKER_REPO):$(subst $(IMAGE_DIR)/,,$@) \
		--build-arg MC_SERVER_JAR_DL=$(shell $(JQ) -r 'map(select(.id=="$(subst $(IMAGE_DIR)/,,$@)"))[].url' $<) \
		. && $(TOUCH) $@

$(PUSH_DIR)/% : $(IMAGE_DIR)/% | $(PUSH_DIR)  ## Push an image
	@echo "+ $@"
	$(DOCKER) push $(DOCKER_REPO):$(subst $(PUSH_DIR)/,,$@) && \
	$(TOUCH) $@

lint : Dockerfile  ## Lint
	@echo "+ $@"
	$(LINT) $<
.PHONY: lint

server_urls.json :
	@echo "+ $@"
	$(CURL) -s https://launchermeta.mojang.com/mc/game/version_manifest.json | \
		$(JQ) -r '.versions|map(select(.type=="release"))[].url' | \
		$(XARGS) -l1 $(CURL) -s | \
		$(JQ) -r '{"id":.id,"url":.downloads.server.url}|select(.url != null)' | \
		$(JQ) -s > $@

build-all : server_urls.json  ## Build image for each release version that has a server download
	@echo "+ $@"
	$(MAKE) $(addprefix $(IMAGE_DIR)/,$(shell $(JQ) -r 'map(.id)[]' server_urls.json | xargs))
.PHONY: build-all

push-all : server_urls.json  ## Build image for each release version that has a server download
	@echo "+ $@"
	$(MAKE) $(addprefix $(PUSH_DIR)/,$(shell $(JQ) -r 'map(.id)[]' server_urls.json | xargs))
.PHONY: push-all

clean :  ## Cleanup
	@echo "+ $@"
	rm -rf server_urls.json $(STATE_DIRS)
.PHONY: clean
