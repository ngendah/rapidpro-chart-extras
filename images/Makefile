##
## Copyright (c) 2023 Ngenda Henry
##
## For the license information refer to LICENSE.
##

DOCKER=docker
SRCS=$(addsuffix .s, rapidpro mailroom courier rp-indexer rp-archiver)
BUILDS=$(SRCS:.s=.build)
PUSH=$(SRCS:.s=.push)
REGISTRY_HOST?=127.0.0.1
BUILD_OPTIONS=
#
.PHONY: all build push clean

all: $(BUILDS) $(PUSH)

build: $(BUILDS)

push: $(PUSH)

%.build:
	$(eval build_args=$(shell echo $* | tr '-' '_' | tr '[a-z]' '[A-Z]')_VERSION=$(shell jq -r '.tag.version' $*/meta.json))
	$(eval image_tag=$(shell jq -r '.tag.name' $*/meta.json):v$(shell jq -r '.tag.version' $*/meta.json))
	$(DOCKER) buildx build $(BUILD_OPTIONS) \
		--build-arg $(build_args) \
		-t $(image_tag) \
		-f $*/Dockerfile $*; \
		$(file > $*/$@,$(image_tag))

%.push: %.build
	$(DOCKER) tag $(file < $*/$<) $(REGISTRY_HOST)/$(file < $*/$<)
	$(DOCKER) push $(REGISTRY_HOST)/$(file < $*/$<); \
		touch $*/$@

clean:
	-rm -r **/*.build **/*.push

