#!/opt/local/bin/node 

//--abort_on_uncaught_exception

/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/.
 */


/*
 * Copyright (c) 2015, Nick Zivkovic
 */
var vasync = require('/opt/local/lib/node_modules/vasync');
var fs = require('fs');
var nopt = require('/opt/local/lib/node_modules/nopt');
var util = require('util');

var log_file = process.argv[2];
var auth_dir = log_file.concat("_authors");
var commit_log;
var order_66 = new Date();
order_66 = Date.parse("2010-08-13");



function read_json_log(input_file, callback)
{
	console.log("start read");
	fs.readFile(input_file, 'utf8', function (err, data) {
		if (err) {
			callback(err, data);
		}
		commit_log = JSON.parse(data);
		callback(err, data);
	});
	console.log("end read");
}


var summary = {};
var dest;
var filetouched = {};

function file_stats(c)
{
	i = 0;
	length = c.stat.length;
	while (i < length) {
		//console.log("File stats, commit:");
		//console.log(c);
		s = c.stat[i];
		if (filetouched[s.path] == null) {
			summary.nfilesmod += 1;
			filetouched[s.path] = true;
			if (c.commitDate < order_66) {
				summary.nfilesmod_pre_purge += 1;
			}
		}
		summary.nlinesmod += s.insertions;
		summary.nlinesadd += s.insertions;
		summary.nlinesmod += s.deletions;
		summary.nlinesrem += s.deletions;
		if (c.commitDate < order_66) {
			summary.nlinesmod_pre_purge += s.insertions;
			summary.nlinesmod_pre_purge += s.deletions;
			summary.nlinesadd_pre_purge += s.insertions;
			summary.nlinesrem_pre_purge += s.deletions;
		}
		i++;
	}
}

function write_summary()
{

	path_name = log_file.replace("\.json", "_summary.json");
	dest = fs.createWriteStream(path_name, { flags: 'w',
		encoding:'utf8', mode: 0666});
	ok = dest.write(JSON.stringify(summary));
}


function summarize(c, i, arr)
{
	if (summary.author == null) {
		summary.author = c.author;
	}
	if (prev == 0) {
		prev = c.commitDate;
	} else {
		if (summary.avg_dist == null) {
			summary.avg_dist = Math.abs(prev - c.commitDate);
		} else {
			summary.avg_dist += Math.abs(prev - c.commitDate);
		}
	}
	/*
	 * Yeah, the log is in reverse chronological order, but this
	 * extra robustness won't hurt us.
	 */
	if (summary.first_commit == null ||
	    summary.first_commit > c.commitDate) {
		summary.first_commit = c.commitDate;
	}
	if (summary.last_commit == null ||
	    summary.last_commit < c.commitDate) {
		summary.last_commit = c.commitDate;
	}
	/*
	 * We want to know how many of these commits occurred before the purge.
	 */
	if (c.commitDate < order_66) {
		summary.ncommits_pre_purge += 1;
	}
	file_stats(c);
}

function fill_out_summary(ignored, callback)
{
	i = 0;
	prev = 0;
	summary.nfilesmod = 0;
	summary.nlinesmod = 0;
	summary.nlinesadd = 0;
	summary.nlinesrem = 0;
	summary.nfilesmod_pre_purge = 0;
	summary.nlinesmod_pre_purge = 0;
	summary.nlinesadd_pre_purge = 0;
	summary.nlinesrem_pre_purge = 0;
	summary.ncommits_pre_purge = 0;
	summary.ncommits = commit_log.length;
	summary.ndist = summary.ncommits - 1;
	commit_log.forEach(summarize);
	summary.avg_dist = summary.avg_dist / summary.ndist;
	if (summary.first_commit > order_66) {
		summary.new_guard = true;
		summary.survived_purge = true;
	} else {
		summary.new_guard = false;
		if (summary.last_commit <= order_66) {
			summary.survived_purge = false;
		} else {
			summary.survived_purge = true;
		}
	}
	write_summary();
	callback(null, null);
}


/*
 * Execute the series.
 */

console.log(vasync.pipeline({
	'funcs': [
		read_json_log,
		fill_out_summary
	],
	'arg': log_file
}, function (err, result) {
	if (err != null) {
		console.log('error: %s', err.message);
	}
	if (result != null) {
		//console.log('results: %s', util.inspect(result, null, 3));
	}
}));
