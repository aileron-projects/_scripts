SHELL := /bin/bash -euo pipefail
define GO_TEST_HELP
REQUIREMENTS:
  - go              : `go` command must be available.
  - qemu            : QEMU User space emulator must be available for `go-test-qemu` target.
  - go-junit-report : `go-junit-report` command must be available for `go-test` target.

TARGETS:
  - go-test-help   : show help message.
  - go-test        : run go test.
  - go-test-bin    : generate test binary.
  - go-test-qemu   : run go test using qemu emulator.

VARIABLES [default value]:
  - GO_CMD           : go command. [go]
  - GO_JUNIT_CMD     : go-junit-report command. [$$(GOBIN)go-junit-report]
  - GO_JUNIT_VERSION : go-junit-report version to install. [latest]
  - GO_TEST_TARGET   : go test target. [./...]
  - GO_TEST_FLAGS    : go test flags [-v -cover -covermode=atomic]
  - GO_TEST_TAGS     : tags passed to the -tags. []
  - GO_TEST_COVERAGE : coverage profile output path. [_output/coverage.txt]

REFERENCES:
  - https://pkg.go.dev/cmd/go
  - https://pkg.go.dev/cmd/go/internal/test
	- https://pkg.go.dev/internal/platform
  - https://www.qemu.org/docs/master/user/main.html

IDE INTEGRATIONS:
  - VSCode    : https://marketplace.visualstudio.com/items?itemName=golang.go
  - JetBrains : https://plugins.jetbrains.com/plugin/9568-go
  - Others?   : https://go.dev/doc/editors
  - Others?   : https://go.dev/wiki/IDEsAndTextEditorPlugins

PROJECT STRUCTURE:
  /                        |-- Go project
  ├─ _output/              |
  │  ├─ coverage.xml       |-- Default coverage output (by go-junit-report)
  │  ├─ coverage.html      |-- Default coverage output
  │  ├─ coverage.txt       |-- Default coverage output
  │  └─ coverage.func.txt  |-- Default coverage output
  ├─ _scripts/             |-- Git submodule
  │  └─ makefiles/         |
  │     └─ go-test.mk      |
  ├─ Makefile              |-- include _scripts/makefiles/go-test.mk
  ├─ go.mod                |
  └─ go.sum                |
endef

.PHONY: go-test-help
go-test-help:
	$(info $(GO_TEST_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go
GO_JUNIT_CMD ?=$(GOBIN)go-junit-report
GO_JUNIT_VERSION ?= latest

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

GO_TEST_TARGET ?= ./...
GO_TEST_FLAGS ?= -v -cover -covermode=atomic
GO_TEST_TAGS ?=
GO_TEST_COVERAGE ?= _output/coverage.txt

QEMU_TARGET := $(shell go list -f '{{.Dir}}' $(GO_TEST_TARGET))
qemu_cmd_386 := qemu-i386
qemu_cmd_amd64 := qemu-x86_64
qemu_cmd_arm := qemu-arm
qemu_cmd_arm64 := qemu-aarch64
qemu_cmd_loong64 := qemu-loong64
qemu_cmd_mips := qemu-mips
qemu_cmd_mips64 := qemu-mips64
qemu_cmd_mips64le := qemu-mips64el
qemu_cmd_mipsle := qemu-mipsel
qemu_cmd_ppc64 := qemu-ppc64
qemu_cmd_ppc64le := qemu-ppc64le
qemu_cmd_riscv64 := qemu-riscv64
qemu_cmd_s390x := qemu-s390x
qemu_cmd_sparc64 := qemu-sparc64

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: go-test-install-usage
go-test-install-usage:
	# Usage : make go-test-install ARGS=""
	# Exec  : $$(GO_CMD) install $$(ARGS) "github.com/jstemmer/go-junit-report/v2@$$(GO_JUNIT_VERSION)"
	# Desc  : Install go-junit-report using `go install`.
	# Examples:
	#   - make go-test-install
	#   - make go-test-install ARGS="-tags netgo"
	#   - make go-test-install GO_JUNIT_VERSION="main"

.PHONY: go-test-install
go-test-install:
ifeq ("go-test-install","$(MAKECMDGOALS)")
	$(GO_CMD) install $(ARGS) "github.com/jstemmer/go-junit-report/v2@$(GO_JUNIT_VERSION)"
	$(GO_CMD) mod tidy
else
ifeq (,$(shell which $(GO_JUNIT_CMD) 2>/dev/null))
	$(GO_CMD) install $(ARGS) "github.com/jstemmer/go-junit-report/v2@$(GO_JUNIT_VERSION)"
	$(GO_CMD) mod tidy
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

GO_TEST_CMD := $(GO_CMD) test $(GO_TEST_FLAGS)
GO_TEST_CMD += -tags="$(GO_TEST_TAGS)"
GO_TEST_CMD += -coverprofile=$(GO_TEST_COVERAGE)

.PHONY: go-test-usage
go-test-usage:
	# Usage : make go-test ARGS=""
	# Exec  : $$(GO_CMD) test $$(GO_TEST_FLAGS) -tags="$$(GO_TEST_TAGS)" \
	#         -coverprofile=$$(GO_TEST_COVERAGE) $$(ARGS) $$(GO_TEST_TARGET)
	# Desc  : Test go packages.
	# Examples:
	#   - make go-test
	#   - make go-test GO_TEST_TARGET=./foo/...
	#   - make go-test GO_TEST_TAGS="integration"

.PHONY: go-test
go-test: go-test-install
	$(info INFO: GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=$(CGO_ENABLED))
	@mkdir -p $(dir $(GO_TEST_COVERAGE))
	@for target in $(GO_TEST_TARGET); do \
	echo ""; \
	echo "INFO: Testing $$target"; \
	$(GO_TEST_CMD) $(ARGS) $$target 2>&1 | tee go-test.tmp; \
	done
ifneq ($(GO_TEST_COVERAGE),)
	@cat go-test.tmp | $(GO_JUNIT_CMD) -set-exit-code -out $(basename $(GO_TEST_COVERAGE)).xml
	@$(GO_CMD) tool cover -html=$(GO_TEST_COVERAGE) -o $(basename $(GO_TEST_COVERAGE)).html
	@$(GO_CMD) tool cover -func=$(GO_TEST_COVERAGE) -o $(basename $(GO_TEST_COVERAGE)).func.txt
	@echo ================================================================================
	@cat $(basename $(GO_TEST_COVERAGE)).func.txt
	@echo ================================================================================
endif
	@rm -f go-test.tmp

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: go-test-qemu-usage
go-test-qemu-usage:
	# Usage : make go-test-qemu ARGS=""
	# Exec  : -
	# Desc  :  Test go packages using QEMU user space emulator.
	# Examples:
	#   - make go-test-qemu
	#   - make go-test-qemu GO_TEST_TARGET=./foo/...
	#   - make go-test-qemu GOARCH=arm64
	#   - make go-test-qemu GO_TEST_TAGS="integration"
	# Notes:
	#   Make sure "qemu-user" is installed.
	#   "qemu-user" is only available on linux.
	#   For example, run << sudo apt-get -y update & sudo apt-get install -y qemu-user >>
.PHONY: go-test-qemu
go-test-qemu:
	$(info INFO: GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=$(CGO_ENABLED))
	@for target in $(QEMU_TARGET); do \
	echo ""; \
	echo "INFO: Testing $$target"; \
	$(GO_TEST_CMD) $(ARGS) -c -o $$target $$target; \
	cd $$target && test -n *.test && test -f *.test && $(qemu_cmd_$(GOARCH)) *.test; \
	rm -f *.test; \
	done

#├─────────────────────────────────────────────────────────────────────────────┤
