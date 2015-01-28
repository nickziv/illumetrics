BEGIN {
	ngcom = 0;
	ogcom = 0;
}

{
	if ($1 == "true") {
		ngcom += $2
		ngfil += $3
		nglnm += $4
		nglna += $5
		nglnr += $6
	} else {
		ogcom += $2
		ogfil += $3
		oglnm += $4
		oglna += $5
		oglnr += $6
	}
}

END {
	print ogcom, ngcom, ogfil, ngfil, oglnm, nglnm, oglna, nglna, oglnr, nglnr;
}
