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
# This script updates the predetermined repos into this directory.
#

source ./common_dirs.ksh
source ./common_repo_dirs.ksh


for i in {0..$nkrepo}; do;
	cd $kernels
	cd ${krepo[$i]}
	git pull &
done
wait


for i in {0..$nbrepo}; do;
	cd $buildsystems
	cd ${brepo[$i]} 
	git pull &
done
wait


for i in {0..$nvrepo}; do;
	cd $virtualization
	cd ${vrepo[$i]} 
	git pull &
done
wait


for i in {0..$nurepo}; do;
	cd $userland
	cd ${urepo[$i]} 
	git pull &
done
wait


for i in {0..$ndsrepo}; do;
	cd $dstor
	cd ${dsrepo[$i]}
	git pull &
done
wait
