# Alpine packaging assets

This folder contains assets for `.apk` packages.

Packages are built with [nfpm](https://github.com/goreleaser/nfpm).

## Installed files

```txt
/
├── etc/
│   ├── init.d/
│   │   └── hello
│   ├── default/
│   │   └── hello.env
│   └── hello/
│       └── config.yaml
├── usr/
│   └── bin/
│       └── hello
└── var/
    └── lib/
        └── hello/
```

## Install and remove with apk

**Install.**

```bash
ARCH=x86_64
VERSION=v1.0.0
apk add --allow-untrusted ./hello_${VERSION}-r1_${ARCH}.apk
```

**Remove.**

```bash
apk del --purge hello
```
