#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")" && pwd)"

URL=https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os

mkdir -p ${DIR}/images/pxeboot
wget ${URL}/images/pxeboot/vmlinuz -O ${DIR}/images/pxeboot/vmlinuz
wget ${URL}/images/pxeboot/initrd.img -O ${DIR}/images/pxeboot/initrd.img
