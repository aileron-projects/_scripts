# RPM packaging assets

This folder contains assets for `.rpm` packages.

Packages are built with [nfpm](https://github.com/goreleaser/nfpm).

## Installed files

```txt
/
├── etc/
│   ├── sysconfig/
│   │   └── hello.env
│   └── hello/
│       └── config.yaml
├── usr/
│   ├── bin/
│   │   └── hello
│   └── lib/
│       └── systemd/
│           └── system/
│               └── hello.service
└── var/
    └── lib/
        └── hello/
```

## Install and remove with rpm

**Install.**

```bash
ARCH=x86_64
VERSION=v1.0.0
sudo rpm --install ./hello-${VERSION}-1.${ARCH}.rpm
```

**Remove.**

```bash
sudo rpm --erase hello
```

## Install and remove with yum

**Install.**

```bash
ARCH=x86_64
VERSION=v1.0.0
sudo yum install ./hello-${VERSION}-1.${ARCH}.rpm
```

**Remove.**

```bash
sudo yum remove hello
```

## Install and remove with dnf

**Install.**

```bash
ARCH=x86_64
VERSION=v1.0.0
sudo dnf install ./hello-${VERSION}-1.${ARCH}.rpm
```

**Remove.**

```bash
sudo dnf erase hello
```
