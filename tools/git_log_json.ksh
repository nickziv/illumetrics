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
# This turns the git log into a json object.
#

#git_log_awk='git log --pretty=format:"%h%x09%an%x09%ae%x09%ad%x09%s"'
#jsonify the git log
git log \
--pretty=format:'{%n^@^hash^@^:^@^%h^@^,%n^@^author^@^:^@^%an^@^,%n^@^date^@^:^@^%ad^@^,%n^@^email^@^:^@^%aE^@^,%n^@^message^@^:^@^%s^@^,%n^@^commitDate^@^:^@^%ai^@^,%n^@^age^@^:^@^%cr^@^%n},' \
$@ | \
#listify
perl -pe 'BEGIN{print "["}; END{print "]\n"}' | \
perl -pe 's/},]/}]/' | \
#escape all '\'
sed 's/\\/\\\\/g' | \
#escape all '"'
sed 's/"/\\"/g' | \
#escape all tabs
# --the whitespace in the string below is a literal tab
sed 's/	/\\t/g' | \
#convert ^@^ into "
sed 's/\^@\^/\"/g'

#git log \
#--pretty=format:'{%n "commit": "%H",%n "author": "%an",%n "email": "%ae", %n "date": "%ad",%n "message": "%f"%n},' \
#$@ | \
#perl -pe 'BEGIN{print "["}; END{print "]\n"}' | \
#perl -pe 's/},]/}]/' 
