INSTALL_DIR ?= ~/.config/rofi/scripts/
SHELL=bash
FILES=shortcut.sh
IMG_VERSION=0.1
IMAGE=registry.gitlab.com/matclab/rofi-i3-shortcut-help/rish-test:${IMG_VERSION} 

.DEFAULT_GOAL := help
.PHONY: help

help: ### Print this help message
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	 | sed -n 's/^\(.*\):\(.*\)##\(.*\)/\1▅\3/p' \
	| column -t  -s '▅'



.PHONY: install
install: ## Install to INSTALL_DIR variable (make INSTALL_DIR=/tmp)
	mkdir -p ${INSTALL_DIR}
	cp ${FILES} ${INSTALL_DIR}

.PHONY: test
test: ## Run test (use bats)
	bats tests

.PHONY: docker
docker:  ## Build and push docker CI image
	docker build -t ${IMAGE} docker \
	&& docker push ${IMAGE}



