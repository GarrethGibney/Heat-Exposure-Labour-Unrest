*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Window Lenght) - Table 3
*-------------------------
egen hot_day_7 = rowtotal(tavg_norm_above_3sd_lag_7d)
foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_7 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_7_`var'.csv", ///
cells("b se") noobs plain replace
}


egen hot_day_14 = rowtotal(tavg_norm_above_3sd_lag_14d)
foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_14 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_14_`var'.csv", ///
cells("b se") noobs plain replace
}

egen hot_day_30 = rowtotal(tavg_norm_above_3sd_lag_30d)
foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_30 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_30_`var'.csv", ///
cells("b se") noobs plain replace
}

egen hot_day_60 = rowtotal(tavg_norm_above_3sd_lag_60d)
foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_60 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_60_`var'.csv", ///
cells("b se") noobs plain replace
}

* Threshold by Climate Region 
foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_7 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_7_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_14 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_14_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_30 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_30_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_60 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_60_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_7 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_7_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_14 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_14_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_30 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_30_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_60 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\window_60_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

