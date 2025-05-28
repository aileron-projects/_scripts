SHELL := /bin/bash -euo pipefail
define TRIVY_HELP
REQUIREMENTS:
  - trivy : `trivy` command must be available.
  - go    : `go` command must be available for `trivy-install`.

TARGETS:
  - trivy-help     : show help message.
  - trivy          : run trivy command with given args.
  - trivy-install  : install trivy using `go install`.
  - trivy-sbom     : generate sbom.

VARIABLES [default value]:
  - GO_CMD            : go command used in trivy-install. [go]
  - TRIVY_CMD         : trivy command. [$$(GOBIN)trivy]
  - TRIVY_VERSION     : trivy version to install. [latest]
  - TRIVY_SBOM_TARGET : sbom target modules. [./]
  - TRIVY_SBOM_OPTION : sbom command line option. [--license-full]
  - TRIVY_SBOM_FORMAT : sbom output format. [cyclonedx]
  - TRIVY_SBOM_OUTPUT : sbom output file path. [_output/sbom.json]

REFERENCES:
  - https://github.com/aquasecurity/trivy
  - https://trivy.dev/latest/docs/target/filesystem/

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=AquaSecurityOfficial.trivy-official
  - JetBrains : https://plugins.jetbrains.com/plugin/18690-trivy-findings-explorer
  - Others?   : https://trivy.dev/latest/ecosystem/ide/

PROJECT STRUCTURE:
  /                  |-- Project
  ├─ _output/        |
  │  └─ sbom.json    |-- Default sbom output file
  ├─ _scripts/       |-- Git submodule
  │  └─ makefiles/   |
  │     └─ trivy.mk  |
  └─ Makefile        |-- include _scripts/makefiles/trivy.mk
endef

.PHONY: trivy-help
trivy-help:
	$(info $(TRIVY_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go
TRIVY_CMD ?= $(GOBIN)trivy
TRIVY_VERSION ?= latest
TRIVY_SBOM_TARGET ?= ./
TRIVY_SBOM_OPTION ?= --license-full
TRIVY_SBOM_FORMAT ?= cyclonedx
TRIVY_SBOM_OUTPUT ?= _output/sbom.json

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: trivy-install-usage
trivy-install-usage:
	# Usage : make trivy-install ARGS=""
	# Exec  : $$(GO_CMD) install $$(ARGS) "github.com/aquasecurity/trivy/cmd/trivy@$$(TRIVY_VERSION)"
	# Desc  : Install trivy using `go install`.
	# Examples:
	#   - make trivy-install
	#   - make trivy-install ARGS="-tags netgo"
	#   - make trivy-install TRIVY_VERSION="main"

.PHONY: trivy-install
trivy-install:
ifeq ("trivy-install","$(MAKECMDGOALS)")
	$(GO_CMD) install $(ARGS) "github.com/aquasecurity/trivy/cmd/trivy@$(TRIVY_VERSION)"
	$(GO_CMD) mod tidy
else
ifeq (,$(shell which $(TRIVY_CMD) 2>/dev/null))
	$(GO_CMD) install $(ARGS) "github.com/aquasecurity/trivy/cmd/trivy@$(TRIVY_VERSION)"
	$(GO_CMD) mod tidy
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: trivy-usage
trivy-usage:
	# Usage : make trivy ARGS=""
	# Exec  : $$(TRIVY_CMD) $$(ARGS)
	# Desc  : Run trivy with given arguments.
	# Examples:
	#   - make trivy ARGS="--version"
	#   - make trivy ARGS="--help"
	#   - make trivy ARGS="filesystem --help"

.PHONY: trivy
trivy: trivy-install
	$(TRIVY_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: trivy-sbom-usage
trivy-sbom-usage:
	# Usage : make trivy-sbom ARGS=""
	# Exec  : $$(TRIVY_CMD) filesystem -f $$(TRIVY_SBOM_FORMAT) -o $$(TRIVY_SBOM_OUTPUT) \
	#         $$(ARGS) $$(TRIVY_SBOM_OPTION) $$(TRIVY_SBOM_TARGET)
	# Desc  : Generate filesystem sbom.
	# Examples:
	#   - make trivy-sbom
	#   - make trivy-sbom ARGS="--scanners vuln"

.PHONY: trivy-sbom
trivy-sbom: trivy-install
	@mkdir -p $(dir $(TRIVY_SBOM_OUTPUT))
	$(TRIVY_CMD) filesystem -f $(TRIVY_SBOM_FORMAT) -o $(TRIVY_SBOM_OUTPUT) \
	$(ARGS) $(TRIVY_SBOM_OPTION) $(TRIVY_SBOM_TARGET)

#├─────────────────────────────────────────────────────────────────────────────┤
