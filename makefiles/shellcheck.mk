SHELL := /bin/bash -euo pipefail
define SHELLCHECK_HELP
REQUIREMENTS:
  - shellcheck : `shellcheck` command must be available.

TARGETS:
  - shellcheck-help : show help message.
  - shellcheck      : run shellcheck command with given args.
  - shellcheck-run  : run shellcheck.

VARIABLES [default value]:
  - SHELLCHECK_CMD     : shellcheck binary path. [shellcheck]
  - SHELLCHECK_TARGET  : target of spell check. [All *.sh files]
  - SHELLCHECK_OPTION  : shellcheck command line option. []

REFERENCES:
  - https://github.com/koalaman/shellcheck
  - https://www.shellcheck.net/
  - https://www.shellcheck.net/wiki/Directive#shellcheckrc-file

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck
  - JetBrains : https://plugins.jetbrains.com/plugin/13122-shell-script
  - JetBrains : https://plugins.jetbrains.com/plugin/10195-shellcheck

PROJECT STRUCTURE:
  /                       |-- Project
  ├─ _scripts/            |-- Git submodule
  │  └─ makefiles/        |
  │     └─ shellcheck.mk  |
  ├─ .shellcheckrc        |-- Config file
  └─ Makefile             |-- include _scripts/makefiles/shellcheck.mk
endef

.PHONY: shellcheck-help
shellcheck-help:
	$(info $(SHELLCHECK_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

SHELLCHECK_CMD ?= shellcheck
SHELLCHECK_TARGET ?= $(shell find . -type f -name '*.sh' 2>/dev/null)
SHELLCHECK_OPTION ?=

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: shellcheck-usage
shellcheck-usage:
	# Usage : make shellcheck ARGS=""
	# Exec  : $$(SHELLCHECK_CMD) $$(ARGS)
	# Desc  : Run shellcheck with given arguments.
	# Examples:
	#   - make shellcheck ARGS="--version"
	#   - make shellcheck ARGS="--help"

.PHONY: shellcheck
shellcheck:
	$(SHELLCHECK_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: shellcheck-run-usage
shellcheck-run-usage:
	# Usage : make shellcheck-run ARGS=""
	# Exec  : $$(SHELLCHECK_CMD) $$(ARGS) $$(SHELLCHECK_OPTION) $$(SHELLCHECK_TARGET)
	# Desc  : Run shellcheck for the specified target.
	# Examples:
	#   - make shellcheck-run
	#   - make shellcheck-run ARGS=""

.PHONY: shellcheck-run
shellcheck-run:
ifneq (,$(SHELLCHECK_TARGET))
	$(SHELLCHECK_CMD) $(ARGS) $(SHELLCHECK_OPTION) $(SHELLCHECK_TARGET)
endif

#├─────────────────────────────────────────────────────────────────────────────┤
