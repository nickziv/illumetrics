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
source ./common_repo_dirs.ksh

mkdir $data
mkdir $commit_logs

for index in "${!dirs[@]}"; do
	list_file=${index}.list
	full_path=$root/$index

	mkdir $full_path
	cd $full_path
	for i in $(cat ${configs}/$list_file); do
		git clone $i 2> /dev/null &
	done
done
wait
