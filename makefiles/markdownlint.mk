SHELL ?= /bin/bash -euo pipefail
define MARKDOWNLINT_HELP
REQUIREMENTS:
  - markdownlint : `markdownlint` command must be available.
  - npm          : `npm` command must be available for `markdownlint-install`.

TARGETS:
  - markdownlint-help    : show help message.
  - markdownlint-install : install markdownlint using `npm -g` command.
  - markdownlint         : run markdownlint command with given args.
  - markdownlint-run     : run lint.

VARIABLES [default value]:
  - MARKDOWNLINT_CMD     : markdownlint command. [markdownlint]
  - MARKDOWNLINT_VERSION : markdownlint version to install. [latest]
  - MARKDOWNLINT_TARGET  : target of lint. [./]
  - MARKDOWNLINT_OPTION  : markdownlint command line option. [--ignore _scripts/]

REFERENCES:
  - https://github.com/DavidAnson/markdownlint

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker
  - JetBrains : https://plugins.jetbrains.com/plugin/20851-markdownlint
  - Others?   : https://github.com/DavidAnson/markdownlint?tab=readme-ov-file#related

PROJECT STRUCTURE:
  /                         |-- Project
  ├─ _scripts/              |-- Git submodule
  │  └─ makefiles/          |
  │     └─ markdownlint.mk  |
  ├─ .markdownlint.yaml     |-- Config file
  └─ Makefile               |-- include _scripts/makefiles/markdownlint.mk
endef

.PHONY: markdownlint-help
markdownlint-help:
	$(info $(MARKDOWNLINT_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

MARKDOWNLINT_CMD ?= markdownlint
MARKDOWNLINT_VERSION ?= latest
MARKDOWNLINT_TARGET ?= ./
MARKDOWNLINT_OPTION ?= --ignore _scripts/

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: markdownlint-install-usage
markdownlint-install-usage:
	# Usage : make markdownlint-install ARGS=""
	# Exec  : npm install -g "markdownlint@$$(MARKDOWNLINT_VERSION)"
	#         npm install -g "markdownlint-cli@$$(MARKDOWNLINT_VERSION)"
	# Desc  : Install markdownlint using `npm -g`.
	# Examples:
	#   - make markdownlint-install
	#   - make markdownlint-install MARKDOWNLINT_VERSION="next"

.PHONY: markdownlint-install
markdownlint-install:
ifeq ("markdownlint-install","$(MAKECMDGOALS)")
	npm install -g "markdownlint@$(MARKDOWNLINT_VERSION)"
	npm install -g "markdownlint-cli@$(MARKDOWNLINT_VERSION)"
else
ifeq (,$(shell which $(MARKDOWNLINT_CMD) 2>/dev/null))
	npm install -g "markdownlint@$(MARKDOWNLINT_VERSION)"
	npm install -g "markdownlint-cli@$(MARKDOWNLINT_VERSION)"
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: markdownlint-usage
markdownlint-usage:
	# Usage : make markdownlint ARGS=""
	# Exec  : $$(MARKDOWNLINT_CMD) $$(ARGS)
	# Desc  : Run markdownlint with given arguments.
	# Examples:
	#   - make markdownlint ARGS="--version"
	#   - make markdownlint ARGS="--help"

.PHONY: markdownlint
markdownlint: markdownlint-install
	$(MARKDOWNLINT_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: markdownlint-run-usage
markdownlint-run-usage:
	# Usage : make markdownlint-run ARGS=""
	# Exec  : $$(MARKDOWNLINT_CMD) $$(MARKDOWNLINT_OPTION) $$(ARGS) $$(MARKDOWNLINT_TARGET)
	# Desc  : Run markdownlint for the specified targets.
	# Examples:
	#   - make markdownlint-run
	#   - make markdownlint-run ARGS="--quiet"

.PHONY: markdownlint-run
markdownlint-run: markdownlint-install
	$(MARKDOWNLINT_CMD) $(MARKDOWNLINT_OPTION) $(ARGS) $(MARKDOWNLINT_TARGET)

#├─────────────────────────────────────────────────────────────────────────────┤
