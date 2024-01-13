#!/usr/bin/env bash

podman volume rm matchbox-data || true
podman volume create matchbox-data
podman build -t homelab-matchbox-builder .
podman run --rm -ti -v matchbox-data:/var/lib/matchbox ghcr.io/gmarcy/homelab-matchbox-builder -e data_path=/var/lib/matchbox
podman run --rm -ti -v matchbox-data:/var/lib/matchbox busybox ls -lR /var/lib/matchbox
podman run --rm -ti -v matchbox-data:/var/lib/matchbox quay.io/coreos/coreos-installer:release download -f pxe -C /var/lib/matchbox/assets/fedora-coreos/download
podman run --rm -ti -v matchbox-data:/var/lib/matchbox busybox ls -lR /var/lib/matchbox
podman run --rm -ti -v matchbox-data:/var/lib/matchbox busybox /bin/sh -c /var/lib/matchbox/assets/fedora-coreos/download/rename_assets.sh
podman run --rm -ti -v matchbox-data:/var/lib/matchbox busybox ls -lR /var/lib/matchbox
podman run --rm -ti -v matchbox-data:/var/lib/matchbox quay.io/coreos/coreos-installer:release pxe customize --pre-install /var/lib/matchbox/assets/fedora-coreos/pre-install/wipefs-partitions.sh --post-install /var/lib/matchbox/assets/fedora-coreos/post-install/efibootmgr-order-fix.sh --output /var/lib/matchbox/assets/fedora-coreos/fedora-coreos-live-initramfs.x86_64.img /var/lib/matchbox/assets/fedora-coreos/download/fedora-coreos-live-initramfs.x86_64.img
podman run --rm -ti -v matchbox-data:/var/lib/matchbox busybox ls -lR /var/lib/matchbox
podman run --rm -ti -v matchbox-data:/var/lib/matchbox quay.io/coreos/butane:release --pretty --strict -d /var/lib/matchbox/generic -o /var/lib/matchbox/generic/fedora-coreos-config.ign /var/lib/matchbox/generic/fedora-coreos-butane.yaml
podman run --rm -ti -v matchbox-data:/var/lib/matchbox busybox ls -lR /var/lib/matchbox
