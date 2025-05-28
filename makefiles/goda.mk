SHELL := /bin/bash -euo pipefail
define GODA_HELP
REQUIREMENTS:
  - dot  : `dot` command (graphviz) must be available.
  - goda : `goda` command must be available.
  - go   : `go` command must be available for `goda-install`.

TARGETS:
  - goda-help      : show help message.
  - goda-install   : install goda.
  - goda           : run goda command with given args.
  - goda-run       : check licenses and generate licenses file.

VARIABLES [default value]:
  - GO_CMD       : go command used in goda-install. [go]
  - GODA_CMD     : goda command. [$$(GOBIN)goda]
  - GODA_VERSION : goda version to install. [latest]
  - GODA_TARGET  : target to generate graph. [./...]
  - GODA_OUTPUT  : graph output path. [_output/dependency-graph.ext]
  - GODA_OPTION  : goda command line option. []
  - GRAPHVIZ_CMD : graphviz command. [dot]

REFERENCES:
  - https://github.com/loov/goda
  - https://graphviz.org/
  - https://dreampuf.github.io/GraphvizOnline/
  - https://www.devtoolsdaily.com/graphviz/

IDE INTEGRATIONS:
  - none

PROJECT STRUCTURE:
  /                           |-- Go Project
  ├─ _output/                 |
  │  ├─ dependency-graph.dot  |-- Default dependency graph output file
  │  ├─ dependency-graph.svg  |-- Default dependency graph output file
  │  └─ dependency-graph.png  |-- Default dependency graph output file
  ├─ _scripts/                |-- Git submodule
  │  └─ makefiles/            |
  │     └─ goda.mk            |
  ├─ Makefile                 |-- include _scripts/makefiles/goda.mk
  ├─ go.mod                   |
  └─ go.sum                   |
endef

.PHONY: goda-help
goda-help:
	$(info $(GODA_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go
GODA_CMD ?= $(GOBIN)goda
GODA_VERSION ?= latest
GODA_TARGET ?= ./...
GODA_OUTPUT ?= _output/dependency-graph.dot
GODA_OPTION ?= 
GRAPHVIZ_CMD ?= dot

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: goda-install-usage
goda-install-usage:
	# Usage : make goda-install ARGS=""
	# Exec  : $$(GO_CMD) install $$(ARGS) "github.com/loov/goda@$$(GODA_VERSION)"
	# Desc  : Install goda using `go install`.
	# Examples:
	#   - make goda-install
	#   - make goda-install ARGS="-tags netgo"
	#   - make goda-install GODA_VERSION="main"

.PHONY: goda-install
goda-install:
ifeq ("goda-install","$(MAKECMDGOALS)")
	$(GO_CMD) install $(ARGS) "github.com/loov/goda@$(GODA_VERSION)"
	$(GO_CMD) mod tidy
else
ifeq (,$(shell which $(GODA_CMD) 2>/dev/null))
	$(GO_CMD) install $(ARGS) "github.com/loov/goda@$(GODA_VERSION)"
	$(GO_CMD) mod tidy
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: goda-usage
goda-usage:
	# Usage : make goda ARGS=""
	# Exec  : $$(GODA_CMD) $$(ARGS)
	# Desc  : Run goda with given arguments.
	# Examples:
	#   - make goda ARGS="--help"

.PHONY: goda
goda: goda-install
	$(GODA_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: goda-run-usage
goda-run-usage:
	# Usage : make goda-run ARGS=""
	# Exec  : $$(GODA_CMD) graph $$(GODA_OPTION) $$(ARGS) $$(GODA_TARGET) > $$(GODA_OUTPUT)
	# Desc  : Generate dependency graph.
	# Examples:
	#   - make goda-run
	#   - make goda-run ARGS=""

.PHONY: goda-run
goda-run: goda-install
	@mkdir -p $(dir $(GODA_OUTPUT))
	$(GODA_CMD) graph $(GODA_OPTION) $(ARGS) $(GODA_TARGET) > $(GODA_OUTPUT)
	sed -i 's/$(subst /,\/,$(shell go list -m)/)/.\//g' $(GODA_OUTPUT)
	cat $(GODA_OUTPUT) | $(GRAPHVIZ_CMD) -Tsvg -o $(GODA_OUTPUT:.dot=.svg)
	cat $(GODA_OUTPUT) | $(GRAPHVIZ_CMD) -Tpng -o $(GODA_OUTPUT:.dot=.png) -Gdpi=250

#├─────────────────────────────────────────────────────────────────────────────┤
