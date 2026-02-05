*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Changin Hot Day Threshold) - Table 3
*-------------------------
egen hot_day_1 = rowtotal(tavg_norm_sd_20_lag_30d tavg_norm_sd_25_lag_30d tavg_norm_above_3sd_lag_30d)
egen hot_day_2 = rowtotal(tavg_norm_sd_25_lag_30d tavg_norm_above_3sd_lag_30d)
egen hot_day_3 = rowtotal(tavg_norm_above_3sd_lag_30d)
*drop hot_day_1 hot_day_2 hot_day_3 hot_day_4
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_1 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\hot_day_1_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_2 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\hot_day_2_`var'.csv", ///
cells("b se") noobs plain replace
	
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_3 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\hot_day_3_`var'.csv", ///
cells("b se") noobs plain replace
}

* Threshold by Climate Region 
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_1 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3  & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\hot_day_1_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_2 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\hot_day_2_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
	
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_3 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\hot_day_3_`var'_CDD1.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_1 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3  & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)

esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\hot_day_1_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_2 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\hot_day_2_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
	
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day_3 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\hot_day_3_`var'_CDD2.csv", ///
cells("b se") noobs plain replace
}

*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Absolute Temperatures) - Table 3
*-------------------------
* tavg >= ~32C (>=90F)
gen heatday_32C = nn_tavg_above_90_lag_30d
label var heatday_32C "Days >= 32C (last 30 days)"

* Heat days: # days in last 30 with tavg >= ~30C
gen heatday_30C = nn_tavg_85_90_lag_30d + nn_tavg_above_90_lag_30d
label var heatday_30C "Days >= 30C (last 30 days)"

* tavg >= ~27C (>=80F)
gen heatday_27C = nn_tavg_80_85_lag_30d ///
                + nn_tavg_85_90_lag_30d ///
                + nn_tavg_above_90_lag_30d
label var heatday_27C "Days >= 27C (last 30 days)"

* tavg >= ~32C (>=90F)
gen heatday_32C_lead = nn_tavg_above_90_lead_30d
label var heatday_32C_lead "Days >= 32C (next 30 days)"

* Heat days: # days in last 30 with tavg >= ~30C
gen heatday_30C_lead = nn_tavg_85_90_lead_30d + nn_tavg_above_90_lead_30d
label var heatday_30C_lead "Days >= 30C (next 30 days)"

* tavg >= ~27C (>=80F)
gen heatday_27C_lead = nn_tavg_80_85_lead_30d ///
                + nn_tavg_85_90_lead_30d ///
                + nn_tavg_above_90_lead_30d
label var heatday_27C_lead "Days >= 27C (next 30 days)"

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        heatday_30C ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
	esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\abs_30_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        heatday_30C ///
		heatday_30C_lead ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\Lead_abs_30_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        heatday_32C ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\abs_32_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        heatday_32C ///
		heatday_32C_lead ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\Lead_abs_32_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        heatday_27C ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
			esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\abs_27_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        heatday_27C ///
		heatday_27C_lead ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\Lead_abs_27_`var'.csv", ///
cells("b se") noobs plain replace
}

*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (SD Bins) - Table 3
*-------------------------
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
        tavg_sd_below3_lag  tavg_sd_n3_n2_lag tavg_sd_n2_n1_lag tavg_sd_1_2_lag tavg_sd_2_3_lag tavg_sd_above3_lag ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
}

*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Abs Bins) - Table 3
*-------------------------
* 1: below 10
egen temp_bin1 = rowtotal(nn_tavg_below_10_lag_30d)

* 2: 10–20
egen temp_bin2 = rowtotal(nn_tavg_10_15_lag_30d nn_tavg_15_20_lag_30d)

* 3: 20–30
egen temp_bin3 = rowtotal(nn_tavg_20_25_lag_30d nn_tavg_25_30_lag_30d)

* 4: 30–40
egen temp_bin4 = rowtotal(nn_tavg_30_35_lag_30d nn_tavg_35_40_lag_30d)

* 5: 40–50
egen temp_bin5 = rowtotal(nn_tavg_40_45_lag_30d nn_tavg_45_50_lag_30d)

* 6: 50–60
egen temp_bin6 = rowtotal(nn_tavg_50_55_lag_30d nn_tavg_55_60_lag_30d)

* 7: 60–70
egen temp_bin7 = rowtotal(nn_tavg_60_65_lag_30d nn_tavg_65_70_lag_30d)

* 8: 70–80
egen temp_bin8 = rowtotal(nn_tavg_70_75_lag_30d nn_tavg_75_80_lag_30d)

* 9: 80–90  (this is the bit you flagged)
egen temp_bin9 = rowtotal(nn_tavg_80_85_lag_30d nn_tavg_85_90_lag_30d)

* 10: >90 (highest bin alone)
egen temp_bin10 = rowtotal(nn_tavg_above_90_lag_30d)

sum temp_bin1 temp_bin2 temp_bin3 temp_bin4 temp_bin5 temp_bin6 temp_bin7 temp_bin8 temp_bin9 temp_bin10 if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        nn_tavg ///
        temp_bin3 temp_bin4 temp_bin5 temp_bin6 temp_bin7 temp_bin9 temp_bin10 ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
}
