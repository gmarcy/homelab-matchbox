#!/usr/bin/env bash

set -x

efibootmgr

BOOT_NEXT=$(efibootmgr | sed -n -e 's/^Boot\(000[0-9A-F]\)\* Fedora.*/\1/p')
BOOT_CURRENT=$(efibootmgr | sed -n -e 's/^BootCurrent: \(.*\)/\1/p')
BOOT_ORDER=$(efibootmgr | sed -n -e 's/^BootOrder: \(.*\)/\1/p')

if [ "${BOOT_NEXT}" == "" -o "${BOOT_CURRENT}" == "" -o "${BOOT_ORDER}" == "" ]; then
  exit 1
fi

efibootmgr -o ${BOOT_NEXT},${BOOT_CURRENT},${BOOT_ORDER} -D

sleep 5

if [ $(hostname) = netsvcs ]; then
  efibootmgr | grep -q Fedora
  if [ $? = 1 ]; then
    efibootmgr --bootnum 0009 --create --label Fedora --disk /dev/nvme0n1 --part 2 --loader '\EFI\fedora\shimx64.efi'
  fi
fi
