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
# This script converts every repository's commit log into a json file.  First,
# we create two JSON files. The first is a JSON representation of what you'd
# see if you did `git log`. The second is a JSON representation of what you'd
# see if you did `git log --numstat`, except the second contains _only_ the
# stats. When we get all of these files, we merge them into a single file. We
# leave all of the files behind, as we will end up over-writing them anyway, if
# we run this script again.
#

source ./common_dirs.ksh
source ./common_repo_dirs.ksh


for i in {0..$nkrepo}; do;
	mkdir $stats/kernels
	$tools/stats.R $commit_logs/kernels/${krepo[$i]} > $stats/kernels/${krepo[$i]} &
done


for i in {0..$nbrepo}; do;
	mkdir $stats/buildsystems
	$tools/stats.R $commit_logs/buildsystems/${brepo[$i]}> $stats/buildsystems/${brepo[$i]} &
done


for i in {0..$nvrepo}; do;
	mkdir $stats/virtualization
	$tools/stats.R $commit_logs/virtualization/${vrepo[$i]} > $stats/virtualization/${vrepo[$i]} &
done


for i in {0..$nurepo}; do;
	mkdir $stats/userland
	$tools/stats.R $commit_logs/userland/${urepo[$i]} > $stats/userland/${urepo[$i]} &
done


for i in {0..$ndsrepo}; do;
	mkdir $stats/dstor
	$tools/stats.R $commit_logs/userland/${dsrepo[$i]}> $stats/dstor/${dsrepo[$i]} &
done

#
# We wait for all of the pairs to finish generating.
#
wait
