#!/bin/bash

set -exo pipefail

DEBIAN_DISTS="buster bullseye sid"
UBUNTU_DISTS="focal groovy"

for i in ${DEBIAN_DISTS}; do
    mkdir -p "${SRCDIR}/pbuilder/${i}-amd64"
    sudo cowbuilder \
        --create \
        --mirror http://deb.debian.org/debian/ \
        --basepath "${SRCDIR}/pbuilder/${i}-amd64/base.cow" \
        --distribution "${i}"
done

for i in ${UBUNTU_DISTS}; do
    mkdir -p "${SRCDIR}/pbuilder/${i}-amd64"
    sudo cowbuilder \
        --create \
        --basepath "${SRCDIR}/pbuilder/${i}-amd64/base.cow" \
        --distribution "${i}"
done

pushd "${SRCDIR}" > /dev/null
sudo tar -cJf "${BUILDDIR}/${PN}-${TARGET/dist-/}-${PV}.tar.xz" pbuilder
popd > /dev/null
