# Arch Linux packaging assets

This folder contains assets for `.pkg.tar.zst` packages.

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
