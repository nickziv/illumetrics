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

for index in ${!dirs[@]}; do
	for repo in ${dirs[$index][@]}; do
		cd $root/$index/$repo
		mkdir $commit_logs/$index

		$tools/git_log_json.ksh > $commit_logs/$index/${repo}_log &
 		$tools/git_log_numstat_json.ksh > $commit_logs/$index/${repo}_numstat &

		break
	done
	break
done

#
# We wait for all of the pairs to finish generating.
#
wait

#
# And now we merge the the pairs into a single file.
#
for index in ${!dirs[@]}; do
	for repo in ${dirs[$index][@]}; do
		cd $root/$index/$repo

		node $tools/merge.js $commit_logs/$index/${repo}_log \
			$commit_logs/$index/${repo}_numstat > \
			$commit_logs/$index/${repo} &

		break
	done
	break
done

wait

exit

#
# And now we remove the no-longer-needed pairs.
#
for index in ${!dirs[@]}; do
	for repo in ${dirs[$index][@]}; do
		cd $root/$index/$repo

		rm $commit_logs/$index/${repo}_log
		rm $commit_logs/$index/${repo}_numstat

		break
	done
	break
done
