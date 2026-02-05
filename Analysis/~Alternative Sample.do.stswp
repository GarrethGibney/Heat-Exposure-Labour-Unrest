
* Set-up *
global path "C:/Users/20234503/Desktop/Research/Weather and Strikes/Project/"
import delimited "${path}Data/Weather_Labour_Unrest_Event_nodup_cd.csv", clear

* Processing Data
gen date2 = date(date, "YMD")
drop date
rename date2 date
format date %td
xtset fips date

gen month = month(date)
gen year = year(date)

* Seasons *
gen season = .
replace season = 1 if inlist(month, 12, 1, 2)   // Winter: Dec, Jan, Feb
replace season = 2 if inlist(month, 3, 4, 5)    // Spring: Mar, Apr, May
replace season = 3 if inlist(month, 6, 7, 8)    // Summer: Jun, Jul, Aug
replace season = 4 if inlist(month, 9, 10, 11)  // Autumn: Sep, Oct, Nov

label define seasonlbl 1 "Winter" 2 "Spring" 3 "Summer" 4 "Autumn"
label values season seasonlbl

******* Basline Model ***********
gen log_firms = log(est) - ln(100000)
gen log_emp = log(emp) - ln(100000)

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
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\baseline_`var'_nodup.csv", ///
cells("b se") noobs plain replace
}

*-------------------------
* 2. Hetro: Climate Regions (Figure)
*-------------------------
foreach var of varlist strike  {	
ppmlhdfe `var' ///
        tavg_norm ///
        c.hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cdd_1_`var'_nodup.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike  {	
ppmlhdfe `var' ///
        tavg_norm ///
        c.hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3 & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cdd_2_`var'_nodup.csv", ///
cells("b se") noobs plain replace
}

* Set-up *
global path "C:/Users/20234503/Desktop/Research/Weather and Strikes/Project/"
import delimited "${path}Data/Weather_Labour_Unrest_Event_Weighted.csv", clear

* Processing Data
gen date2 = date(date, "YMD")
drop date
rename date2 date
format date %td
xtset fips date

gen month = month(date)
gen year = year(date)

* Seasons *
gen season = .
replace season = 1 if inlist(month, 12, 1, 2)   // Winter: Dec, Jan, Feb
replace season = 2 if inlist(month, 3, 4, 5)    // Spring: Mar, Apr, May
replace season = 3 if inlist(month, 6, 7, 8)    // Summer: Jun, Jul, Aug
replace season = 4 if inlist(month, 9, 10, 11)  // Autumn: Sep, Oct, Nov

label define seasonlbl 1 "Winter" 2 "Spring" 3 "Summer" 4 "Autumn"
label values season seasonlbl

******* Basline Model ***********
gen log_firms = log(est) - ln(100000)
gen log_emp = log(emp) - ln(100000)

*-------------------------
* 1. Baseline: Labour Unrest, Strikes, Protests (Summer Heat)
*-------------------------
egen hot_day = rowtotal(tavg_norm_above_3sd_lag_30d)

foreach var of varlist strike_weighted {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3, ///
    absorb(fips month) cluster(fips date) offset(log_emp)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\baseline_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike_weighted {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3  & cdd_median == 1, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cdd_1_`var'.csv", ///
cells("b se") noobs plain replace
}

foreach var of varlist strike_weighted {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == 3  & cdd_median == 2, ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\cdd_2_`var'.csv", ///
cells("b se") noobs plain replace
}

