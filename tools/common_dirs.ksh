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
tools=$root/tools
configs=$root/configs

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

data=$root/data/

commit_logs=$root/data/commit_logs/
stats=$root/stats/
