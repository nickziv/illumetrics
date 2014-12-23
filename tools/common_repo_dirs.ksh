#!/bin/ksh

#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2014, Nick Zivkovic
#

#
# This script fetches the predetermined repos into this directory.
#

root=$(pwd)/../
#illumos kernel branches
kernels=$root/kernels/
#illumos build systems
buildsystems=$root/buildsystems/
#illumos virtualization addons (like kvm or xen)
virtualization=$root/virtualization/
#illumos userland repos
userland=$root/userland/
#illumos documentation
docs=$root/docs/
#c-compiler 'ports' (like gcc and eventually clang)
cc=$root/cc/
#cloudy stuff built on illumos
cloud=$root/cloud/
#distributed storage stuff built on illumos
dstor=$root/dstor/


krepo[0]="illumos-gate"
krepo[1]="illumos-joyent"
krepo[2]="delphix-os"
krepo[3]="illumos-nexenta"
krepo[4]="illumos-omnios"
nkrepo=4

brepo[0]="omnios-build"
brepo[1]="smartos-live"
nbrepo=1

vrepo[0]="illumos-kvm"
nvrepo=0

urepo[0]="illumos-extra"
urepo[1]="nza-userland"
urepo[2]="illumos-userland"
nurepo=2

ccrepo[0]="gcc"
nccrepo=0

#Start with Joyent MANTA stuff.
#Should probably break it distill this list later
dsrepo[0]="muppet"
dsrepo[1]="manta-muskie"
dsrepo[2]="mahi"
dsrepo[3]="manta-medusa"
dsrepo[4]="manatee"
dsrepo[5]="moray"
dsrepo[6]="electric-moray"
dsrepo[7]="manta-mako"
dsrepo[8]="manta-marlin"
dsrepo[9]="manta-wrasse"
dsrepo[10]="binder"
dsrepo[11]="manta-mola"
dsrepo[12]="manta-mackerel"
dsrepo[13]="manta-madtom"
dsrepo[14]="manta-marlin-dashboard"
dsrepo[15]="manta-minnow"
ndsrepo=15
