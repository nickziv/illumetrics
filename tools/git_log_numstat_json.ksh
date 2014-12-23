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

git log \
--numstat \
--format='%h' \
$@ | \
perl -lawne '
if (defined $F[1]) {
print qq#{"insertions": "$F[0]", "deletions": "$F[1]", "path": "$F[2]"},#
} elsif (defined $F[0]) {
print qq#],\n"$F[0]": [#
};
END{print qq#],#}' | \
tail -n +2 | \
perl -wpe 'BEGIN{print "{"}; END{print "}"}' | \
tr '\n' ' ' | \
perl -wpe 's#(]|}),\s*(]|})#$1$2#g' | \
perl -wpe 's#,\s*?}$#}#' 
