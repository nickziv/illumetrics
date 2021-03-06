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
# This script removes only the author-data
#

source ./common_dirs.ksh
source ./common_repo_dirs.ksh

echo ${!dirs[@]}
for index in ${!dirs[@]}; do
	cd $commit_logs/$index;
	rm -rf $( ls | grep _authors )
done
