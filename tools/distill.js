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
fs.mkdirSync(auth_dir, 0777);
var order_66 = new Date();
order_66 = Date.parse("2010-08-13");
var commit_log = {};


/*
 * In case it's not clear enough, each project will need a custom normalize
 * function. This one is only valid for illumos.
 */
function normalize_illumos_author(x)
{
	if (x == "Rich Lowe") {
		return ("Richard Lowe");
	}
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
	/*
         * We aren't sure if these are the same person...
         * Still, better to be conservative when counting committers.
	 */
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
        /* Aren't sure if these are the same person */
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
        /* Not sure 'brendan' is Gregg. I'll verify later. */
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
	/*
         * This might not be the same person, but their commits touch similar
         * areas of code.
	 */
        if (x == "akolb") {
                return ("Alexander Kolbasov");
        }

	/*
         * This is _that guy_ that put double-quotes in his username. This man
         * will burn in a very special level of hell. A level they reserve for
         * child molesters and people who talk at the theater.
	 */
        if (x == "\"Nagaraj Yedathore - Sun Microsystems - Bangalore India\"") {
                return ("Nagaraj Yedathore");
        }

        /* Don't like official-sounding names. */
        if (x == "afshin salek ardakani - Sun Microsystems - Irvine United States") {
                return ("Afshin Salek Ardakani");
        }
        if (x == "Aruna Ramakrishna - Sun Microsystems") {
                return ("Aruna Ramakrishna");
        }
        if (x == "batschul") {
                return ("Frank Batschulat");
        }

        /* Pretty sure this is Smaalders */
        if (x == "barts") {
                return ("Bart Smaalders");
        }

        /* Pretty sure this is DMoffat */
        if (x == "darrenm") {
                return ("Darren Moffat");
        }

        if (x == "aalok") {
                return ("Alok Aggarwal");
        }

	/*
         * There is also an instance where Cheng's email is there but his name
         * is just whitespace. Should handle this, probably with a second
         * argument to the function.
	 */
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
        if (x == "" || x == " " || x == "Unknown" || x == null) {
                return ("UNKNOWN AUTHOR");
        }
        return (x);
}

function normalize_stat(x, i, arr)
{
	arr[i].insertions = Number(x.insertions);
	arr[i].deletions = Number(x.deletions);
}

/*
 * Convert date-strings into millisecond-dates.
 */
function normalize_date(x)
{
	x = Date.parse(x);
	return (x);
}


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

function normalize_commit(x, i, arr)
{
	arr[i].date = null; /* don't need this */
	//console.log("Setting date to NULL");
	//console.log(commit_log[i].date);
	arr[i].age = null; /* don't need this */
	arr[i].email = null; /* don't need this */
	arr[i].message = null; /* don't need this */
	arr[i].author =
		normalize_illumos_author(x.author);
	arr[i].commitDate =
		normalize_date(x.commitDate);
	arr[i].stat.forEach(normalize_stat);
/*
	console.log("NORM DATE");
	console.log(commit_log[i].date);
	console.log("NORM COMMIT");
	console.log(commit_log[i]);
*/
}

function normalize_commit_log(ignored, callback)
{
	console.log("start normalization ");
	commit_log.forEach(normalize_commit);
	console.log("end normalization");
	callback(null, commit_log);
}

var dest = {};
/* First and last commit on author */
var first_commit = new Array();
var last_commit = new Array();

/*
 * This function, when given a commit, takes the author's name, makes it
 * posix-fs friendly, creates a json file just for that author, and streams
 * only the author's commits to that json file. Does this for all authors.
 * Returns a drain boolean;
 */
function parallel_log(x, index, arr)
{
	/*
	 * Replace spaces and slashes.
	 */
	file_name = x.author.replace(new RegExp(' ', 'g'), "_");
	file_name = file_name.replace(new RegExp('/', 'g'), "&");
	file_name = file_name.concat(".json");
	path_name = auth_dir.concat("/");
	path_name = path_name.concat(file_name);
	comma = true;
	if (dest[path_name] == null) {
		dest[path_name] = fs.createWriteStream(path_name, { flags: 'w',
			encoding:'utf8', mode: 0666});
		/* open the json array */
		dest[path_name].write("[", 'utf8');
		comma = false;
	}
	if (comma == true) {
		ok = dest[path_name].write(",", 'utf8'); 
	}
	ok = dest[path_name].write(JSON.stringify(x), 'utf8'); 
	return (ok);
/*
	fs.open(path_name, "w", function (err, fd) {
		fs.createWriteStream(path_name
	});
*/
	/*
	 * We handle the files, now.
 	 */
	i = 0;
	while (false && i < x.stat.length) {
		if (fpar_logs[x.stat[i].path] == null) {
			fpar_logs[x.stat[i].path] = new Array();
		}
		end = fpar_logs[x.stat[i].path].length;
		fpar_logs[x.stat[i].path][end] = index;
		i++;
	}
}

/*
 * This function goes over the commit-log, and collects stats on the authors.
 * We want to know:
 *
 *	-date of first commit to repo
 *	-date of last commit to repo
 *	-files modified
 *	-lines modified
 *	-mean, mode, median, max, min time between commits
 *	-commit/line distribution by day of week
 *	-commit/line distribution by month of year
 *
 * In other words, we create parallel commit-logs for each author.
 *
 * We also want parallel commit logs for each file-path.
 */
function distill_commits(ignored, callback)
{
	console.log("start distilling\n");
	length = commit_log.length;
	i = 0;
	nulls = 0;
	while (i < length) {
		ok = parallel_log(commit_log[i], i, commit_log);
		/*
		if (!ok && i < length) {
		}
		*/
		i++;
	}
	/*
	 * So, we've finished all of the logs, which means that we've finished
	 * all of the authors. Now we have to append a closing "]" to the
	 * author-jsons and close those files.
	 */
	Object.keys(dest).forEach(function (key, index) {
		//dest[key].write("]", 'utf8');
		dest[key].end("]", 'utf8');
	});
	callback(null, null);
	console.log("end distilling\n");
}

/*
 * Execute the series.
 */

console.log(vasync.pipeline({
	'funcs': [
		read_json_log,
		normalize_commit_log,
		distill_commits
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
