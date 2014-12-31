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
# This script removes everything that was done
#

source ./common_dirs.ksh

rm -rf $kernels
rm -rf $buildsystems
rm -rf $virtualization
rm -rf $userland
rm -rf $docs
rm -rf $cc
rm -rf $dstor
rm -rf $data
rm -rf $commit_logs
