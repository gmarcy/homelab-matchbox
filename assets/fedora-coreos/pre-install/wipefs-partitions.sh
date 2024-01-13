#!/usr/bin/env bash

set -ex

lsblk --json

PV_VG=$(pvdisplay -C -o pv_name,vg_name --no-headings --separator ':' --config 'devices {}')
if [ "${PV_VG}" != "" ]; then
  PV=$(echo ${PV_VG} | cut -d ':' -f 1)
  VG=$(echo ${PV_VG} | cut -d ':' -f 2)
  vgremove -f ${VG} || true
  pvremove -f ${PV} || true
  lsblk --json
fi
wipefs -a /dev/nvme0n1p6 || true
wipefs -a /dev/nvme0n1p5 || true
wipefs -a /dev/nvme0n1p4 || true
wipefs -a /dev/nvme0n1p3 || true
wipefs -a /dev/nvme0n1p2 || true
wipefs -a /dev/nvme0n1p1 || true
wipefs -a /dev/nvme0n1
lsblk --json
