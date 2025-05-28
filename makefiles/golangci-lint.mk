SHELL := /bin/bash -euo pipefail

define GOLANGCI_LINT_HELP
REQUIREMENTS:
  - golangci-lint : `golangci-lint` command must be available.
  - go            : `go` command must be available for `golangci-lint-install`.

TARGETS:
  - golangci-lint-help    : show help message.
  - golangci-lint-install : install golangci-lint using `go install`.
  - golangci-lint         : run golangci-lint command with given args.
  - golangci-lint-run     : run lint.

VARIABLES [default value]:
  - GO_CMD                : go command used in golangci-lint-install. [go]
  - GOLANGCI_LINT_CMD     : golangci-lint command. [$$(GOBIN)golangci-lint]
  - GOLANGCI_LINT_VERSION : golangci-lint version to install. [latest]
  - GOLANGCI_LINT_TARGET  : lint target. [./...]
  - GOLANGCI_LINT_OPTION  : command line option for lint. []

REFERENCES:
  - https://github.com/golangci/golangci-lint
  - https://golangci-lint.run/

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=golang.Go
  - JetBrains : https://plugins.jetbrains.com/plugin/12496-go-linter
  - Others?   : https://golangci-lint.run/welcome/integrations/

PROJECT STRUCTURE:
  /                          |-- Go Project
  ├─ _scripts/               |-- Git submodule
  │  └─ makefiles/           |
  │     └─ golangci-lint.mk  |
  ├─ .golangci.yaml          |-- Config file
  ├─ Makefile                |-- include _scripts/makefiles/golangci-lint.mk
  ├─ go.mod                  |
  └─ go.sum                  |
endef

.PHONY: golangci-lint-help
golangci-lint-help:
	$(info $(GOLANGCI_LINT_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go
GOLANGCI_LINT_CMD ?= $(GOBIN)golangci-lint
GOLANGCI_LINT_VERSION ?= latest
GOLANGCI_LINT_TARGET ?= ./...
GOLANGCI_LINT_OPTION ?=

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: golangci-lint-install-usage
golangci-lint-install-usage:
	# Usage : make golangci-lint-install ARGS=""
	# Exec  : $$(GO_CMD) install $$(ARGS) "github.com/golangci/golangci-lint/v2/cmd/golangci-lint@$$(GOLANGCI_LINT_VERSION)"
	# Desc  : Install golangci-lint using `go install`.
	# Examples:
	#   - make golangci-lint-install
	#   - make golangci-lint-install ARGS="-tags netgo"
	#   - make golangci-lint-install GOLANGCI_LINT_VERSION="main"

.PHONY: golangci-lint-install
golangci-lint-install:
ifeq ("golangci-lint-install","$(MAKECMDGOALS)")
	$(GO_CMD) install $(ARGS) "github.com/golangci/golangci-lint/v2/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION)"
	$(GO_CMD) mod tidy
else
ifeq (,$(shell which $(GOLANGCI_LINT_CMD) 2>/dev/null))
	$(GO_CMD) install $(ARGS) "github.com/golangci/golangci-lint/v2/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION)"
	$(GO_CMD) mod tidy
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: golangci-lint-usage
golangci-lint-usage:
	# Usage : make golangci-lint ARGS=""
	# Exec  : $$(GOLANGCI_LINT_CMD) $$(ARGS)
	# Desc  : Run golangci-lint with given arguments.
	# Examples:
	#   - make golangci-lint ARGS="--version"
	#   - make golangci-lint ARGS="--help"

.PHONY: golangci-lint
golangci-lint: golangci-lint-install
	$(GOLANGCI_LINT_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: golangci-lint-run-usage
golangci-lint-run-usage:
	# Usage : make golangci-lint-run ARGS=""
	# Exec  : $$(GOLANGCI_LINT_CMD) run $$(ARGS) $$(GOLANGCI_LINT_OPTION) $$(GOLANGCI_LINT_TARGET)
	# Desc  : Run golangci-lint for the specified targets.
	# Examples:
	#   - make golangci-lint-run
	#   - make golangci-lint-run ARGS=""

.PHONY: golangci-lint-run
golangci-lint-run: golangci-lint-install
	$(GOLANGCI_LINT_CMD) run $(ARGS) $(GOLANGCI_LINT_OPTION) $(GOLANGCI_LINT_TARGET)

#├─────────────────────────────────────────────────────────────────────────────┤
