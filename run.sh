#!/bin/bash

set -exo pipefail

DEBIAN_DISTS="buster bullseye bookworm sid"
UBUNTU_DISTS="focal hirsute"

ARCH="$(echo "${TARGET}" | cut -d- -f2)"

sudo rm -rf "${BUILDDIR}/pbuilder"

for i in ${DEBIAN_DISTS}; do
    mkdir -p "${BUILDDIR}/pbuilder/${i}-${ARCH}"

    sudo cowbuilder \
        --create \
        --mirror http://deb.debian.org/debian/ \
        --basepath "${BUILDDIR}/pbuilder/${i}-${ARCH}/base.cow" \
        --distribution "${i}"

    sudo tar \
        --checkpoint=1000 \
        -cJf "${BUILDDIR}/pbuilder-chroot-${i}-${ARCH}-${PV}.tar.xz" \
        -C "${BUILDDIR}/pbuilder" \
        .

    sudo rm -rf "${BUILDDIR}/pbuilder/${i}-${ARCH}"
done

for i in ${UBUNTU_DISTS}; do
    mkdir -p "${BUILDDIR}/pbuilder/${i}-${ARCH}"

    sudo cowbuilder \
        --create \
        --basepath "${BUILDDIR}/pbuilder/${i}-${ARCH}/base.cow" \
        --distribution "${i}"

    sudo tar \
        --checkpoint=1000 \
        -cJf "${BUILDDIR}/pbuilder-chroot-${i}-${ARCH}-${PV}.tar.xz" \
        -C "${BUILDDIR}/pbuilder" \
        .

    sudo rm -rf "${BUILDDIR}/pbuilder/${i}-${ARCH}"
done
