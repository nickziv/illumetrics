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
# stores them in the directory.
#

source ./common_dirs.ksh
source ./common_repo_dirs.ksh

for index in ${!dirs[@]}; do
	for repo in ${dirs[$index][@]}; do
		mkdir $stats/$index
		$tools/stats.R $commit_logs/$index/$repo > $stats/$index/$repo &
	done
done

#
# We wait for all of the pairs to finish generating.
#
wait
