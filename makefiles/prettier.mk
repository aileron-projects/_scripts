SHELL ?= /bin/bash -euo pipefail

define PRETTIER_HELP
REQUIREMENTS:
  - prettier : `prettier` command must be available.
  - npm      : `npm` command must be available for `prettier-install`.

TARGETS:
  - prettier-help    : show help message.
  - prettier-install : install prettier using `npm -g`.
  - prettier         : run prettier command with given args.
  - prettier-run     : run prettier.

VARIABLES [default value]:
  - PRETTIER_CMD     : prettier binary path. [prettier]
  - PRETTIER_VERSION : prettier version to install. [latest]
  - PRETTIER_TARGET  : target of prettier. ["**/*.{md,yaml,yml,json,xml,toml,js,jsx,ts,html,css}"]
  - PRETTIER_OPTION  : prettier command line option. [--write]

REFERENCES:
  - https://prettier.io/
  - https://github.com/prettier/prettier
  - https://www.npmjs.com/package/prettier

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode
  - JetBrains : https://plugins.jetbrains.com/plugin/10456-prettier
  - Others?   : https://prettier.io/docs/editors

PROJECT STRUCTURE:
  /                     |-- Project
  ├─ _scripts/          |-- Git submodule
  │  └─ makefiles/      |
  │     └─ prettier.mk  |
  ├─ .prettierrc.yaml   |-- Config file
  └─ Makefile           |-- include _scripts/makefiles/prettier.mk
endef

.PHONY: prettier-help
prettier-help:
	$(info $(PRETTIER_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

PRETTIER_CMD ?= prettier
PRETTIER_VERSION ?= latest
PRETTIER_TARGET ?= "**/*.{md,yaml,yml,json,toml,js,jsx,ts,html,css}"
PRETTIER_OPTION ?= --check

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: prettier-install-usage
prettier-install-usage:
	# Usage : make prettier-install ARGS=""
	# Exec  : npm install -g "prettier@$$(PRETTIER_VERSION)"
	# Desc  : Install prettier using `npm -g`.
	# Examples:
	#   - make prettier-install
	#   - make prettier-install PRETTIER_VERSION="next"

.PHONY: prettier-install
prettier-install:
ifeq ("prettier-install","$(MAKECMDGOALS)")
	npm install -g "prettier@$(PRETTIER_VERSION)"
else
ifeq (,$(shell which $(PRETTIER_CMD) 2>/dev/null))
	npm install -g "prettier@$(PRETTIER_VERSION)"
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: prettier-usage
prettier-usage:
	# Usage : make prettier ARGS=""
	# Exec  : $$(PRETTIER_CMD) $$(ARGS)
	# Desc  : Run prettier with given arguments.
	# Examples:
	#   - make prettier ARGS="--version"
	#   - make prettier ARGS="--help"

.PHONY: prettier
prettier: prettier-install
	$(PRETTIER_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: prettier-run-usage
prettier-run-usage:
	# Usage : make prettier-run ARGS=""
	# Exec  : $$(PRETTIER_CMD) $$(ARGS) $$(PRETTIER_OPTION) $$(PRETTIER_TARGET)
	# Desc  : Run prettier for the specified targets.
	# Examples:
	#   - make prettier-run
	#   - make prettier-run ARGS="--write"

.PHONY: prettier-run
prettier-run: prettier-install
	$(PRETTIER_CMD) $(ARGS) $(PRETTIER_OPTION) $(PRETTIER_TARGET)

#├─────────────────────────────────────────────────────────────────────────────┤
