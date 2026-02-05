*Alt Window Lenght
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
    i.num_above_90_30d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
    i.num_above_90_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
    i.num_above_90_90d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}



* Alt Threshold
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
    i.num_above_80_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}