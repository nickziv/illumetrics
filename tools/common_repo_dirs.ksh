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

root=$(pwd)/../
configs=$root/configs

#
# The following loop creates an associative array of the
# following structure:
# dirs["..(path to root)../compiler"][0] -> "gcc"
# dirs["..(path to root)../kernel"][0]  -> "illumos-gate"
# dirs["..(path to root)../kernel"][1]  -> "illumos-core"
# etc...
#
typeset -A dirs
for list_file in `ls $configs`; do
	clean_name=$(echo $list_file | sed s/\.list//g)
	dir_name=$root/$clean_name

	i=0
	for line in `cat $configs/$list_file`; do
		dirs[$dir_name][$i]=$(echo $line | cut -d '/' -f 5- | sed s/\.git//g)
		i=$(( $i+1 ))
	done
done
