# This option causes make to display a warning whenever an undefined variable is expanded.
MAKEFLAGS += --warn-undefined-variables

# Disable any builtin pattern rules, then speedup a bit.
MAKEFLAGS += --no-builtin-rules

# If this variable is not set, the program /bin/sh is used as the shell.
SHELL := /bin/bash

# The arguments passed to the shell are taken from the variable .SHELLFLAGS.
#
# The -e flag causes bash with qualifications to exit immediately if a command it executes fails.
# The -u flag causes bash to exit with an error message if a variable is accessed without being defined.
# The -o pipefail option causes bash to exit if any of the commands in a pipeline fail.
# The -c flag is in the default value of .SHELLFLAGS and we must preserve it.
# Because it is how make passes the script to be executed to bash.
.SHELLFLAGS := -eu -o pipefail -c

# Disable any builtin suffix rules, then speedup a bit.
.SUFFIXES:

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

#
# Variables for the directory path
#
ROOT_DIR ?= $(shell $(GIT) rev-parse --show-toplevel)
CLI_CONFIG_DIR ?= .github

#
# Variables to be used by Git and GitHub CLI
#
GIT ?= $(shell \command -v git 2>/dev/null)
GH ?= $(shell \command -v gh 2>/dev/null)

#
# Variables to be used by Docker
#
DOCKER ?= $(shell \command -v docker 2>/dev/null)
DOCKER_WORK_DIR ?= /work
DOCKER_RUN_OPTIONS ?=
DOCKER_RUN_OPTIONS += -it
DOCKER_RUN_OPTIONS += --rm
DOCKER_RUN_OPTIONS += -v $(ROOT_DIR):$(DOCKER_WORK_DIR)
DOCKER_RUN_OPTIONS += -w $(DOCKER_WORK_DIR)
DOCKER_RUN_SECURE_OPTIONS ?=
DOCKER_RUN_SECURE_OPTIONS += --security-opt=no-new-privileges
DOCKER_RUN_SECURE_OPTIONS += --cap-drop all
DOCKER_RUN_SECURE_OPTIONS += --network none
DOCKER_RUN ?= $(DOCKER) run $(DOCKER_RUN_OPTIONS)
SECURE_DOCKER_RUN ?= $(DOCKER_RUN) $(DOCKER_RUN_SECURE_OPTIONS)

#
# Lint
#
.PHONY: lint
lint: lint-yaml lint-markdown ## lint all

.PHONY: lint-yaml
lint-yaml: ## lint yaml by yamllint and prettier
	$(SECURE_DOCKER_RUN) yamllint --strict --config-file $(CLI_CONFIG_DIR)/.yamllint.yml .
	$(SECURE_DOCKER_RUN) prettier --check --parser=yaml **/*.y*ml

.PHONY: lint-markdown
lint-markdown: ## lint markdown by markdownlint and prettier
	$(SECURE_DOCKER_RUN) markdownlint --dot --config $(CLI_CONFIG_DIR)/.markdownlint.yml **/*.md
	$(SECURE_DOCKER_RUN) prettier --check --parser=markdown **/*.md

#
# Format code
#
.PHONY: format
format: format-markdown format-yaml ## format all

.PHONY: format-markdown
format-markdown: ## format markdown by prettier
	$(SECURE_DOCKER_RUN) prettier --write --parser=markdown **/*.md

.PHONY: format-yaml
format-yaml: ## format yaml by prettier
	$(SECURE_DOCKER_RUN) prettier --write --parser=yaml **/*.y*ml

#
# Documentation management
#
.PHONY: docs
docs: ## update documents
	version=$$(cat VERSION) && \
	awk -v version=$${version} \
	    '{sub(/[0-9]+\.[0-9]+\.[0-9]+/, version, $$0); print $$0}' \
	    README.md > $${TMPDIR}/README.md && \
	mv $${TMPDIR}/README.md README.md

#
# Release management
#
release: push-tag create-release ## release

push-tag:
	version="v$$(cat VERSION)" && \
	major_version=$$(echo "$${version%%.*}") && \
	$(GIT) tag --force "$${version}" && \
	$(GIT) tag --force "$${major_version}" && \
	$(GIT) push --force origin "$${version}" && \
	$(GIT) push --force origin "$${major_version}"

create-release:
	version="v$$(cat VERSION)" && \
	notes="- Release $${version}" && \
	$(GH) release create "$${version}" --title "$${version}" --notes "$${notes}" --draft && \
	echo "Wait GitHub Release creation..." && \
	sleep 3 && \
	$(GH) release view "$${version}" --web

bump: input-version docs commit create-pr ## bump version

input-version:
	@echo "Current version: $$(cat VERSION)" && \
	read -rp "Input next version: " version && \
	echo "$${version}" > VERSION

commit:
	version="v$$(cat VERSION)" && \
	$(GIT) switch -c "bump-$${version}" && \
	$(GIT) add VERSION && \
	$(GIT) commit -m "Bump up to $${version}" && \
	$(GIT) add README.md && \
	$(GIT) commit -m "Update docs to $${version}"

create-pr:
	$(GIT) push origin $$($(GIT) rev-parse --abbrev-ref HEAD) && \
	$(GH) pr create --fill --web

#
# Help
#
.PHONY: help
help: ## show help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
