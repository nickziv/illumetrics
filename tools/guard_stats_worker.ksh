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


cd $1
pwd

cat $(ls | grep summary) | json -g -a -c 'survived_purge'\
 -e 'ncommits -= ncommits_pre_purge' new_guard ncommits nfilesmod nlinesmod \
 nlinesadd nlinesrem | awk -f $tools/sum_com.awk > OG_NG_COM_STAT

ngcom=0
ogcom=0
ngfil=0
ogfil=0
nglna=0
oglna=0
nglnr=0
oglnr=0
nglnm=0
oglnm=0


ogcom=$(cat OG_NG_COM_STAT | awk '{print $1}')
ngcom=$(cat OG_NG_COM_STAT | awk '{print $2}')
ogfil=$(cat OG_NG_COM_STAT | awk '{print $3}')
ngfil=$(cat OG_NG_COM_STAT | awk '{print $4}')
oglnm=$(cat OG_NG_COM_STAT | awk '{print $5}')
nglnm=$(cat OG_NG_COM_STAT | awk '{print $6}')
oglna=$(cat OG_NG_COM_STAT | awk '{print $7}')
nglna=$(cat OG_NG_COM_STAT | awk '{print $8}')
oglnr=$(cat OG_NG_COM_STAT | awk '{print $9}')
nglnr=$(cat OG_NG_COM_STAT | awk '{print $10}')
totcom=$(expr $ogcom + $ngcom)
totfil=$(expr $ogfil + $ngfil)
totlnm=$(expr $oglnm + $nglnm)
totlna=$(expr $oglna + $nglna)
totlnr=$(expr $oglnr + $nglnr)
# We write out the data to a file
# It's a json array.

echo "Computing Demographics..."

cat $(ls | grep summary) | json -g -a -e 'ncommits -= ncommits_pre_purge'\
 -e 'nlinesadd -= nlinesadd_pre_purge' -e 'nlinesmod -= nlinesmod_pre_purge'\
 -e 'nlinesrem -= nlinesrem_pre_purge' -e 'nfilesmod -= nfilesmod_pre_purge'\
 -c 'survived_purge' ncommits nfilesmod nlinesmod nlinesadd nlinesrem new_guard author\
 | awk -v ogcom=$ogcom -v ngcom=$ngcom\
 -v totcom=$totcom -v ogfil=$ogfil -v ngfil=$ngfil -v totfil=$totfil\
 -v oglnm=$oglnm -v nglnm=$nglnm -v totlnm=$totlnm -v oglna=$oglna\
 -v nglna=$nglna -v totlna=$totlna -v oglnr=$oglnr -v nglnr=$nglnr\
 -v totlnr=$totlnr -f $tools/guard_crunch.awk\
 > demographics.csv

  #> RAWOUTPUT
#echo "Plotting"

mkdir demplot
Rscript $tools/plot_demographics.R 
