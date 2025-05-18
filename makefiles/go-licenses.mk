SHELL ?= /bin/bash -euo pipefail

define GO_LICENSES_HELP
REQUIREMENTS:
  - go-licenses : `go-licenses` command must be available.
  - go          : `go` command must be available for `go-licenses-install`.

TARGETS:
  - go-licenses-help    : show help message.
  - go-licenses-install : install go-licenses.
  - go-licenses         : run go-licenses command with given args.
  - go-licenses-run     : check licenses and generate licenses file.

VARIABLES [default value]:
  - GO_CMD                    : go command used in go-licenses-install. [go]
  - GO_LICENSES_CMD           : go-licenses command. [$$(GOBIN)go-licenses]
  - GO_LICENSES_VERSION       : go-licenses version to install. [latest]
  - GO_LICENSES_TARGET        : target for check and report. [./...]
  - GO_LICENSES_OUTPUT        : license list output file. [_output/go-licenses.csv]
  - GO_LICENSES_OPTION_CHECK  : command line option for check. [--allowed_licenses=MIT,Apache-2.0,BSD-2-Clause,BSD-3-Clause,BSD-4-Clause]
  - GO_LICENSES_OPTION_REPORT : command line option for report. []

REFERENCES:
  - https://github.com/google/go-licenses
  - https://github.com/google/go-licenses/blob/master/licenses/types.go
  - https://pkg.go.dev/github.com/google/go-licenses
  - https://pkg.go.dev/github.com/google/go-licenses/v2

IDE INTEGRATIONS:
  - none

PROJECT STRUCTURE:
  /                        |-- Go Project
  ├─ _output/              |
  │  └─ go-licenses.csv    |-- Default licenses output 
  ├─ _scripts/             |-- Git submodule
  │  └─ makefiles/         |
  │     └─ go-licenses.mk  |
  ├─ Makefile              |-- include _scripts/makefiles/go-licenses.mk
  ├─ go.mod                |
  └─ go.sum                |
endef

.PHONY: go-licenses-help
go-licenses-help:
	$(info $(GO_LICENSES_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go
GO_LICENSES_CMD ?= $(GOBIN)go-licenses
GO_LICENSES_VERSION ?= latest
GO_LICENSES_TARGET ?= ./...
GO_LICENSES_OUTPUT ?= _output/go-licenses.csv
GO_LICENSES_OPTION_CHECK ?= --allowed_licenses=MIT,Apache-2.0,BSD-2-Clause,BSD-3-Clause,BSD-4-Clause.ISC
GO_LICENSES_OPTION_REPORT ?= 

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: go-licenses-install-usage
go-licenses-install-usage:
	# Usage : make go-licenses-install ARGS=""
	# Exec  : $$(GO_CMD) install $$(ARGS) "github.com/google/go-licenses/v2@$$(GO_LICENSES_VERSION)"
	# Desc  : Install go-licenses using `go install`.
	# Examples:
	#   - make go-licenses-install
	#   - make go-licenses-install ARGS="-tags netgo"
	#   - make go-licenses-install GO_LICENSES_VERSION="main"

.PHONY: go-licenses-install
go-licenses-install:
ifeq ("go-licenses-install","$(MAKECMDGOALS)")
	$(GO_CMD) install $(ARGS) "github.com/google/go-licenses/v2@$(GO_LICENSES_VERSION)"
	$(GO_CMD) mod tidy
else
ifeq (,$(shell which $(GO_LICENSES_CMD) 2>/dev/null))
	$(GO_CMD) install $(ARGS) "github.com/google/go-licenses/v2@$(GO_LICENSES_VERSION)"
	$(GO_CMD) mod tidy
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: go-licenses-usage
go-licenses-usage:
	# Usage : make go-licenses ARGS=""
	# Exec  : $$(GO_LICENSES_CMD) $$(ARGS)
	# Desc  : Run go-licenses with given arguments.
	# Examples:
	#   - make go-licenses ARGS="--help"
	#   - make go-licenses ARGS="check --help"
	#   - make go-licenses ARGS="report --help"

.PHONY: go-licenses
go-licenses: go-licenses-install
	$(GO_LICENSES_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: go-licenses-run-usage
go-licenses-run-usage:
	# Usage : make go-licenses-run ARGS=""
	# Exec  : $$(GO_LICENSES_CMD) check $$(ARGS) $$(GO_LICENSES_OPTION_CHECK) $$(GO_LICENSES_TARGET)
	#         $$(GO_LICENSES_CMD) report $$(ARGS) $$(GO_LICENSES_OPTION_REPORT) $$(GO_LICENSES_TARGET) > $$(GO_LICENSES_OUTPUT)
	# Desc  : Check licenses.
	# Examples:
	#   - make go-licenses-run
	#   - make go-licenses-run ARGS=""

.PHONY: go-licenses-run
go-licenses-run: go-licenses-install
	$(GO_LICENSES_CMD) check $(ARGS) $(GO_LICENSES_OPTION_CHECK) $(GO_LICENSES_TARGET)
	@mkdir -p $(dir $(GO_LICENSES_OUTPUT))
	$(GO_LICENSES_CMD) report $(ARGS) $(GO_LICENSES_OPTION_REPORT) $(GO_LICENSES_TARGET) > $(GO_LICENSES_OUTPUT)
	@echo ================================================================================
	@cat $(GO_LICENSES_OUTPUT)
	@echo ================================================================================

#├─────────────────────────────────────────────────────────────────────────────┤
