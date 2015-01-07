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
# This script runs statistics-gathering commands on the json commit-logs, and
# outputs them as more compact json files in the data directory. The node
# scripts know where to write the output, so no piping is needed.
#

source ./common_dirs.ksh
source ./common_repo_dirs.ksh

rm -r errlog
mkdir errlog
./clean_author_data.ksh

# First we distill.
for index in ${!dirs[@]}; do
	for repo in ${dirs[$index][@]}; do
		$tools/distill.js $commit_logs/$index/$repo 2>\
		 errlog/"distill_err_$index_$repo" >\
		 errlog/"distill_out_$index_$repo" &
	done
done

wait;

maxjob=150
njob=0

# Then we summarize

for index in ${!dirs[@]}; do
	for repo in ${dirs[$index][@]}; do
		for A in $( ls $commit_logs/$index/$repo"_authors" ); do
			author=$commit_logs/$index/$repo"_authors/$A"
			$tools/summarize_author.js $author 2>\
			errlog/"summarize_err_$index_$repo_$A" >\
			errlog/"summarize_out_$index_$repo_$A" &
			njob=$( expr $njob + 1)
			if [[ $njob -eq $maxjob ]]; then
				wait; # We want to limit the forking
				njob=0; #reset the counter
			fi
		done
	done
done

#
# Wait for any leftover jobs to finish.
#
wait;
