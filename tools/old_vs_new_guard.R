source("common.R");

#
# This loads all of the data into memory.
#

initialize();

file_count();
#print_file_mods_ct();
#print_file_mods_ln();
#print_file_mods_at();
#print_author_paths();

#
# This compares the New Guard of committers that are replacing what's left of
# the Old Guard of commiters. Anyone who has made their first commit _after_
# the closing of the OpenSolaris source code is considered a member of the New
# Guard (for example Mustacchi, Sipek, and Pankov). This function prints out
# the entire roster of the New Guard and the number of commits they have made.
# It also prints out a frequency distribution of the number of commits made by
# individuals. I'll save you the suspense and tell you that it looks like a
# Pareto distribution, and coincides nearly perfectly with Price's Law. (25% of
# New Guard, contribute 75% of commits. 10% of New Guard, contribute 50% of
# commits.  You'll see :) Prints the same things for every contributor ever.
# Feel free to comment out statistics from the new_guard_vs_old_guard()
# function, if you don't need them -- or to add new ones.
#

new_guard_vs_old_guard();


#print(newguard);
