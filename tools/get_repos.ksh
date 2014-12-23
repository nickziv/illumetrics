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

source ./common_dirs.ksh

mkdir $kernels
mkdir $buildsystems
mkdir $virtualization
mkdir $userland
#mkdir $docs
#mkdir $cc
mkdir $dstor
mkdir $data
mkdir $commit_logs

krepo[0]="git://github.com/illumos/illumos-gate.git"
krepo[1]="git://github.com/joyent/illumos-joyent.git"
krepo[2]="git://github.com/delphix/delphix-os.git"
krepo[3]="git://github.com/Nexenta/illumos-nexenta.git"
krepo[4]="git://github.com/omniti-labs/illumos-omnios.git"
nkrepo=4

brepo[0]="git://github.com/omniti-labs/omnios-build.git"
brepo[1]="git://github.com/omniti-labs/omnios-build.git"
brepo[2]="git://github.com/joyent/smartos-live.git"
nbrepo=2

vrepo[0]="git://github.com/joyent/illumos-kvm.git"
nvrepo=0

urepo[0]="git://github.com/joyent/illumos-extra.git"
urepo[1]="git://github.com/Nexenta/nza-userland.git"
urepo[2]="git://github.com/illumos/illumos-userland.git"
nurepo=2

ccrepo[0]="git://github.com/illumos/gcc.git"
nccrepo=0

#Start with Joyent MANTA stuff.
#Should probably break it distill this list later
dsrepo[0]="git://github.com/joyent/muppet.git"
dsrepo[1]="git://github.com/joyent/manta-muskie.git"
dsrepo[2]="git://github.com/joyent/mahi"
dsrepo[3]="git://github.com/joyent/manta-medusa.git"
dsrepo[4]="git://github.com/joyent/manatee"
dsrepo[5]="git://github.com/joyent/moray"
dsrepo[6]="git://github.com/joyent/electric-moray.git"
dsrepo[7]="git://github.com/joyent/manta-mako.git"
dsrepo[8]="git://github.com/joyent/manta-marlin.git"
dsrepo[9]="git://github.com/joyent/manta-wrasse.git"
dsrepo[10]="git://github.com/joyent/binder.git"
dsrepo[11]="git://github.com/joyent/manta-mola.git"
dsrepo[12]="git://github.com/joyent/manta-mackerel.git"
dsrepo[13]="git://github.com/joyent/manta-madtom.git"
dsrepo[14]="git://github.com/joyent/manta-marlin-dashboard.git"
dsrepo[15]="git://github.com/joyent/manta-minnow.git"
ndsrepo=15

cd $kernels

for i in {0..$nkrepo}; do;
	git clone ${krepo[$i]} & 2> /dev/null
done
wait

cd $buildsystems

for i in {0..$nbrepo}; do;
	git clone ${brepo[$i]} & 2> /dev/null
done
wait

cd $virtualization

for i in {0..$nvrepo}; do;
	git clone ${vrepo[$i]} & 2> /dev/null
done
wait

cd $userland

for i in {0..$nurepo}; do;
	git clone ${urepo[$i]} & 2> /dev/null
done
wait

cd $dstor

for i in {0..$ndsrepo}; do;
	git clone ${dsrepo[$i]} & 2> /dev/null
done
wait
