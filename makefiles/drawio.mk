SHELL ?= /bin/bash -euo pipefail

define DRAWIO_HELP
REQUIREMENTS:
  - drawio : `drawio` command must be available.

TARGETS:
  - drawio-help : show help message.
  - drawio-png  : convert *.drawio to *.png.
  - drawio-svg  : convert *.drawio to *.svg.
  - drawio-pdf  : convert *.drawio to *.pdf.

VARIABLES [default value]:
  - DRAWIO_CMD        : drawio command. [drawio]
  - DRAWIO_TARGET     : target files. [all *.drawio in docs/]
  - DRAWIO_OPTION_PNG : drawio command line option for png. []
  - DRAWIO_OPTION_SVG : drawio command line option for svg. []
  - DRAWIO_OPTION_PDF : drawio command line option for pdf. [--crop]

REFERENCES:
  - https://github.com/jgraph/drawio-desktop
  - https://www.drawio.com/

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio
  - JetBrains : https://plugins.jetbrains.com/plugin/15635-diagrams-net-integration
  - Web       : https://app.diagrams.net/
  - Others?   : https://www.drawio.com/integrations

PROJECT STRUCTURE:
  /                   |-- Project
	├─ docs/            |
  │  └─ *.drawio      |-- Default targets
  ├─ _scripts/        |-- Git submodule
  │  └─ makefiles/    |
  │     └─ drawio.mk  |
  └─ Makefile         |-- include _scripts/makefiles/drawio.mk
endef

.PHONY: drawio-help
drawio-help:
	$(info $(DRAWIO_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

DRAWIO_CMD ?= drawio
DRAWIO_TARGET ?= $(shell find ./docs/ -type f -name '*.drawio' 2>/dev/null)
DRAWIO_OPTION_PNG ?=
DRAWIO_OPTION_SVG ?=
DRAWIO_OPTION_PDF ?= --crop

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: drawio-png-usage
drawio-png-usage:
	# Usage : make drawio-png ARGS=""
	# Exec  : $$(DRAWIO_CMD) --export --format png $$(DRAWIO_OPTION_PNG) $$(ARGS) $<
	# Desc  : Export *.drawio as png image.
	# Examples:
	#   - make drawio-png
	#   - make drawio-png ARGS=""
	#   - make drawio-png DRAWIO_TARGET="./foo/*.drawio"

.PHONY: drawio-png
drawio-png: $(DRAWIO_TARGET:.drawio=.png)
%.png: %.drawio
	$(DRAWIO_CMD) --export --format png $(DRAWIO_OPTION_PNG) $(ARGS) $<

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: drawio-svg-usage
drawio-svg-usage:
	# Usage : make drawio-svg ARGS=""
	# Exec  : $$(DRAWIO_CMD) --export --format svg $$(DRAWIO_OPTION_SVG) $$(ARGS) $$<
	# Desc  : Export *.drawio as svg image.
	# Examples:
	#   - make drawio-svg
	#   - make drawio-svg ARGS=""
	#   - make drawio-svg DRAWIO_TARGET="./foo/*.drawio"

.PHONY: drawio-svg
drawio-svg: $(DRAWIO_TARGET:.drawio=.svg)
%.svg: %.drawio
	$(DRAWIO_CMD) --export --format svg $(DRAWIO_OPTION_SVG) $(ARGS) $<

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: drawio-pdf-usage
drawio-pdf-usage:
	# Usage : make drawio-pdf ARGS=""
	# Exec  : $$(DRAWIO_CMD) --export --format pdf $$(DRAWIO_OPTION_PDF) $$(ARGS) $$<
	# Desc  : Export *.drawio as pdf image.
	# Examples:
	#   - make drawio-pdf
	#   - make drawio-pdf ARGS=""
	#   - make drawio-pdf DRAWIO_TARGET="./foo/*.drawio"

.PHONY: drawio-pdf
drawio-pdf: $(DRAWIO_TARGET:.drawio=.pdf)
%.pdf: %.drawio
	$(DRAWIO_CMD) --export --format pdf $(DRAWIO_OPTION_PDF) $(ARGS) $<

#├─────────────────────────────────────────────────────────────────────────────┤
