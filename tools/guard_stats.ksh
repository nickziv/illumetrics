#!/bin/ksh

#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2015, Nick Zivkovic
#

source ./common_dirs.ksh
source ./common_repo_dirs.ksh

ngcom=0
ogcom=0

#
# This script walks over the author-summaries for each repository, and
# calculates commit-distribution between authors in their respective guards and
# across guards, but only authors that have survived the purge.
#

# We sum up the commits for the old-guard and new-guard. We only count commits
# since Order 66. We cache them in the $repo_authors directory. If the file
# already exists, we skip this step.

for index in ${!dirs[@]}; do
	for repo in ${dirs[$index][@]}; do
		./guard_stats_worker.ksh $commit_logs/$index/$repo"_authors"\
		> $commit_logs/$index/$repo"_authors/LOG1"\
		2> $commit_logs/$index/$repo"_authors/LOG2" &
	done
done
wait;
