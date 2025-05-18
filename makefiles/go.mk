SHELL ?= /bin/bash -euo pipefail
define GO_HELP
REQUIREMENTS:
  - go : `go` command must be available.

TARGETS:
  - go-help        : show help message.
  - go             : run go command with given args.
  - go-vet         : run `go vet`.
  - go-fmt         : run `go fmt`.

VARIABLES [default value]:
  - GO_CMD         : go command. [go]
  - GOFMT_CMD      : go format command. [gofmt]
  - GO_VET_TARGET  : go vet target. [./...]
  - GO_VET_OPTION  : go vet command line option. []
  - GO_FMT_TARGET  : go fmt target. [./]
  - GO_FMT_OPTION  : go fmt command line option. [-l -e -s]

REFERENCES:
  - https://pkg.go.dev/cmd/vet
  - https://pkg.go.dev/cmd/gofmt
  - https://go.dev/blog/gofmt

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=golang.go
  - JetBrains : https://plugins.jetbrains.com/plugin/9568-go
  - Others?   : https://go.dev/doc/editors
  - Others?   : https://go.dev/wiki/IDEsAndTextEditorPlugins

PROJECT STRUCTURE:
  /                 |-- Go project
  ├─ _scripts/      |-- Git submodule
  │  └─ makefiles/  |
  │     └─ go.mk    |
  ├─ Makefile       |-- include _scripts/makefiles/go.mk
  ├─ go.mod         |
  └─ go.sum         |
endef

.PHONY: go-help
go-help:
	$(info $(GO_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go
GOFMT_CMD ?= gofmt
# go vet envs.
GO_VET_TARGET ?= ./...
GO_VET_OPTION ?=
# go fmt envs.
GO_FMT_TARGET ?= ./
GO_FMT_OPTION ?= -l -e -s

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: go-usage
go-usage:
	# Usage : make go ARGS=""
	# Exec  : $$(GO_CMD) $$(ARGS)
	# Desc  : Run go with given arguments.
	# Examples:
	#   - make go ARGS="version"
	#   - make go ARGS="help"

.PHONY: go
go:
	$(GO_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: go-vet-usage
go-vet-usage:
	# Usage : make go-vet ARGS=""
	# Exec  : $$(GO_CMD) vet $$(ARGS) $$(GO_VET_OPTION) $$(GO_VET_TARGET)
	# Desc  : Run go vet for the specified targets.
	#         Run `go tool vet help` or `go help vet` to show help.
	# Examples:
	#   - make go-vet
	#   - make go-vet ARGS=""

.PHONY: go-vet
go-vet:
	$(GO_CMD) vet $(ARGS) $(GO_VET_OPTION) $(GO_VET_TARGET)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: go-fmt-usage
go-fmt-usage:
	# Usage : make go-fmt ARGS=""
	# Exec  : $$(GOFMT_CMD) $$(ARGS) $$(GO_FMT_OPTION) $$(GO_FMT_TARGET)
	# Desc  : Run go fmt for the specified targets.
	#         Run `gofmt --help` to show help.
	# Examples:
	#   - make go-fmt
	#   - make go-fmt ARGS=""
	#   - make go-fmt ARGS="-w"

.PHONY: go-fmt
go-fmt:
	$(GOFMT_CMD) $(ARGS) $(GO_FMT_OPTION) $(GO_FMT_TARGET) > gofmt.tmp
	@cat gofmt.tmp 
	@if [ ! -s gofmt.tmp ]; then \
	rm -f gofmt.tmp; exit 0; \
	else \
	rm -f gofmt.tmp; exit 1; \
	fi

#├─────────────────────────────────────────────────────────────────────────────┤
