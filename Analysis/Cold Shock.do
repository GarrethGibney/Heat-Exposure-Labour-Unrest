**** NEW *****
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
    i.num_above_90_60d ///
	i.num_below_10_30d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\cold_30_`var'.csv", ///
cells("b se") noobs plain replace
}


*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Cold Shocks) - Alt. Thesholds
*-------------------------
egen cold_day_1 = rowtotal(tavg_norm_sd_m30_lag_30d)
egen cold_day_2 = rowtotal(tavg_norm_sd_m30_lag_30d tavg_norm_sd_m25_lag_30d)
egen cold_day_3 = rowtotal(tavg_norm_sd_m30_lag_30d tavg_norm_sd_m25_lag_30d tavg_norm_sd_m20_lag_30d)
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_1 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_day_1_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_2 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_day_2_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_3 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_day_3_`var'.csv", ///
cells("b se") noobs plain replace
}

* Climate Region 
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_1 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_day_1_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_2 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_day_2_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_3 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_day_3_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_1 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_day_1_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_2 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
			esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_day_2_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_3 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
			esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_day_3_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Cold Shocks) - Alt. Window Length
*-------------------------
egen cold_day_7 = rowtotal(tavg_norm_sd_m30_lag_7d)
egen cold_day_14 = rowtotal(tavg_norm_sd_m30_lag_14d)
egen cold_day_30 = rowtotal(tavg_norm_sd_m30_lag_30d)
egen cold_day_60 = rowtotal(tavg_norm_sd_m30_lag_60d)

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_7 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_7_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_14 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_14_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_30 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_30_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_60 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

			esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_60_`var'.csv", ///
cells("b se") noobs plain replace
}

* Climate Regions
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_7 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_7_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_14 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_14_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_30 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_30_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_60 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

			esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_60_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_7 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_7_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_14 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_14_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_30 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_30_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        cold_day_60 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 1 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

			esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cold_window_60_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

