##
## Copyright (c) 2023 Ngenda Henry
##
## For the license information refer to LICENSE.
##

DOCKER=docker
SRCS=$(addsuffix .s, rapidpro ureport mailroom courier rp-indexer rp-archiver)
BUILDS=$(SRCS:.s=.build)
PUSH=$(SRCS:.s=.push)
REGISTRY_HOST?=127.0.0.1
BUILD_OPTIONS=
#
.PHONY: all build push clean

all: $(BUILDS) $(PUSH)

build: $(BUILDS)

push: $(PUSH)

%.build: %/Dockerfile %/meta.json
	$(eval meta_file=$(filter-out $<,$^))
	$(eval tag_version=$(shell jq -r '.tag.version' $(meta_file)))
	$(eval tag_name=$(shell jq -r '.tag.name' $(meta_file)))
	$(eval build_args=$(shell echo $* | tr '-' '_' | tr '[a-z]' '[A-Z]')_VERSION=$(tag_version))
	$(eval image_tag=$(tag_name):v$(tag_version))
	$(DOCKER) buildx build $(BUILD_OPTIONS) \
		--build-arg $(build_args) \
		-t $(image_tag) \
		-f $< $*; \
		$(file > $*/$@,$(image_tag))

%.push: %.build
	$(DOCKER) tag $(file < $*/$<) $(REGISTRY_HOST)/$(file < $*/$<)
	$(DOCKER) push $(REGISTRY_HOST)/$(file < $*/$<); touch $*/$@
 
clean:
	-rm -r **/*.build **/*.push

