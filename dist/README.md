# packaging dehydrated-hooks

We use [pacur](https://github.com/pacur/pacur). Install it by:

2. Installing `podman`
1. Installing `golang`


(yeah this is kind of heavy on the dependency front but it's worth it? maybe?)

To build:

```
pacur project build
```

Or

```
podman build --rm -t pacur/docker/$distro/ pacur/$distro
sudo podman run --rm -it -v `pwd`:/pacur pacur/$distro
```

Or without containers:

```
go get github.com/pacur/pacur
sudo mkdir /pacur && sudo cp PKGBUILD /pacur
sudo ~/go/bin/pacur build $distro
sudo rm /pacur/PKGBUILD
cp /pacur/* .
```

This should output a .deb, .rpm, or .zst file depending on what platform you chose to build for.
