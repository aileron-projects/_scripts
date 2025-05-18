SHELL ?= /bin/bash -euo pipefail
define NFPM_HELP
REQUIREMENTS:
  - nfpm : `nfpm` command must be available.
  - go    : `go` command must be available for `nfpm-install`.

TARGETS:
  - nfpm-help      : show help message.
  - nfpm           : run nfpm command with given args.
  - nfpm-install   : install nfpm using `go install`.
  - nfpm-rpm       : create rpm packages.
  - nfpm-deb       : create deb packages.
  - nfpm-apk       : create apk packages.
  - nfpm-arch      : create archlinux packages.

VARIABLES [default value]:
  - GO_CMD         : go command used in nfpm-install. [go]
  - NFPM_CMD       : nfpm command. [$$(GOBIN)nfpm]
  - NFPM_VERSION   : nfpm version to install. [latest]
  - NFPM_OPTION    : nfpm command line option. []
  - NFPM_OUTPUT    : package output directory. [./_output/pkg/]
  - NFPM_RPM_ARCH  : rpm target architecture. [386 amd64 arm arm5 arm6 arm7 arm64 ppc64le riscv64 s390x]
  - NFPM_DEB_ARCH  : deb target architecture. [386 amd64 arm arm5 arm6 arm7 arm64 ppc64le riscv64 s390x]
  - NFPM_APK_ARCH  : apk target architecture. [386 amd64 arm arm5 arm6 arm7 arm64 ppc64le riscv64 s390x]
  - NFPM_ARCH_ARCH : archlinux target architecture. [amd64 arm arm5 arm6 arm7 arm64 riscv64]

REFERENCES:
  - https://github.com/goreleaser/nfpm
  - https://nfpm.goreleaser.com/

IDE INTEGRATIONS:
  - none

PROJECT STRUCTURE:
  /                 |-- Project
  ├─ _output/       |
  │  └─ pkg/*       |-- Default package output path 
  ├─ _scripts/      |-- Git submodule
  │  └─ makefiles/  |
  │     └─ nfpm.mk  |
  ├─ Makefile       |-- include _scripts/makefiles/nfpm.mk
  ├─ nfpm.yaml      |-- Config file
  ├─ go.mod         |
  └─ go.sum         |
endef

.PHONY: nfpm-help
nfpm-help:
	$(info $(NFPM_HELP))
	@echo ""

#├─────────────────────────────────────────────────────────────────────────────┤

GO_CMD ?= go
NFPM_CMD ?= $(GOBIN)nfpm
NFPM_VERSION ?= latest
NFPM_OPTION ?=
NFPM_OUTPUT ?= ./_output/pkg/
NFPM_RPM_ARCH ?= 386 amd64 arm arm5 arm6 arm7 arm64 ppc64le riscv64 s390x
NFPM_DEB_ARCH ?= 386 amd64 arm arm5 arm6 arm7 arm64 ppc64le riscv64 s390x
NFPM_APK_ARCH ?= 386 amd64 arm arm5 arm6 arm7 arm64 ppc64le riscv64 s390x
NFPM_ARCH_ARCH ?= amd64 arm arm5 arm6 arm7 arm64 riscv64

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: nfpm-install-usage
nfpm-install-usage:
	# Usage : make nfpm-install ARGS=""
	# Exec  : $$(GO_CMD) install $$(ARGS) "github.com/goreleaser/nfpm/v2/cmd/nfpm@$$(NFPM_VERSION)"
	# Desc  : Install nfpm using `go install`.
	# Examples:
	#   - make nfpm-install
	#   - make nfpm-install ARGS="-tags netgo"
	#   - make nfpm-install NFPM_VERSION="main"

.PHONY: nfpm-install
nfpm-install:
ifeq ("nfpm-install","$(MAKECMDGOALS)")
	$(GO_CMD) install $(ARGS) "github.com/goreleaser/nfpm/v2/cmd/nfpm@$(NFPM_VERSION)"
	$(GO_CMD) mod tidy
else
ifeq (,$(shell which $(NFPM_CMD) 2>/dev/null))
	$(GO_CMD) install $(ARGS) "github.com/goreleaser/nfpm/v2/cmd/nfpm@$(NFPM_VERSION)"
	$(GO_CMD) mod tidy
endif
endif

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: nfpm-usage
nfpm-usage:
	# Usage : make nfpm ARGS=""
	# Exec  : $$(NFPM_CMD) $$(ARGS)
	# Desc  : Run nfpm with given arguments.
	# Examples:
	#   - make nfpm ARGS="--version"
	#   - make nfpm ARGS="--help"

.PHONY: nfpm
nfpm: nfpm-install
	$(NFPM_CMD) $(ARGS)

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: nfpm-rpm-usage
nfpm-rpm-usage:
	# Usage : make nfpm-rpm
	# Exec  : $$(NFPM_CMD) package -p rpm -t $$(NFPM_OUTPUT) $$(NFPM_OPTION)
	# Desc  : Create rpm packages.
	# Examples:
	#   - make nfpm-rpm NFPM_RPM_ARCH="amd64"
	#   - make nfpm-rpm NFPM_RPM_ARCH="amd64 arm64"

.PHONY: nfpm-rpm
nfpm-rpm: nfpm-install
	mkdir -p $(NFPM_OUTPUT)
	@for target in $(NFPM_RPM_ARCH); do \
	ARCH=$$target $(NFPM_CMD) package -p rpm -t $(NFPM_OUTPUT) $(NFPM_OPTION); \
	done

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: nfpm-deb-usage
nfpm-deb-usage:
	# Usage : make nfpm-deb
	# Exec  : $$(NFPM_CMD) package -p deb -t $$(NFPM_OUTPUT) $$(NFPM_OPTION)
	# Desc  : Create deb packages.
	# Examples:
	#   - make nfpm-deb NFPM_DEB_ARCH="amd64"
	#   - make nfpm-deb NFPM_DEB_ARCH="amd64 arm64"

.PHONY: nfpm-deb
nfpm-deb: nfpm-install
	mkdir -p $(NFPM_OUTPUT)
	@for target in $(NFPM_DEB_ARCH); do \
	ARCH=$$target $(NFPM_CMD) package -p deb -t $(NFPM_OUTPUT) $(NFPM_OPTION); \
	done

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: nfpm-apk-usage
nfpm-apk-usage:
	# Usage : make nfpm-apk
	# Exec  : $$(NFPM_CMD) package -p apk -t $$(NFPM_OUTPUT) $$(NFPM_OPTION)
	# Desc  : Create apk packages.
	# Examples:
	#   - make nfpm-apk NFPM_APK_ARCH="amd64"
	#   - make nfpm-apk NFPM_APK_ARCH="amd64 arm64"

.PHONY: nfpm-apk
nfpm-apk: nfpm-install
	mkdir -p $(NFPM_OUTPUT)
	@for target in $(NFPM_APK_ARCH); do \
	ARCH=$$target $(NFPM_CMD) package -p apk -t $(NFPM_OUTPUT) $(NFPM_OPTION); \
	done

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: nfpm-arch-usage
nfpm-arch-usage:
	# Usage : make nfpm-arch
	# Exec  : $$(NFPM_CMD) package -p archlinux -t $$(NFPM_OUTPUT) $$(NFPM_OPTION)
	# Desc  : Create archlinux packages.
	# Examples:
	#   - make nfpm-arch NFPM_ARCH_ARCH="amd64"
	#   - make nfpm-arch NFPM_ARCH_ARCH="amd64 arm64"

.PHONY: nfpm-arch
nfpm-arch: nfpm-install
	mkdir -p $(NFPM_OUTPUT)
	@for target in $(NFPM_ARCH_ARCH); do \
	ARCH=$$target $(NFPM_CMD) package -p archlinux -t $(NFPM_OUTPUT) $(NFPM_OPTION); \
	done

#├─────────────────────────────────────────────────────────────────────────────┤
