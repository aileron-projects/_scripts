SHELL ?= /bin/bash -euo pipefail

define PLANTUML_HELP
REQUIREMENTS:
  - plantuml : `plantuml` command must be available.

TARGETS:
  - plantuml-help : Show help message.
  - plantuml-png  : Export png image from plantuml file.
  - plantuml-svg  : Export svg image from plantuml file.
  - plantuml-pdf  : Export pdf image from plantuml file.

VARIABLES [default value]:
  - PLANTUML_CMD        : plantuml command. [plantuml]
  - PLANTUML_TARGET     : target files. [all *.puml in docs/]
  - PLANTUML_OPTION_PNG : plantuml command line option for png. []
  - PLANTUML_OPTION_SVG : plantuml command line option for svg. []
  - PLANTUML_OPTION_PDF : plantuml command line option for pdf. []

REFERENCES:
  - https://plantuml.com/

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=well-ar.plantuml
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=qhoekman.language-plantuml
  - JetBrains : https://plugins.jetbrains.com/plugin/7017-plantuml-integration
  - Web       : https://www.plantuml.com/
  - Web       : https://plantuml-editor.kkeisuke.com/
  - Web       : https://sujoyu.github.io/plantuml-previewer/
  - Others?   : https://plantuml.com/starting

PROJECT STRUCTURE:
  /                     |-- Project
	├─ docs/              |
  │  └─ *.puml          |-- Default targets
  ├─ _scripts/          |-- Git submodule
  │  └─ makefiles/      |
  │     └─ plantuml.mk  |
  └─ Makefile           |-- include _scripts/makefiles/plantuml.mk
endef

.PHONY: plantuml-help
plantuml-help:
	$(info $(PLANTUML_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

PLANTUML_CMD ?= plantuml
PLANTUML_TARGET ?= $(shell find ./docs/ -type f -name '*.puml' 2>/dev/null)
PLANTUML_OPTION_PNG ?=
PLANTUML_OPTION_SVG ?=
PLANTUML_OPTION_PDF ?=

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: plantuml-png-usage
plantuml-png-usage:
	# Usage : make plantuml-png ARGS=""
	# Exec  : $$(PLANTUML_CMD) $$(PLANTUML_OPTION_PNG) $$(ARGS) -tpng $$<
	# Desc  : Export *.puml as png image.
	# Examples:
	#   - make plantuml-png
	#   - make plantuml-png ARGS="-o outdir/"
	#   - make plantuml-png PLANTUML_TARGET="$(ls ./foo/*.puml)"

.PHONY: plantuml-png
plantuml-png: $(PLANTUML_TARGET:.puml=.png)
%.png: %.puml
	$(PLANTUML_CMD) $(PLANTUML_OPTION_PNG) $(ARGS) -tpng $<

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: plantuml-svg-usage
plantuml-svg-usage:
	# Usage : make plantuml-svg ARGS=""
	# Exec  : $$(PLANTUML_CMD) $$(PLANTUML_OPTION_SVG) $$(ARGS) -tsvg $$<
	# Desc  : Export *.puml as svg image.
	# Examples:
	#   - make plantuml-svg
	#   - make plantuml-svg ARGS="-o outdir/"
	#   - make plantuml-svg PLANTUML_TARGET="$(ls ./foo/*.puml)"

.PHONY: plantuml-svg
plantuml-svg: $(PLANTUML_TARGET:.puml=.svg)
%.svg: %.puml
	$(PLANTUML_CMD) $(PLANTUML_OPTION_SVG) $(ARGS) -tsvg  $<

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: plantuml-pdf-usage
plantuml-pdf-usage:
	# Usage : make plantuml-pdf ARGS=""
	# Exec  : $$(PLANTUML_CMD) $$(PLANTUML_OPTION_PDF) $$(ARGS) -tpdf $$<
	# Desc  : Export *.puml as pdf image.
	# Examples:
	#   - make plantuml-pdf
	#   - make plantuml-pdf ARGS="-o outdir/"
	#   - make plantuml-pdf PLANTUML_TARGET="$(ls ./foo/*.puml)"

.PHONY: plantuml-pdf
plantuml-pdf: $(PLANTUML_TARGET:.puml=.pdf)
%.pdf: %.puml
	$(PLANTUML_CMD) $(PLANTUML_OPTION_PDF) $(ARGS) -tpdf $<

#├─────────────────────────────────────────────────────────────────────────────┤
