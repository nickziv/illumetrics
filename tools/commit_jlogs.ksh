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
	cd $kernels
	cd ${krepo[$i]}
	mkdir $commit_logs/kernels
	$tools/git_log_json.ksh > $commit_logs/kernels/${krepo[$i]}_log &
	$tools/git_log_numstat_json.ksh > $commit_logs/kernels/${krepo[$i]}_numstat &
done


for i in {0..$nbrepo}; do;
	cd $buildsystems
	cd ${brepo[$i]} 
	mkdir $commit_logs/buildsystems
	$tools/git_log_json.ksh > $commit_logs/buildsystems/${brepo[$i]}_log &
	$tools/git_log_numstat_json.ksh > $commit_logs/buildsystems/${brepo[$i]}_numstat &
done


for i in {0..$nvrepo}; do;
	cd $virtualization
	cd ${vrepo[$i]} 
	mkdir $commit_logs/virtualization
	$tools/git_log_json.ksh > $commit_logs/virtualization/${vrepo[$i]}_log &
	$tools/git_log_numstat_json.ksh > $commit_logs/virtualization/${vrepo[$i]}_numstat &
done


for i in {0..$nurepo}; do;
	cd $userland
	cd ${urepo[$i]} 
	mkdir $commit_logs/userland
	$tools/git_log_json.ksh > $commit_logs/userland/${urepo[$i]}_log &
	$tools/git_log_numstat_json.ksh > $commit_logs/userland/${urepo[$i]}_numstat &
done


for i in {0..$ndsrepo}; do;
	cd $dstor
	cd ${dsrepo[$i]}
	mkdir $commit_logs/dstor
	$tools/git_log_json.ksh > $commit_logs/dstor/${dsrepo[$i]}_log &
	$tools/git_log_numstat_json.ksh > $commit_logs/dstor/${dsrepo[$i]}_numstat &
done

#
# We wait for all of the pairs to finish generating.
#
wait

#
# And now we merge the the pairs into a single file.
#
for i in {0..$nkrepo}; do;
	cd $kernels
	cd ${krepo[$i]}
	node $tools/merge.js $commit_logs/kernels/${krepo[$i]}_log \
		$commit_logs/kernels/${krepo[$i]}_numstat > \
		$commit_logs/kernels/${krepo[$i]} &
done


for i in {0..$nbrepo}; do;
	cd $buildsystems
	cd ${brepo[$i]} 
	node $tools/merge.js $commit_logs/buildsystems/${brepo[$i]}_log \
		$commit_logs/buildsystems/${brepo[$i]}_numstat > \
		$commit_logs/buildsystems/${brepo[$i]} &
done


for i in {0..$nvrepo}; do;
	cd $virtualization
	cd ${vrepo[$i]} 
	node $tools/merge.js $commit_logs/virtualization/${vrepo[$i]}_log \
		$commit_logs/virtualization/${vrepo[$i]}_numstat > \
		$commit_logs/virtualization/${vrepo[$i]} &
done


for i in {0..$nurepo}; do;
	cd $userland
	cd ${urepo[$i]} 
	node $tools/merge.js $commit_logs/userland/${urepo[$i]}_log \
		$commit_logs/userland/${urepo[$i]}_numstat > \
		$commit_logs/userland/${urepo[$i]} &
done


for i in {0..$ndsrepo}; do;
	cd $dstor
	cd ${dsrepo[$i]}
	node $tools/merge.js $commit_logs/dstor/${dsrepo[$i]}_log \
		$commit_logs/dstor/${dsrepo[$i]}_numstat > \
		$commit_logs/dstor/${dsrepo[$i]} &
done

wait

exit

#
# And now we remove the no-longer-needed pairs.
#

for i in {0..$nkrepo}; do;
	cd $kernels
	cd ${krepo[$i]}
	rm $commit_logs/kernels/${krepo[$i]}_log
	rm $commit_logs/kernels/${krepo[$i]}_numstat
done


for i in {0..$nbrepo}; do;
	cd $buildsystems
	cd ${brepo[$i]} 
	mkdir $commit_logs/buildsystems
	rm $commit_logs/buildsystems/${brepo[$i]}_log
	rm $commit_logs/buildsystems/${brepo[$i]}_numstat
done


for i in {0..$nvrepo}; do;
	cd $virtualization
	cd ${vrepo[$i]} 
	mkdir $commit_logs/virtualization
	rm $commit_logs/virtualization/${vrepo[$i]}_log
	rm $commit_logs/virtualization/${vrepo[$i]}_numstat
done


for i in {0..$nurepo}; do;
	cd $userland
	cd ${urepo[$i]} 
	mkdir $commit_logs/userland
	rm $commit_logs/userland/${urepo[$i]}_log
	rm $commit_logs/userland/${urepo[$i]}_numstat
done


for i in {0..$ndsrepo}; do;
	cd $dstor
	cd ${dsrepo[$i]}
	mkdir $commit_logs/dstor
	rm $commit_logs/dstor/${dsrepo[$i]}_log
	rm $commit_logs/dstor/${dsrepo[$i]}_numstat
done
