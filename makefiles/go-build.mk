SHELL := /bin/bash -euo pipefail
define GO_BUILD_HELP
REQUIREMENTS:
  - go : `go` command must be available.

TARGETS:
  - go-build-help  : show help message.
  - go-build       : build binary.

VARIABLES [default value]:
  - GO_CMD           : go command. [go]
  - GO_BUILD_TARGET  : go build target. [All ./cmd/* directories]
  - GO_BUILD_OUTPUT  : binary output directory. [_output/bin/$$(GOOS)-$$(GOARCH)/]
  - GO_BUILD_FLAGS   : go build flags [-trimpath]
  - GO_BUILD_TAGS    : tags passed to the -tags. [netgo,osusergo]
  - GO_BUILD_LDFLAGS : flags passed to the -ldflags. [-w -s -extldflags '-static']
  - GO_BUILD_GCFLAGS : flags passed to the -gcflags. []

REFERENCES:
  - https://pkg.go.dev/cmd/go
  - https://pkg.go.dev/go/build
  - https://pkg.go.dev/internal/platform
  - https://go.dev/wiki/#platform-specific-information

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=golang.go
  - JetBrains : https://plugins.jetbrains.com/plugin/9568-go
  - Others?   : https://go.dev/doc/editors
  - Others?   : https://go.dev/wiki/IDEsAndTextEditorPlugins

PROJECT STRUCTURE:
  /                     |-- Go project
  ├─ _output/           |
  │  └─ bin/            |-- Default binary output path 
  ├─ _scripts/          |-- Git submodule
  │  └─ makefiles/      |
  │     └─ go-build.mk  |
  ├─ cmd/               |-- Default lookup directory
  │  ├─ foo/            |
  │  └─ bar/            |
  ├─ Makefile           |-- include _scripts/makefiles/go-build.mk
  ├─ go.mod             |
  └─ go.sum             |
endef

.PHONY: go-build-help
go-build-help:
	$(info $(GO_BUILD_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go

export CGO_ENABLED ?= 0

export GOOS ?= $(shell $(GO_CMD) env GOOS)
ifeq ($(GOOS),)
GOOS = $(shell $(GO_CMD) env GOOS)
endif

export GOARCH ?= $(shell $(GO_CMD) env GOARCH)
ifeq ($(GOARCH),)
GOARCH = $(shell $(GO_CMD) env GOARCH)
endif

OS_ARCH := $(GOOS)-$(GOARCH)
ifeq ($(GOARCH),arm)
OS_ARCH := $(GOOS)-$(GOARCH)$(GOARM)
endif

GO_BUILD_TARGET ?= $(shell ls -d ./cmd/* 2>/dev/null)
GO_BUILD_OUTPUT ?= _output/bin/$(OS_ARCH)/
GO_BUILD_FLAGS ?= -trimpath
GO_BUILD_TAGS ?= netgo,osusergo
GO_BUILD_LDFLAGS ?= -w -s -extldflags '-static'
GO_BUILD_GCFLAGS ?=

#├─────────────────────────────────────────────────────────────────────────────┤

GO_BUILD_CMD := $(GO_CMD) build $(GO_BUILD_FLAGS)
GO_BUILD_CMD += -tags="$(GO_BUILD_TAGS)"
GO_BUILD_CMD += -ldflags="$(GO_BUILD_LDFLAGS)"
GO_BUILD_CMD += -gcflags="$(GO_BUILD_GCFLAGS)"
GO_BUILD_CMD += -o $(GO_BUILD_OUTPUT)

.PHONY: go-build-usage
go-build-usage:
	# Usage : make go-build ARGS=""
	# Exec  : $$(GO_CMD) build $$(GO_BUILD_FLAGS) -tags="$$(GO_BUILD_TAGS)" \
	#         -ldflags="$$(GO_BUILD_LDFLAGS)" -gcflags="$$(GO_BUILD_GCFLAGS)" \
	#         -o $$(GO_BUILD_OUTPUT) $$(ARGS) $$(GO_BUILD_TARGET)
	# Desc  : Build go binaries.
	# Examples:
	#   - make go-build
	#   - make go-build GO_BUILD_TARGET=./cmd/foo
	#   - make go-build GOOS=windows
	#   - make go-build GOOS=windows GOARCH=arm64
	#   - make go-build CGO_ENABLED=1 GOOS=windows GOARCH=arm64

.PHONY: go-build
go-build:
	$(info INFO: GOOS=$(GOOS) GOARCH=$(GOARCH) GOARM=$(GOARM) CGO_ENABLED=$(CGO_ENABLED))
	$(info INFO: Output binaries in $(GO_BUILD_OUTPUT))
	@for target in $(GO_BUILD_TARGET); do \
	echo "INFO: Building $$target"; \
	$(GO_BUILD_CMD) $(ARGS) $$target; \
	done

#├─────────────────────────────────────────────────────────────────────────────┤
