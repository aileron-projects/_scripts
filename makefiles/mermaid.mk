SHELL := /bin/bash -euo pipefail

define MERMAID_HELP
REQUIREMENTS:
  - mermaid : `mmdc` command must be available.

TARGETS:
  - mermaid      : run mermaid command with given args.
  - mermaid-help : show help message.
  - mermaid-png  : convert *.mmd to *.png.
  - mermaid-svg  : convert *.mmd to *.svg.
  - mermaid-pdf  : convert *.mmd to *.pdf.

VARIABLES [default value]:
  - MERMAID_CMD        : mermaid command. [mmdc]
  - MERMAID_TARGET     : target files. [all *.mmd in docs/]
  - MERMAID_OPTION_PNG : mermaid command line option for png. [--scale 3]
  - MERMAID_OPTION_SVG : mermaid command line option for svg. []
  - MERMAID_OPTION_PDF : mermaid command line option for pdf. [--pdfFit]

REFERENCES:
  - https://mermaid.js.org/
  - https://github.com/mermaid-js/mermaid

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=MermaidChart.vscode-mermaid-chart
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=vstirbu.vscode-mermaid-preview
  - JetBrains : https://plugins.jetbrains.com/plugin/23043-mermaid-chart
  - Web       : https://mermaid.live/edit
  - Web       : https://www.mermaidflow.app/
  - Web       : https://mermaid-editor.kkeisuke.dev/
  - Others?   : https://docs.mermaidchart.com/plugins/intro

PROJECT STRUCTURE:
  /                    |-- Project
	├─ docs/             |
  │  └─ *.mmd          |-- Default targets
  ├─ _scripts/         |-- Git submodule
  │  └─ makefiles/     |
  │     └─ mermaid.mk  |
  └─ Makefile          |-- include _scripts/makefiles/mermaid.mk
endef

.PHONY: mermaid-help
mermaid-help:
	$(info $(MERMAID_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

MERMAID_CMD ?= mmdc
MERMAID_TARGET ?= $(shell find ./docs/ -type f -name '*.mmd' 2>/dev/null)
MERMAID_OPTION_PNG ?= --scale 3
MERMAID_OPTION_SVG ?=
MERMAID_OPTION_PDF ?= --pdfFit

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: mermaid-usage
mermaid-usage:
	# Usage : make mermaid ARGS=""
	# Exec  : $$(MERMAID_CMD) $$(ARGS)
	# Desc  : Run mermaid with given arguments.
	# Examples:
	#   - make mermaid ARGS="--version"
	#   - make mermaid ARGS="--help"

.PHONY: mermaid
mermaid:
	$(MERMAID_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: mermaid-png-usage
mermaid-png-usage:
	# Usage : make mermaid-png ARGS=""
	# Exec  : $$(MERMAID_CMD) $$(MERMAID_OPTION_PNG) $$(ARGS) -o $$@ -i $$<
	# Desc  : Export *.mmd as png image.
	# Examples:
	#   - make make mermaid-png
	#   - make make mermaid-png ARGS=""
	#   - make make mermaid-png MERMAID_TARGET="./foo/*.mmd"

.PHONY: mermaid-png
mermaid-png: $(MERMAID_TARGET:.mmd=.png)
%.png: %.mmd
	$(MERMAID_CMD) $(MERMAID_OPTION_PNG) $(ARGS) -o $@ -i $<

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: mermaid-svg-usage
mermaid-svg-usage:
	# Usage : make mermaid-svg ARGS=""
	# Exec  : $$(MERMAID_CMD) $$(MERMAID_OPTION_SVG) $$(ARGS) -o $$@ -i $$<
	# Desc  : Export *.mmd as svg image.
	# Examples:
	#   - make make mermaid-svg
	#   - make make mermaid-svg ARGS=""
	#   - make make mermaid-svg MERMAID_TARGET="./foo/*.mmd"

.PHONY: mermaid-svg
mermaid-svg: $(MERMAID_TARGET:.mmd=.svg)
%.svg: %.mmd
	$(MERMAID_CMD) $(MERMAID_OPTION_SVG) $(ARGS) -o $@ -i $<

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: mermaid-pdf-usage
mermaid-pdf-usage:
	# Usage : make mermaid-pdf ARGS=""
	# Exec  : $$(MERMAID_CMD) $$(MERMAID_OPTION_PDF) $$(ARGS) -o $$@ -i $$<
	# Desc  : Export *.mmd as pdf image.
	# Examples:
	#   - make make mermaid-pdf
	#   - make make mermaid-pdf ARGS=""
	#   - make make mermaid-pdf MERMAID_TARGET="./foo/*.mmd"

.PHONY: mermaid-pdf
mermaid-pdf: $(MERMAID_TARGET:.mmd=.pdf)
%.pdf: %.mmd
	$(MERMAID_CMD) $(MERMAID_OPTION_PDF) $(ARGS) -o $@ -i $<

#├─────────────────────────────────────────────────────────────────────────────┤
