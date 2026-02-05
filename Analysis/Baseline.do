*-------------------------
* 1. Baseline: Labour Unrest, Strikes, Protests (Summer Heat)
*-------------------------
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
    c.nn_tavg_above_90_lag_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_linear_`var'.csv", ///
cells("b se") noobs plain replace
}


foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
    i.num_above_90_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}

* old
label var labour_unrest "Labour Conflict"
label var protest "Protests"
label var strike "Strikes"

esttab labour_unrest_r protest_r strike_r using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_`var'.csv", ///
    keep(hot_day) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs
	
	
	
	prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}\begin{tabular}{l*{3}{c}}\toprule") ///
	postfoot("\midrule  \# Obs. & 117024 & 85744 & 71024 \\ \bottomrule")
	\\ County, Month, Year FE & \checkmark & \checkmark & \checkmark \\ Con. Temp. & \checkmark & \checkmark & \checkmark \\
	\end{tabular}
	

*-------------------------
* 2. Hetro: Climate Regions (Figure)
*-------------------------
foreach var of varlist labour_unrest protest strike  {	
ppmlhdfe `var' ///
        tavg_norm ///
        i.num_above_90_60d ///
    i.year ///
    if year != 2020 & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cdd_1_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike  {	
ppmlhdfe `var' ///
        tavg_norm ///
        i.num_above_90_60d ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cdd_2_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike  {	
ppmlhdfe `var' ///
        tavg_norm ///
        i.num_above_90_60d ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_quartile == 1, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
}
