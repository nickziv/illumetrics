/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */


/*
 * Copyright (c) 2014, Nick Zivkovic
 */

/*
 * This script merges the two JSON output files into a single file, and writes
 * it to stdout.
 */
var util = require('util');
var fs = require('fs');
var gitLog, lstat;

var log_json = process.argv[2];
var numstat_json = process.argv[3];
var merged;


fs.readFile(log_json, 'utf8', function (err, data) {
	if (err) {
		return console.log(err);
	}
	gitLog = JSON.parse(data);
	fs.readFile(numstat_json, function (err, data) {
		if (err) {
			return console.log(err);
		}
		lstat = JSON.parse(data);
		merged = gitLog.map(function(elem) {
			elem.stat = lstat[elem.hash];
			return elem;
			//console.log(elem);
		});
		//console.log(merged[0]);
		var strlog = JSON.stringify(merged);
		console.log(strlog);
	});
});
