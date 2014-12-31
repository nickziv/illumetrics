source("common.R");
#
# This loads all of the data into memory.
#
initialize();
#
# This counts the number of times a file was 'touched', where 'touched' means
# 1) has a commit associated with it, 2) has had a line changed, or 3) has had
# a unique, distinct author modify it. Number 3) isn't fully implemented yet.
# Uncomment file_count() and any _single_ one of the print_file_mods_*()
# functions to use (EXCEPT for print_file_mods_at(), which is not implemented
# yet).
#

file_count();
print_file_mods_at();
