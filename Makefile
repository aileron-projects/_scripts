SHELL := /bin/bash -euo pipefail

# Help is in util.mk
.DEFAULT_GOAL:=help

# Change tools install path.
# $(shell mkdir -p bin/)
# export GOBIN := $(CURDIR)/bin/

# Load local env.
# ifneq (,$(wildcard .env.mk))
#   include .env.mk
# endif
# ifneq (,$(wildcard .env))
#   include .env
# endif

include makefiles/adoc.mk
include makefiles/cspell.mk
include makefiles/drawio.mk
include makefiles/go-build.mk
include makefiles/go-licenses.mk
include makefiles/go-test.mk
include makefiles/go.mk
include makefiles/goda.mk
include makefiles/golangci-lint.mk
include makefiles/govulncheck.mk
include makefiles/graphviz.mk
include makefiles/markdownlint.mk
include makefiles/mermaid.mk
include makefiles/nfpm.mk
include makefiles/plantuml.mk
include makefiles/prettier.mk
include makefiles/scanoss.mk
include makefiles/shellcheck.mk
include makefiles/shfmt.mk
include makefiles/trivy.mk
include makefiles/util.mk

LOCAL_CHECKS += cspell-run
LOCAL_CHECKS += go-licenses-run
LOCAL_CHECKS += golangci-lint-run
LOCAL_CHECKS += markdownlint-run
LOCAL_CHECKS += prettier-run
LOCAL_CHECKS += shellcheck-run
LOCAL_CHECKS += shfmt-run

.PHONY: local-check
local-check: $(LOCAL_CHECKS)

.PHONY: local-format
local-format:
	$(MAKE) go-fmt ARGS="-w"
	$(MAKE) prettier-run ARGS="--write"
