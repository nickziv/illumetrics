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
# This script fetches the predetermined repos into this directory.
#

source ./common_dirs.ksh

mkdir $kernels
mkdir $buildsystems
mkdir $virtualization
mkdir $userland
#mkdir $docs
mkdir $cc
mkdir $dstor
mkdir $data
mkdir $commit_logs

cd $kernels
for i in $(cat ${configs}/krepo.list); do
	git clone $i & 2> /dev/null
done
wait

cd $buildsystems
for i in $(cat ${configs}/brepo.list); do
	git clone $i & 2> /dev/null
done
wait

cd $virtualization
for i in $(cat ${configs}/vrepo.list); do
	git clone $i & 2> /dev/null
done
wait

cd $userland
for i in $(cat ${configs}/urepo.list); do
	git clone $i & 2> /dev/null
done
wait

cd $cc
for i in $(cat ${configs}/ccrepo.list}); do
	git clone $i & 2> /dev/null
done
wait

cd $dstor
for i in $(cat ${configs}/dsrepo.list); do
	git clone $i & 2> /dev/null
done
wait
