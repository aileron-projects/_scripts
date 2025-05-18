SHELL ?= /bin/bash -euo pipefail
define GOVULNCHECK_HELP
REQUIREMENTS:
  - govulncheck : `govulncheck` command must be available.
  - go          : `go` command must be available for `govulncheck-install`.

TARGETS:
  - govulncheck-help    : show help message.
  - govulncheck-install : install govulncheck using `go install`.
  - govulncheck         : run govulncheck command with given args.
  - govulncheck-run     : run vulnerability check.

VARIABLES [default value]:
  - GO_CMD              : go command used in govulncheck-install. [go]
  - GOVULNCHECK_CMD     : govulncheck command. [$$(GOBIN)govulncheck]
  - GOVULNCHECK_VERSION : govulncheck version to install. [latest]
  - GOVULNCHECK_TARGET  : target of vulnerability check. [./...]
  - GOVULNCHECK_OPTION  : govulncheck command line option. []

REFERENCES:
  - https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck
  - https://go.dev/doc/tutorial/govulncheck

IDE INTEGRATIONS:
  - none

PROJECT STRUCTURE:
  /                        |-- Go Project
  ├─ _scripts/             |-- Git submodule
  │  └─ makefiles/         |
  │     └─ govulncheck.mk  |
  ├─ Makefile              |-- include _scripts/makefiles/govulncheck.mk
  ├─ go.mod                |
  └─ go.sum                |
endef

.PHONY: govulncheck-help
govulncheck-help:
	$(info $(GOVULNCHECK_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go
GOVULNCHECK_CMD ?= $(GOBIN)govulncheck
GOVULNCHECK_VERSION ?= latest
GOVULNCHECK_TARGET ?= ./...
GOVULNCHECK_OPTION ?= 

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: govulncheck-install-usage
govulncheck-install-usage:
	# Usage : make govulncheck-install ARGS=""
	# Exec  : $$(GO_CMD) install $$(ARGS) "golang.org/x/vuln/cmd/govulncheck@$$(GOVULNCHECK_VERSION)"
	# Desc  : Install govulncheck using `go install`.
	# Examples:
	#   - make govulncheck-install
	#   - make govulncheck-install ARGS="-tags netgo"
	#   - make govulncheck-install GOVULNCHECK_VERSION="main"

.PHONY: govulncheck-install
govulncheck-install:
ifeq ("govulncheck-install","$(MAKECMDGOALS)")
	$(GO_CMD) install $(ARGS) "golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION)"
	$(GO_CMD) mod tidy
else
ifeq (,$(shell which $(GOVULNCHECK_CMD) 2>/dev/null))
	$(GO_CMD) install $(ARGS) "golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION)"
	$(GO_CMD) mod tidy
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: govulncheck-usage
govulncheck-usage:
	# Usage : make govulncheck ARGS=""
	# Exec  : $$(GOVULNCHECK_CMD) $$(ARGS)
	# Desc  : Run govulcheck with given arguments.
	# Examples:
	#   - make govulncheck ARGS="-version"
	#   - make govulncheck ARGS="-help"

.PHONY: govulncheck
govulncheck: govulncheck-install
	$(GOVULNCHECK_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: govulncheck-run-usage
govulncheck-run-usage:
	# Usage : make govulncheck-run ARGS=""
	# Exec  : $$(GOVULNCHECK_CMD) $$(ARGS) $$(GOVULNCHECK_OPTION) $$(GOVULNCHECK_TARGET)
	# Desc  : Run govulncheck for the specified targets.
	# Examples:
	#   - make govulncheck-run
	#   - make govulncheck-run ARGS=""

.PHONY: govulncheck-run
govulncheck-run: govulncheck-install
	$(GOVULNCHECK_CMD) $(ARGS) $(GOVULNCHECK_OPTION) $(GOVULNCHECK_TARGET)

#├─────────────────────────────────────────────────────────────────────────────┤
