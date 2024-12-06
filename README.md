# oneliners

Collection of Bash scripts to perform various commonly used tasks:

- [dive](#dive)
- [tldr](#tldr)
- [Go](#go)
- [crictl](#crictl)
- [containerd](#containerd)
- [CNI plugins](#cni-plugins)

---

## dive

To install [dive](https://github.com/wagoodman/dive):

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/dive.sh | bash
```

## tldr

To install [tealdeer](https://github.com/dbrgn/tealdeer):

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/tldr.sh | bash
```

## Go

To install latest [Go](https://go.dev/doc/install) release:

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/go.sh | bash
```

To install specific Go version:

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/go.sh | bash -s go1.20
```

## crictl

To install latest [crictl](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md#install-crictl) release:

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/crictl.sh | bash
```

To install specific `crictl` version:

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/crictl.sh | bash -s v1.22.0
```

## containerd

To install latest [containerd](https://containerd.io/downloads/#installing-binaries) release:

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/containerd.sh | bash
```

To install specific `containerd` version:

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/containerd.sh | bash -s 1.7.24
```

## CNI Plugins

To install latest [CNI plugins](https://github.com/containernetworking/plugins) release:

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/cni.sh | bash
```

To install specific CNI plugins version:

```bash
curl -fsSL https://raw.githubusercontent.com/gntouts/oneliners/main/cni.sh | bash -s 1.5.1
```
