SHELL ?= /bin/bash -euo pipefail
define ADOC_HELP
REQUIREMENTS:
  - asciidoctor       : `asciidoctor` is required for the `asciidoc-html`.
  - asciidoctor-pdf   : `asciidoctor-pdf` is required for the `asciidoc-pdf`.
  - asciidoctor-epub3 : `asciidoctor-epub3` is required for the `asciidoc-epub`.

TARGETS:
  - adoc-help      : Show help message.
  - adoc-html      : Export *.html from *.adoc.
  - adoc-pdf       : Export *.pdf from *.adoc.
  - adoc-epub      : Export *.epub from *.adoc.

VARIABLES [default value]:
  - ADOC_CMD          : asciidoctor command. [asciidoctor]
  - ADOC_CMD_PDF      : asciidoctor-pdf command. [asciidoctor-pdf]
  - ADOC_CMD_EPUB     : asciidoctor-epub3 command. [asciidoctor-epub3]
  - ADOC_TARGET       : target ascii docs. [all docs/*.adoc files]
  - ADOC_ATTRS_COMMON : common attribute options. [See the adoc.mk]
  - ADOC_ATTRS_HTML   : attribute option for html. [source-highlighter=highlight.js diagram-format=svg mathematical-format=svg data-uri]
  - ADOC_ATTRS_PDF    : attribute option for pdf. [source-highlighter=rouge diagram-format=png mathematical-format=svg]
  - ADOC_ATTRS_EPUB   : attribute option for epub. [source-highlighter=coderay diagram-format=png mathematical-format=png]
  - ADOC_REQS_COMMON  : common require options. [asciidoctor-diagram asciidoctor-lists]
  - ADOC_REQS_HTML    : require option for html. []
  - ADOC_REQS_PDF     : require option for pdf. [asciidoctor-mathematical]
  - ADOC_REQS_EPUB    : require option for epub. [asciidoctor-mathematical]

REFERENCES:
  - https://asciidoc.org/
	- https://asciidoctor.org/
	- https://asciidoctor.org/docs/extensions/

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=asciidoctor.asciidoctor-vscode
  - JetBrains : https://plugins.jetbrains.com/plugin/7391-asciidoc
  - Others?   : https://docs.asciidoctor.org/asciidoctor/latest/tooling/

PROJECT STRUCTURE:
  /                 |-- Project
  ├─ docs/          |
  │  └─ *.adoc      |-- Default targets
  ├─ _scripts/      |-- Git submodule
  │  └─ makefiles/  |
  │     └─ adoc.mk  |
  └─ Makefile       |-- include _scripts/makefiles/adoc.mk
endef

.PHONY: adoc-help
adoc-help:
	$(info $(ADOC_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

ADOC_CMD ?= asciidoctor
ADOC_CMD_PDF ?= asciidoctor-pdf
ADOC_CMD_EPUB ?= asciidoctor-epub3
ADOC_TARGET ?= $(shell find ./docs/ -maxdepth 1 -type f -name '*.adoc' 2>/dev/null)

ADOC_ATTRS_COMMON ?= \
	company=AILERON \
	doctype=book \
	compress \
	optimize \
	experimental \
	reproducible \
	toc=left \
	toclevels=4 \
	sectnums \
	sectlinks \
	sectanchors \
	stem=asciimath \
	imagesoutdir=.asciidoctor/

ADOC_REQS_COMMON ?= \
	asciidoctor-diagram \
	asciidoctor-lists

ADOC_ATTRS_HTML ?= source-highlighter=highlight.js diagram-format=svg mathematical-format=svg data-uri
ADOC_REQS_HTML ?=
ADOC_ATTRS_PDF ?= source-highlighter=rouge diagram-format=png mathematical-format=svg
ADOC_REQS_PDF ?= asciidoctor-mathematical
ADOC_ATTRS_EPUB ?= source-highlighter=coderay diagram-format=png mathematical-format=png
ADOC_REQS_EPUB ?= asciidoctor-mathematical

ADOC_ATTRS_HTML := $(addprefix --attribute=,$(ADOC_ATTRS_COMMON) $(ADOC_ATTRS_HTML))
ADOC_REQS_HTML := $(addprefix --require=,$(ADOC_REQS_COMMON) $(ADOC_REQS_HTML))
ADOC_ATTRS_PDF := $(addprefix --attribute=,$(ADOC_ATTRS_COMMON) $(ADOC_ATTRS_PDF))
ADOC_REQS_PDF := $(addprefix --require=,$(ADOC_REQS_COMMON) $(ADOC_REQS_PDF))
ADOC_ATTRS_EPUB := $(addprefix --attribute=,$(ADOC_ATTRS_COMMON) $(ADOC_ATTRS_EPUB))
ADOC_REQS_EPUB := $(addprefix --require=,$(ADOC_REQS_COMMON) $(ADOC_REQS_EPUB))

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: adoc-html-usage
adoc-html-usage:
	# Usage : make adoc-html ARGS=""
	# Exec  : $$(ADOC_CMD) $$(ADOC_ATTRS_HTML) $$(ADOC_REQS_HTML) $$(ARGS) $$<
	# Desc  : Export *.html from asciidoc.
	# Examples:
	#   - make adoc-html
	#   - make adoc-html ADOC_TARGET="$(ls ./foo/*.adoc)"

.PHONY: adoc-html
adoc-html: $(ADOC_TARGET:.adoc=.html)
%.html: %.adoc
	$(ADOC_CMD) $(ADOC_ATTRS_HTML) $(ADOC_REQS_HTML) $(ARGS) $<

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: adoc-pdf-usage
adoc-pdf-usage:
	# Usage : make adoc-pdf ARGS=""
	# Exec  : $$(ADOC_CMD_PDF) $$(ADOC_ATTRS_PDF) $$(ADOC_REQS_PDF) $$(ARGS) $$<
	# Desc  : Export *.pdf from asciidoc.
	# Examples:
	#   - make adoc-pdf
	#   - make adoc-pdf ADOC_TARGET="$(ls ./foo/*.adoc)"

.PHONY: adoc-pdf
adoc-pdf: $(ADOC_TARGET:.adoc=.pdf)
%.pdf: %.adoc
	$(ADOC_CMD_PDF) $(ADOC_ATTRS_PDF) $(ADOC_REQS_PDF) $(ARGS) $<

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: adoc-epub-usage
adoc-epub-usage:
	# Usage : make adoc-epub ARGS=""
	# Exec  : $$(ADOC_CMD_EPUB) $$(ADOC_ATTRS_EPUB) $$(ADOC_REQS_EPUB) $$(ARGS) $$<
	# Desc  : Export *.epub from asciidoc.
	# Examples:
	#   - make adoc-epub
	#   - make adoc-epub ADOC_TARGET="$(ls ./foo/*.adoc)"

.PHONY: adoc-epub
adoc-epub: $(ADOC_TARGET:.adoc=.epub)
%.epub: %.adoc
	$(ADOC_CMD_EPUB) $(ADOC_ATTRS_EPUB) $(ADOC_REQS_EPUB) $(ARGS) $<

#├─────────────────────────────────────────────────────────────────────────────┤
