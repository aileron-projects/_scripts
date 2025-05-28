SHELL := /bin/bash -euo pipefail
define GRAPHVIZ_HELP
REQUIREMENTS:
  - graphviz : `graphviz` command must be available.

TARGETS:
  - graphviz-help : Show help message.
  - graphviz-png  : Export png image from graphviz file.
  - graphviz-svg  : Export svg image from graphviz file.
  - graphviz-pdf  : Export pdf image from graphviz file.

VARIABLES [default value]:
  - GRAPHVIZ_CMD        : graphviz command. [dot]
  - GRAPHVIZ_TARGET     : target files. [all *.dot in docs/]
  - GRAPHVIZ_OPTION_PNG : dot command line option for png. [-Gdpi=150]
  - GRAPHVIZ_OPTION_SVG : dot command line option for svg. []
  - GRAPHVIZ_OPTION_PDF : dot command line option for pdf. []

REFERENCES:
  - https://graphviz.org/
  - https://dreampuf.github.io/GraphvizOnline/
  - https://www.devtoolsdaily.com/graphviz/

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=EFanZh.graphviz-preview
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=tintinweb.graphviz-interactive-preview
  - JetBrains : https://plugins.jetbrains.com/plugin/10312-dot-language
  - Web       : https://dreampuf.github.io/GraphvizOnline/
  - Web       : https://magjac.com/graphviz-visual-editor/
  - Others?   : https://graphviz.org/resources/

PROJECT STRUCTURE:
  /                     |-- Project
	├─ docs/              |
  │  └─ *.dot           |-- Default targets
  ├─ _scripts/          |-- Git submodule
  │  └─ makefiles/      |
  │     └─ graphviz.mk  |
  └─ Makefile           |-- include _scripts/makefiles/graphviz.mk
endef

.PHONY: graphviz-help
graphviz-help:
	$(info $(GRAPHVIZ_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GRAPHVIZ_CMD ?= graphviz
GRAPHVIZ_TARGET ?= $(shell find ./docs/ -type f -name '*.dot' 2>/dev/null)
GRAPHVIZ_OPTION_PNG ?= -Gdpi=150
GRAPHVIZ_OPTION_SVG ?=
GRAPHVIZ_OPTION_PDF ?=

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: graphviz-png-usage
graphviz-png-usage:
	# Usage : make graphviz-png ARGS=""
	# Exec  : $$(GRAPHVIZ_CMD) $$(GRAPHVIZ_OPTION_PNG) $$(ARGS) -Tpng -o $$@
	# Desc  : Export *.dot as png image.
	# Examples:
	#   - make graphviz-png
	#   - make graphviz-png ARGS=""
	#   - make graphviz-png GRAPHVIZ_TARGET="./foo/*.dot"

.PHONY: graphviz-png
graphviz-png: $(GRAPHVIZ_TARGET:.dot=.png)
%.png: %.dot
	cat $< | $(GRAPHVIZ_CMD) $(GRAPHVIZ_OPTION_PNG) $(ARGS) -Tpng -o $@

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: graphviz-svg-usage
graphviz-svg-usage:
	# Usage : make graphviz-svg ARGS=""
	# Exec  : $$(GRAPHVIZ_CMD) $$(GRAPHVIZ_OPTION_SVG) $$(ARGS) -Tsvg -o $$@
	# Desc  : Export *.dot as svg image.
	# Examples:
	#   - make graphviz-svg
	#   - make graphviz-svg ARGS=""
	#   - make graphviz-svg GRAPHVIZ_TARGET="./foo/*.dot"

.PHONY: graphviz-svg
graphviz-svg: $(GRAPHVIZ_TARGET:.dot=.svg)
%.svg: %.dot
	cat $< | $(GRAPHVIZ_CMD) $(GRAPHVIZ_OPTION_SVG) $(ARGS) -Tsvg -o $@

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: graphviz-pdf-usage
graphviz-pdf-usage:
	# Usage : make graphviz-pdf ARGS=""
	# Exec  : $$(GRAPHVIZ_CMD) $$(GRAPHVIZ_OPTION_PDF) $$(ARGS) -Tpdf -o $$@
	# Desc  : Export *.dot as pdf image.
	# Examples:
	#   - make graphviz-pdf
	#   - make graphviz-pdf ARGS=""
	#   - make graphviz-pdf GRAPHVIZ_TARGET="./foo/*.dot"

.PHONY: graphviz-pdf
graphviz-pdf: $(GRAPHVIZ_TARGET:.dot=.pdf)
%.pdf: %.dot
	cat $< | $(GRAPHVIZ_CMD) $(GRAPHVIZ_OPTION_PDF) $(ARGS) -Tpdf -o $@

#├─────────────────────────────────────────────────────────────────────────────┤
