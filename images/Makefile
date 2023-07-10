##
## Copyright (c) 2023 Ngenda Henry
##
## For the license information refer to LICENSE.
##

DOCKER=docker
SRCS=$(addsuffix .s, rapidpro mailroom courier)
BUILDS=$(SRCS:.s=.build)
PUSH=$(SRCS:.s=.push)
REGISTRY_HOST=$(shell jq -r '.host' registry.json)
BUILD_OPTIONS=
#
.PHONY: clean

all: $(BUILDS) $(PUSH)

build: $(BUILDS)

push: $(PUSH)

%.build:
	$(DOCKER) buildx build $(BUILD_OPTIONS) \
		--build-arg $(shell echo $* | tr '[a-z]' '[A-Z]')_VERSION=$(shell jq -r '.tag.version' $*/meta.json) \
		-t $(shell jq -r '.tag.name' $*/meta.json):v$(shell jq -r '.tag.version' $*/meta.json) \
		-t $(REGISTRY_HOST)/$(shell jq -r '.tag.name' $*/meta.json):v$(shell jq -r '.tag.version' $*/meta.json) \
		-f $*/Dockerfile $*; \
		touch $*/$@

%.push: %.build
	$(DOCKER) push $(REGISTRY_HOST)/$(shell jq -r '.tag.name' $*/meta.json):v$(shell jq -r '.tag.version' $*/meta.json); \
		touch $*/$@

clean:
	-rm -r **/*.build **/*.push

