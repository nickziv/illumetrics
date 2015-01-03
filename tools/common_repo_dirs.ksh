#!/bin/ksh

#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2014, Nick Zivkovic
# Copyright (c) 2014, Serapheim Dimitropoulos
#

#
# This script lists repository directories.
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

krepo=( $(ls $kernels) )
nkrepo=${#krepo[@]}

brepo=( $(ls $buildsystems) )
nbrepo=${#brepo[@]}

vrepo=( $(ls $virtualization) )
nvrepo=${#vrepo[@]}

urepo=( $(ls $userland) )
nurepo=${#urepo[@]}

ccrepo=( $(ls $cc) )
nccrepo=${#ccrepo[@]}

dsrepo=( $(ls $dstor) )
ndsrepo=${#dsrepo[@]}
