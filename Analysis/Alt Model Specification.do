*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Alt. Specifications) - Table 3
*-------------------------
gen week = week(date)
foreach var of varlist labour_unrest {
ppmlhdfe `var' ///
        i.num_above_90_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	estimates store `var'_Base
	
ppmlhdfe `var' ///
       i.num_above_90_60d ///
    i.month ///
    if year != 2020  & season == 3, ///
    absorb(fips state_year) cluster(fips date) offset(log_firms)
	
	estimates store `var'_SY
	
	ppmlhdfe `var' ///
        i.num_above_90_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(county_month) cluster(fips date) offset(log_firms)
	
	estimates store `var'_CM
	
	ppmlhdfe `var' ///
        i.num_above_90_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips week) cluster(fips date) offset(log_firms)
	
	estimates store `var'_W
	
	ppmlhdfe `var' ///
        i.num_above_90_60d ///
    if year != 2020 & season == 3, ///
    absorb(fips month_year) cluster(fips date) offset(log_firms)
	
	estimates store `var'_MY
}

esttab labour_unrest_Base labour_unrest_SY labour_unrest_CM labour_unrest_W labour_unrest_MY using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\alt_spec_strike.tex", replace ///
    keep(1.num_above_90_60d 2.num_above_90_60d 3.num_above_90_60d) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}\begin{tabular}{l*{5}{c}}\toprule") ///
	postfoot("\midrule \\ County & \checkmark & \checkmark & & \checkmark & \checkmark \\ Month & \checkmark & \checkmark & & & \\ Year & \checkmark & & \checkmark & \checkmark & \\ State-Year & & \checkmark & & & \\ County-Month & & & \checkmark & & \\ Week FE & & & & \checkmark & \\ Month-Year & & & & & \checkmark \\ \bottomrule \end{tabular}")
	
*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Leads) - Table 3
*-------------------------
*egen hot_day_lead = rowtotal(tavg_norm_above_3sd_lead_30d)
gen num_above_90_60d_lead = 0
replace num_above_90_60d_lead = 1 if nn_tavg_above_90_lead_60d  > 0
replace num_above_90_60d_lead = 2 if nn_tavg_above_90_lead_60d  > 19
replace num_above_90_60d_lead = 3 if nn_tavg_above_90_lead_60d  > 39

foreach var of varlist labour_unrest {
ppmlhdfe `var' ///
    i.num_above_90_60d ///
	i.num_above_90_60d_lead ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	estimates store `var'_r
}
label var labour_unrest "Labour Conflict"
label var protest "Protests"
label var strike "Strikes"

esttab labour_unrest_r using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\alt_lead_strike.tex", replace ///
    keep(1.num_above_90_60d 2.num_above_90_60d 3.num_above_90_60d 1.num_above_90_60d_lead 2.num_above_90_60d_lead 3.num_above_90_60d_lead) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs ///
	prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}\begin{tabular}{l*{1}{c}}\toprule") ///
	postfoot("\midrule County, Month, Year FE & \checkmark \\ Con. Temp. & \checkmark \\ \# Obs. & 155,480 \\ \bottomrule \end{tabular}")

*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Alt Window Lenght) - Table 3
*-------------------------
foreach var of varlist labour_unrest {
ppmlhdfe `var' ///
    i.num_above_90_30d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)

estimates store `var'_30d

esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_30d_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest {
ppmlhdfe `var' ///
    i.num_above_90_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
estimates store `var'_60d
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_60d_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest {
ppmlhdfe `var' ///
    i.num_above_90_90d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)

estimates store `var'_90d
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_90d_`var'.csv", ///
cells("b se") noobs plain replace
}

esttab labour_unrest_30d labour_unrest_60d labour_unrest_90d using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\alt_lenght_strike.tex", replace ///
    keep(1.num_above_90_30d 2.num_above_90_30d 3.num_above_90_30d 1.num_above_90_60d 2.num_above_90_60d 3.num_above_90_60d 1.num_above_90_90d 2.num_above_90_90d 3.num_above_90_90d) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}\begin{tabular}{l*{5}{c}}\toprule") ///
	postfoot(" \midrule County, Month, Year FE & \checkmark & \checkmark & \checkmark \\ \bottomrule \addlinespace \end{tabular} ")
	
	
*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Alt Theshold Level) - Table 3
*-------------------------
foreach var of varlist labour_unrest {
ppmlhdfe `var' ///
    i.num_above_90_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)

estimates store `var'_90F

*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest {
ppmlhdfe `var' ///
    i.num_above_85_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)

estimates store `var'_85F

*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest {
ppmlhdfe `var' ///
    i.num_above_80_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)

estimates store `var'_80F

*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}

esttab labour_unrest_90F labour_unrest_85F labour_unrest_80F using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\alt_threshold_LC.tex", replace ///
    keep(1.num_above_90_60d 2.num_above_90_60d 3.num_above_90_60d 1.num_above_85_60d 2.num_above_85_60d 3.num_above_85_60d 1.num_above_80_60d 2.num_above_80_60d 3.num_above_80_60d ) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}\begin{tabular}{l*{5}{c}}\toprule") ///
	postfoot(" \midrule County, Month, Year FE & \checkmark & \checkmark & \checkmark \\ \bottomrule \addlinespace \end{tabular} ")
	
*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Share of Days) - Table 3
*-------------------------
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
    c.share_above_90_60d ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}

*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Alternative Bin Structure) - Table 3
*-------------------------
foreach var of varlist labour_unrest {
ppmlhdfe `var' ///
    i.num_above_90_60d_10I ///
    i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
estimates store `var'_10I
*esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}

esttab labour_unrest_10I using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_Jan2026\alt_BinStructure_LC.tex", replace ///
    keep(1.num_above_90_60d_10I 2.num_above_90_60d_10I 3.num_above_90_60d_10I 4.num_above_90_60d_10I 5.num_above_90_60d_10I) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}\begin{tabular}{l*{5}{c}}\toprule") ///
	postfoot(" \midrule County, Month, Year FE & \checkmark & \checkmark & \checkmark \\ \bottomrule \addlinespace \end{tabular} ")