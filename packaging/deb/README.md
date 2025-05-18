# Debian packaging assets

This folder contains assets for `.deb` packages.

Packages are built with [nfpm](https://github.com/goreleaser/nfpm).

## Installed files

```txt
/
├── etc/
│   ├── default/
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

## Install and remove with apt

**Install.**

```bash
ARCH=amd64
VERSION=v1.0.0
sudo apt-get install ./hello_${VERSION}-1_${ARCH}.deb
```

**Remove.**

```bash
sudo apt-get remove --purge hello
```

## Install and remove with dpkg

**Install.**

```bash
ARCH=amd64
VERSION=v1.0.0
sudo dpkg --install ./hello_${VERSION}-1_${ARCH}.deb
```

**Remove.**

```bash
sudo dpkg --purge hello
```
