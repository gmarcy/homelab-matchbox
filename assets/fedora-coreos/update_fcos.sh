#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")" && pwd)"

FCOS_VERSION=$(curl -s https://builds.coreos.fedoraproject.org/streams/stable.json | jq -Mr .architectures.x86_64.artifacts.metal.release)

podman pull quay.io/coreos/coreos-installer:release

if [ -d ${DIR}/${FCOS_VERSION} ]; then
  echo "Already have the latest stable release images"
else
  echo "Downloading the latest stable release images"
  mkdir ${DIR}/${FCOS_VERSION}
  podman run --network host --privileged --pull=always --rm -v ${DIR}/${FCOS_VERSION}:/data -w /data quay.io/coreos/coreos-installer:release download -f pxe -C /data
fi
rm -f ${DIR}/fedora-coreos-live-kernel-x86_64
ln ${DIR}/${FCOS_VERSION}/fedora-coreos-${FCOS_VERSION}-live-kernel-x86_64 ${DIR}/fedora-coreos-live-kernel-x86_64
rm -f ${DIR}/fedora-coreos-live-rootfs.x86_64.img
ln ${DIR}/${FCOS_VERSION}/fedora-coreos-${FCOS_VERSION}-live-rootfs.x86_64.img ${DIR}/fedora-coreos-live-rootfs.x86_64.img
rm -f ${DIR}/fedora-coreos-live-initramfs.x86_64.img
podman run --network host --privileged --rm -v ${DIR}:/data -w /data quay.io/coreos/coreos-installer:release pxe customize \
    --pre-install pre-install/wipefs-partitions.sh --post-install post-install/efibootmgr-order-fix.sh \
    --output /data/fedora-coreos-live-initramfs.x86_64.img ${FCOS_VERSION}/fedora-coreos-${FCOS_VERSION}-live-initramfs.x86_64.img
podman run --network host --privileged --rm -v ${DIR}:/data -w /data quay.io/coreos/coreos-installer:release pxe ignition unwrap fedora-coreos-live-initramfs.x86_64.img | jq .
