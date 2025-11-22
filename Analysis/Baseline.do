*-------------------------
* 1. Baseline: Labour Unrest, Strikes, Protests (Summer Heat)
*-------------------------
egen hot_day = rowtotal(tavg_norm_above_3sd_lag_30d)
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
	estimates store `var'_r, title("(1)")
}

*-------------------------
* 2. Hetro: Climate Regions (Figure)
*-------------------------
foreach var of varlist strike  {	
ppmlhdfe `var' ///
        tavg_norm ///
        i.cdd_median##c.hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results\`var'_climate_region_Nov25.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike  {	
ppmlhdfe `var' ///
        tavg_norm ///
        c.hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results\`var'_climate_region_Nov25.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike  {	
ppmlhdfe `var' ///
        tavg_norm ///
        c.hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results\`var'_climate_region_Nov25.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike  {	
ppmlhdfe `var' ///
        tavg_norm ///
        i.cdd_quartile##c.hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results\`var'_climate_region_Nov25.csv", ///
cells("b se") noobs plain replace
}