SHELL ?= /bin/bash
define SCANOSS_HELP
REQUIREMENTS:
  - scanoss-py : `scanoss-py` command must be available.
  - pip        : `pip` command must be available for `scanoss-install`.

TARGETS:
  - scanoss-help    : show help message.
  - scanoss-install : install scanoss using `pip install`.
  - scanoss         : run scanoss command with given args.
  - scanoss-run     : run scanning.

VARIABLES [default value]:
  - SCANOSS_CMD            : scanoss command. [scanoss-py]
  - SCANOSS_TARGET         : target of scanning. [./]
  - SCANOSS_OUTPUT         : scan result ouput file. [_output/scanoss.json]
  - SCANOSS_OPTION_SCAN    : scanoss-py scan command line option. [--no-wfp-output]
  - SCANOSS_OPTION_INSPECT : scanoss-py inspect command line option. [copyleft]

REFERENCES:
  - https://github.com/scanoss/scanoss.py
  - https://github.com/scanoss/scanoss.py/blob/main/PACKAGE.md

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=SCANOSS.scanoss-extension-vscode

PROJECT STRUCTURE:
  /                    |-- Project
  ├─ _output/          |
  │  └─ scanoss.json   |-- Default scan result file 
  ├─ _scripts/         |-- Git submodule
  │  └─ makefiles/     |
  │     └─ scanoss.mk  |
  └─ Makefile          |-- include _scripts/makefiles/scanoss.mk
endef

.PHONY: scanoss-help
scanoss-help:
	$(info $(SCANOSS_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

SCANOSS_CMD ?= scanoss-py
SCANOSS_TARGET ?= ./
SCANOSS_OUTPUT ?= _output/scanoss.json
SCANOSS_OPTION_SCAN ?= --no-wfp-output
SCANOSS_OPTION_INSPECT ?= copyleft 

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: scanoss-install-usage
scanoss-install-usage:
	# Usage : make scanoss-install ARGS=""
	# Exec  : pip install scanoss[fast_winnowing]
	# Desc  : Install scanoss using `pip install`.
	# Examples:
	#   - make scanoss-install
	#   - make scanoss-install ARGS=""

.PHONY: scanoss-install
scanoss-install:
ifeq ("scanoss-install","$(MAKECMDGOALS)")
	pip install scanoss[fast_winnowing]
  # pip install scancode-toolkit
else
ifeq (,$(shell which $(SCANOSS_CMD) 2>/dev/null))
	pip install scanoss[fast_winnowing]
  # pip install scancode-toolkit
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: scanoss-usage
scanoss-usage:
	# Usage : make scanoss ARGS=""
	# Exec  : $$(SCANOSS_CMD) $$(ARGS)
	# Desc  : Run scanoss with given arguments.
	# Examples:
	#   - make scanoss ARGS="--version"
	#   - make scanoss ARGS="--help"

.PHONY: scanoss
scanoss: scanoss-install
	$(SCANOSS_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: scanoss-run-usage
scanoss-run-usage:
	# Usage : make scanoss-run ARGS=""
	# Exec  : $$(SCANOSS_CMD) scan $$(ARGS) $$(SCANOSS_OPTION_SCAN) -o $$(SCANOSS_OUTPUT) $$(SCANOSS_TARGET)
	#         $$(SCANOSS_CMD) inspect $$(SCANOSS_OPTION_INSPECT)  -i $$(SCANOSS_OUTPUT) -q | grep "{}"
	# Desc  : Run scanning license.
	# Examples:
	#   - make scanoss-run
	#   - make scanoss-run ARGS=""

.PHONY: scanoss-run
scanoss-run: scanoss-install
	mkdir -p $(dir $(SCANOSS_OUTPUT))
	$(SCANOSS_CMD) scan $(ARGS) $(SCANOSS_OPTION_SCAN) -o $(SCANOSS_OUTPUT) $(SCANOSS_TARGET)
	$(SCANOSS_CMD) inspect $(SCANOSS_OPTION_INSPECT) -i $(SCANOSS_OUTPUT) -q -o scanoss.tmp || true
	@if cat scanoss.tmp | grep "{}"; then \
	rm -f scanoss.tmp; exit 0; \
	else \
	rm -f scanoss.tmp; exit 1; \
	fi

#├─────────────────────────────────────────────────────────────────────────────┤
