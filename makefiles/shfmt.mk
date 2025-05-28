SHELL := /bin/bash -euo pipefail

define SHFMT_HELP
REQUIREMENTS:
  - shfmt : `shfmt` command must be available.
  - go    : `go` command must be available for `shfmt-install`.

TARGETS:
  - shfmt-help     : show help message.
  - shfmt          : run shfmt command with given args.
  - shfmt-install  : install shfmt using `go install`.
  - shfmt-run      : run shfmt to format.
  - shfmt-local    : shfmt-run for local env before push.

VARIABLES [default value]:
  - GO_CMD        : go command used in shfmt-install. [go]
  - SHFMT_CMD     : shfmt command. [$$(GOBIN)shfmt]
  - SHFMT_VERSION : shfmt version to install. [latest]
  - SHFMT_TARGET  : target of shell format. [./]
  - SHFMT_OPTION  : shfmt command line option. [--diff]

REFERENCES:
  - https://github.com/mvdan/sh

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=mkhl.shfmt
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format
  - JetBrains : https://plugins.jetbrains.com/plugin/13122-shell-script
  - Others?   : https://github.com/mvdan/sh?tab=readme-ov-file#related-projects

PROJECT STRUCTURE:
  /                  |-- Project
  ├─ _scripts/       |-- Git submodule
  │  └─ makefiles/   |
  │     └─ shfmt.mk  |
  └─ Makefile        |-- include _scripts/makefiles/shfmt.mk
endef

.PHONY: shfmt-help
shfmt-help:
	$(info $(SHFMT_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go
SHFMT_CMD ?= $(GOBIN)shfmt
SHFMT_VERSION ?= latest
SHFMT_TARGET ?= ./
SHFMT_OPTION ?= --diff

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: shfmt-install-usage
shfmt-install-usage:
	# Usage : make shfmt-install ARGS=""
	# Exec  : $$(GO_CMD) install $$(ARGS) "mvdan.cc/sh/v3/cmd/shfmt@$$(SHFMT_VERSION)"
	# Desc  : Install shfmt using `go install`.
	# Examples:
	#   - make shfmt-install
	#   - make shfmt-install ARGS="-tags netgo"
	#   - make shfmt-install SHFMT_VERSION="main"

.PHONY: shfmt-install
shfmt-install:
ifeq ("shfmt-install","$(MAKECMDGOALS)")
	$(GO_CMD) install $(ARGS) "mvdan.cc/sh/v3/cmd/shfmt@$(SHFMT_VERSION)"
	$(GO_CMD) mod tidy
else
ifeq (,$(shell which $(SHFMT_CMD) 2>/dev/null))
	$(GO_CMD) install $(ARGS) "mvdan.cc/sh/v3/cmd/shfmt@$(SHFMT_VERSION)"
	$(GO_CMD) mod tidy
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: shfmt-usage
shfmt-usage:
	# Usage : make shfmt ARGS=""
	# Exec  : $$(SHFMT_CMD) $$(ARGS)
	# Desc  : Run shfmt with given arguments.
	# Examples:
	#   - make shfmt ARGS="--version"
	#   - make shfmt ARGS="--help"

.PHONY: shfmt
shfmt: shfmt-install
	$(SHFMT_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: shfmt-run-usage
shfmt-run-usage:
	# Usage : make shfmt-run ARGS=""
	# Exec  : $$(SHFMT_CMD) $$(ARGS) $$(SHFMT_OPTION) $$(SHFMT_TARGET)
	# Desc  : Run shfmt for the specified targets.
	# Examples:
	#   - make shfmt-run
	#   - make shfmt-run ARGS="--write"
	#   - make shfmt-run SHFMT_OPTION="--write"

.PHONY: shfmt-run
shfmt-run: shfmt-install
	$(SHFMT_CMD) $(ARGS) $(SHFMT_OPTION) $(SHFMT_TARGET)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: shfmt-local-usage
shfmt-local-usage:
	# Usage : make shfmt-local ARGS=""
	# Exec  : $$(SHFMT_CMD) --write $$(ARGS) $$(SHFMT_OPTION) $$(SHFMT_TARGET)
	# Desc  : Run shfmt and write diff for the specified targets.
	# Examples:
	#   - make shfmt-local
	#   - make shfmt-local ARGS=""

.PHONY: shfmt-local
shfmt-local: shfmt-install
	$(SHFMT_CMD) --write $(ARGS) $(SHFMT_OPTION) $(SHFMT_TARGET)

#├─────────────────────────────────────────────────────────────────────────────┤
