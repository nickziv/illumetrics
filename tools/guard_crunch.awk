# Column 1 is the number of commits, 2 is the new_guard boolean, and everything
# else is the author name
{
	if ($6 == "true") {
		if (ngcom > 0) {
			com_guard_ratio = $1 / ngcom;
		} else {
			com_guard_ratio = "N/A";
		}
		if (ngfil > 0) {
			fil_guard_ratio = $2 / ngcom;
		} else {
			fil_guard_ratio = "N/A";
		}
		if (nglnm > 0) {
			lnm_guard_ratio = $3 / ngcom;
		} else {
			lnm_guard_ratio = "N/A";
		}
		if (nglna > 0) {
			lna_guard_ratio = $4 / ngcom;
		} else {
			lna_guard_ratio = "N/A";
		}
		if (nglnr > 0) {
			lnr_guard_ratio = $5 / ngcom;
		} else {
			lnr_guard_ratio = "N/A";
		}
	} else {
		if (ogcom > 0) {
			com_guard_ratio = $1 / ogcom;
		} else {
			com_guard_ratio = "N/A";
		}
		if (ogfil > 0) {
			fil_guard_ratio = $2 / ngcom;
		} else {
			fil_guard_ratio = "N/A";
		}
		if (oglnm > 0) {
			lnm_guard_ratio = $3 / ngcom;
		} else {
			lnm_guard_ratio = "N/A";
		}
		if (oglna > 0) {
			lna_guard_ratio = $4 / ngcom;
		} else {
			lna_guard_ratio = "N/A";
		}
		if (oglnr > 0) {
			lnr_guard_ratio = $5 / ngcom;
		} else {
			lnr_guard_ratio = "N/A";
		}
	}
	com_tot_ratio = $1 / totcom;
	fil_tot_ratio = $2 / totfil;
	lnm_tot_ratio = $3 / totlnm;
	lna_tot_ratio = $4 / totlna;
	lnr_tot_ratio = $5 / totlnr;

	print $1 ",", $2 ",", $3 ",", $4",", $5",", $6",", com_guard_ratio",",
	fil_guard_ratio",", lnm_guard_ratio",", lna_guard_ratio",",
	lnr_guard_ratio",", com_tot_ratio",", fil_tot_ratio",",
	lnm_tot_ratio",", lna_tot_ratio",", lnr_tot_ratio",", $7, $8, $9, $10;
}
