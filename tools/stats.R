#!/opt/local/bin/Rscript 

#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2014, Nick Zivkovic
#


#
# This program calculates statistics of various Illumos-related repositories,
# and creates writes stats out to stdout. The output is messy, and should be
# cleaned up. And as development continues, the output keeps changing, so don't
# write scripts against the output --- it's not stable.
#
# Arg1 is a JSON file with commit data.
# Arg2 is an author, for the printing of flame-graph data
# XXX Arg2 isn't used yet.

library("jsonlite")

yearlist <- c()
authorlist <- c()
monlist <- c()
yearmonlist <- c()
last_commit_date <- list(); # table of authorname | latest_commit_date
first_commit_date <- list(); # table of authorname | oldest_commit_date
dedup_authorlist <- list(); # a list with one entry per author
ncommits_author <- list(); # total num commits by author
newguard <- c()
newguard_ncommits <- c(); # list num commits, no authors to be used by table()
all_ncommits <- c(); # same as prev but for everyone
file_mods_ln <- list();
file_mods_ct <- list();
file_mods_at <- list();
# a list of lists indexed : file_mods_at_aux1[[path]][[author]]
file_mods_at_aux1 <- list();
# a list of lists indexed : file_mods_at_aux1[[author]][[path]]
file_mods_at_aux2 <- list();
file_mods_ln_yr <- list();
file_mods_ct_yr <- list();
file_mods_at_yr <- list();

# This date is important. It is the data at which the Illumos project was
# started.
first_illumos_commit <- as.POSIXct("2010-07-29 16:07:59");

# This is the date of the Friday the 13th letter from Shapiro.
# This is effectively the Solaris equivalent of Star Wars's 'Order 66'.
order_66 <- as.POSIXct("2010-10-13 00:00:00");
args <- commandArgs(trailingOnly = TRUE);
json_log_file <- args[1];
commit_data <- fromJSON(json_log_file);
len <- nrow(commit_data)
#commitDate is column 6.

#
# We also want to have a list of the number of unique committers by year.
#

#
# We also want to make a matrix where the rows are authors and the columns are
# modified files. We can use this matrix to estimate the 'proximity' of the
# authors to each other, and to identify clusters of authors. Of interest are
# the users that connect the various clusters. We may want to measure
# 'occurrences' of author in a file as the number of total lines modified in
# that file.
#
# This is based on this research:
# http://www.rci.rutgers.edu/~pmclean/mcleanp_01_920_313_breiger_duality.pdf

#
# For the flame-graph files we want to have 2 kinds of counts. 1 count counts
# the number of commits made to a file, and the other counts the number of
# line-changes made to a file. Also, we just have to replace the / with a ;
#
# We have to loop over the commit-data and for each commit we loop over the
# file-mod data. 
#
# We want to get:
#
# File count by commit
# File count by line changed
# File count by authors that touched it
#
# We can also create 'author flamegraphs' --- a flamegraph of files touched for
# each committer.
#
# We should also partition all the file-counts by year. We want a list of lists
# that is indexed by year.
#
# XXX this function still has some runtime errors and so it doesn't work yet.

file_count <- function()
{
	# newstr <- gsub("/", ";", str);
	for (i in 1:len) {
		# this is the number of rows, all columns have same nrows
		statlen <- nrow(commit_data$stat[[i]]);
		time <- strptime(commit_data$commitDate[[i]],
		    "%Y-%m-%d %H:%M:%S %z");
		year <- strftime(time, "%Y");
		author <- commit_data$author[[i]];
		author <- normalize_author(author);
		for (j in 1:statlen) {
			# this is the number of rows
			ins <- as.numeric(commit_data$stat[[i]][[1]][[j]]);
			del <- as.numeric(commit_data$stat[[i]][[2]][[j]]);
			path <- commit_data$stat[[i]][[3]][[j]];
			# we make the path flame-graph friendly
			path <- gsub("/", ";", path);
			# first we set the commit-count
			if (is.null(file_mods_ct[[ path ]])) {
				file_mods_ct[[ path ]] <<- 1;
			} else {
				file_mods_ct[[ path ]] <<-
				    file_mods_ct[[ path ]] + 1;
			}
			# then we set the line-count
			if (is.null(file_mods_ln[[ path ]])) {
				file_mods_ln[[ path ]] <<- 0;
			} else {
				file_mods_ln[[ path ]] <<-
				    file_mods_ln[[ path ]] + ins + del;
			}
			# then we set the author
			# Each path has a list of authors
			# If this is null then so is the main mods_at list
			if (is.null(file_mods_at_aux1[[ path ]])) {
				file_mods_at_aux1[[ path ]] <<- list();
				file_mods_at[[ path ]] <<- 0;
			}
			if (is.null(file_mods_at_aux2[[ author ]])) {
				file_mods_at_aux2[[ author ]] <<- list();
			}
			file_mods_at_aux1[[ path ]][[ author ]] <<- 1;
			# this way, we can lookup if an author has modified a
			# specific file
			file_mods_at_aux2[[ author ]][[ path ]] <<- 1;
			# here we update the count of authors that has touched
			# the file
			auths <- length(file_mods_at_aux1[[ path ]]);
			file_mods_at[[ path ]] <<- auths;
		}
	}
}

#
# This function takes an author and checks to see if the author has made any
# commits since the date of Order 66.
#
survived_purge <- function(x)
{
	if (last_commit_date[[ x ]] <= order_66) {
		return (FALSE);
	}
	return (TRUE);
}

#
# This function tells us if an author joined the Illumos communinity _after_
# Order 66.
#
post_crisis_generation <- function(x)
{
	if (first_commit_date[[ x ]] > order_66) {
		return (TRUE);
	}
	return (FALSE);
}

count_survivors <- function()
{
	ns <- 0;
	nauthors <- length(dedup_authorlist);
	for (i in 1:nauthors) {
		r <- survived_purge(dedup_authorlist[[i]]);
		if (r == TRUE) {
			ns <- ns + 1;
		}
	}
	return (ns);
}

count_newguard <- function()
{
	ny <- 0;
	nauthors <- length(dedup_authorlist);
	for (i in 1:nauthors) {
		r <- post_crisis_generation(dedup_authorlist[[i]]);
		if (r == TRUE) {
			ny <- ny + 1;
			elem <- dedup_authorlist[[ i ]];
			newguard <<- c(newguard, elem);
		}
	}
	return (ny);
}

# This function prints the newguard authors and the total commits they made.
print_newguard_stats <- function()
{
	nnewg <- length(newguard);
	total_com <- 0;
	for (i in 1:nnewg)  {
		auth <- newguard[[ i ]];
		ncom <- ncommits_author[[ auth ]];
		newguard_ncommits <<- c(newguard_ncommits, ncom);
		total_com <- total_com + ncom;
		printable <- paste(ncom, auth, sep=" ");
		print(noquote(printable));
	}
	print("Total New Guard Commits:");
	print(total_com);
}

print_all_stats <- function()
{
	nauth <- length(dedup_authorlist);
	total_com <- 0;
	for (i in 1:nauth)  {
		auth <- dedup_authorlist[[ i ]];
		ncom <- ncommits_author[[ auth ]];
		all_ncommits <<- c(all_ncommits, ncom);
		total_com <- total_com + ncom;
		printable <- paste(ncom, auth, sep=" ");
		print(noquote(printable));
	}
	print("Total Commits:");
	print(total_com);
}


#
# We want to output a graph that shows the distribution of changes
# with the number of devs. Something like a pareto distribution or a
# price's law distribution. We want to have a table that shows:
#
# commits : authors
#
# This shows the frequency distribution of commits by author
#
# and a table that has:
#
# %commits : %authors
#
# So 75% commits, 25% authors, 50% commits, 10% authors and so on.
#
# And then we could output these tables. Also, for 50%, we have 10% and 90%
# responsible for them. But that's the only percentage that has 2 percentages.

#
# This function, when given an author-name `x`, will return the number of lines
# this author has changed, between dates `y` and `z`.
#
nlines_changed <- function(x, y, z)
{

}

#
# This function, when given an author-name `x`, will return a table of number
# of files this author has changed, by `y`, where `y` is either 'ever',
# 'by-year', 'by-year-mon'. Column one is a string representing the
# time-increment, and column two is a number.
#
nfiles_changed <- function(x, y)
{

}

#
# Sometimes, in the commit-log there are duplicates in the author name. For
# Illumos, for example, "ahl", "Adam Leventhal", and "Adam H. Leventhal", are
# the same exact person. We want to represent them as the same person, not as
# three different user names. Also Gerald Jelenik is the same a Jerry Jelenik
# and gjelenik.
#
normalize_author <- function(x)
{
	if (x == "ahl" || x == "Adam Leventhal") {
		return ("Adam H. Leventhal");
	}
	if (x == "Gerald Jelinek" || x == "gjelinek") {
		return ("Jerry Jelinek");
	}
	if (x == "ahrens" || x == "Matt Ahrens") {
		return ("Matthew Ahrens");
	}
	if (x == "amaguire") {
		return ("Alan Maguire");
	}
	# We aren't sure if these are the same person...
	# Still, better to be conservative when counting committers.
	if (x == "artem") {
		return ("Artem Kachitchkine");
	}
	if (x == "aubrey.li@intel.com") {
		return ("Aubrey Li");
	}
	if (x == "eschrock") {
		return ("Eric Schrock");
	}
	if (x == "Johann 'Myrkraverk' Oskarsson") {
		return ("Johann Oksarsson");
	}
	if (x == "George.Wilson") {
		return ("George Wilson");
	}
	if (x == "J. Schilling") {
		return ("Joerg Schilling");
	}
	# Aren't sure if these are the same person
	if (x == "ethindra") {
		return ("Ethindra Ramamurthy");
	}
	if (x == "jasmith") {
		return ("Jeff A. Smith");
	}
	if (x == "jesseb") {
		return ("Jesse Butler");
	}
	if (x == "jhaslam") {
		return ("Jonathan Haslam");
	}
	if (x == "Prakash Jalan" || x == "jprakash") {
		return ("Jalan Prakash");
	}
	if (x == "kchow") {
		return ("Kit Chow");
	}
	if (x == "Keith Wesolowski" || x == "Keith M Wesolowski" ||
	    x == "wesolows") {
		return ("Keith M. Wesolowski")
	}
	if (x == "bmc" || x == "Bryan Cantrill") {
		return ("Bryan M. Cantrill");
	}
	if (x == "bonwick") {
		return ("Jeff Bonwick");
	}
	# Not sure 'brendan' is Gregg. I'll verify later.
	if (x == "brendan" || x == " Brendan Gregg - Sun Microsystems") {
		return ("Brendan Gregg");
	}
	if (x == "billm") {
		return ("Bill Moore");
	}
	if (x == "allan") {
		return ("Allan Ou");
	}
	if (x == "acruz") {
		return ("Anotello Cruz");
	}
	if (x == "Ada") {
		return ("Ada Feng");
	}

	# This might not be the same person, but their commits touch similar
	# areas of code.
	if (x == "akolb") {
		return ("Alexander Kolbasov");
	}

	# This is _that guy_ that put double-quotes in his username. This man
	# will burn in a very special level of hell. A level they reserve for
	# child molesters and people who talk at the theater.
	if (x == "\"Nagaraj Yedathore - Sun Microsystems - Bangalore India\"") {
		return ("Nagaraj Yedathore");
	}

	# Don't like official-sounding names.
	if (x == "afshin salek ardakani - Sun Microsystems - Irvine United States") {
		return ("Afshin Salek Ardakani");
	}
	if (x == "Aruna Ramakrishna - Sun Microsystems") {
		return ("Aruna Ramakrishna");
	}
	if (x == "batschul") {
		return ("Frank Batschulat");
	}

	# Pretty sure this is Smaalders
	if (x == "barts") {
		return ("Bart Smaalders");
	}

	# Pretty sure this is DMoffat
	if (x == "darrenm") {
		return ("Darren Moffat");
	}

	if (x == "aalok") {
		return ("Alok Aggarwal");
	}

	# There is also an instance where Cheng's email is there but his name
	# is just whitespace. Should handle this, probably with a second
	# argument to the function.
	if (x == "echeng") {
		return ("Eric Cheng");
	}
	if (x == "jkennedy") {
		return ("John Kennedy");
	}

	if (x == "achimm") {
		return ("Achim Maurer");
	}
	if (x == "aguzovsk") {
		return ("Aleksandr Guzovskiy");
	}

	if (x == "agiri") {
		return ("Adari Giri");
	}
	if (x == "achartre") {
		return ("Alexandre Chartre");
	}
	if (x == "abalfour") {
		return ("Andrew Balfour");
	}
	if (x == "enricop") {
		return ("Enrico Papi");
	}
	if (x == "semery") {
		return ("Shawn Emery");
	}
	if (x == "sherrym") {
		return ("Sherry Moore");
	}
	if (x == "sbehera") {
		return ("Santwona Behera");
	}
	if (x == "rameshc") {
		return ("Ramesh Chirtothu");
	}
	if (x == "Dmitry.Savitsky@nexenta.com") {
		return ("Dmitry Savitsky");
	}
	if (x == "" || x == " " || x == "Unknown" || is.null(x)) {
		return ("UNKNOWN AUTHOR");
	}
	return (x);
}

initialize <- function()
{

	for (i in 1:len) {
		time <- strptime(commit_data$commitDate[[i]],
		    "%Y-%m-%d %H:%M:%S %z");
		author <- commit_data$author[[i]];
		author <- normalize_author(author);
		dedup_authorlist[[ author ]] <<- author;
		if (is.null(ncommits_author[[ author ]])) {
			ncommits_author[[ author ]] <<- 1;
		} else {
			ncommits_author[[ author ]] <<-
			    ncommits_author[[ author ]] + 1;
		}
		if (is.null(last_commit_date[[ author ]])) {
			last_commit_date[[ author ]] <<- time;
		} else if (last_commit_date[[ author ]] < time) {
			last_commit_date[[ author ]] <<- time;
		}
		if (is.null(first_commit_date[[ author ]])) {
			first_commit_date[[ author ]] <<- time;
		} else if (first_commit_date[[ author ]] > time) {
			first_commit_date[[ author ]] <<- time;
		}
		year <- strftime(time, "%Y");
		author_year <- paste(author, year, sep=" ");
		#author_year <- paste(year, author, sep=" ");
		mon <- strftime(time, "%m");
		yearmon <- strftime(time, "%Y/%m");
		yearlist <<- c(yearlist, year); 
		authorlist <<- c(authorlist, author_year);
		monlist <<- c(monlist, mon); 
		yearmonlist <<- c(yearmonlist, yearmon); 
	}
}

new_guard_vs_old_guard <- function()
{
	survivors <- count_survivors();
	num_newguard <- count_newguard();
	purged <- length(dedup_authorlist) - survivors;
	print("survivors");
	print(survivors);
	print("new guard");
	print(num_newguard);
	print("purged");
	print(purged);

	print_newguard_stats();
	ftbl_ngcom <- table(newguard_ncommits);
	print(ftbl_ngcom);
	print_all_stats();
	ftbl_acom <- table(all_ncommits);
	print(ftbl_acom);
}

initialize();
#file_count();
new_guard_vs_old_guard();


#print(newguard);

#table(yearlist);
#table(authorlist);
#table(monlist);
#table(yearmonlist);
#str(commit_data);
#print(commit_data$stat[[1]]);
# first index refs the stats of the commit at that index
# second index refs the column 1:ins 2:del 3:path
# third index refs the row of the column
#print(commit_data$stat[[1]][[1]]);
#print(nrow(commit_data$stat[[1]]));
#print(length(commit_data$stat[[1]]));
#print(nrow(commit_data$stat[[1]][[1]]));
#print(length(commit_data$stat[[1]][[1]]));
#print(commit_data$stat[[1]][[1]][[2]]);
#print(commit_data$stat[[2]]);
#print(commit_data$stat[[2]]);



#print(year_count[year]);

#
# First we get the commit log, which is the first argument to this R script. We
# then generate summaries for:
# 
# *) number of commits by year
# *) number of commits by month
# *) number of lines changed by year
# *) number of lines changed by month
# *) number of files touched by year
# *) number of files touched by month
# *) number of unique committers by year
# *) committers that made the most commits ever
# *) committers that made the most commits by year
# *) committers that made the most commits by month
# *) committers that changed the most lines ever
# *) committers that changed the most lines by year
# *) committers that changed the most lines by month
# *) committers that touched the most files ever
# *) committers that touched the most files by year
# *) committers that touched the most files by month
# *) committers that disappeared after the founding of the Illumos project
# *) committers that appeared after the founding of the Illumos project
#
