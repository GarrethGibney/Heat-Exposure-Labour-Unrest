* Set-up *
global path "C:/Users/20234503/Dropbox/PhD Project/Research/Weather and Strikes/Project/"
import delimited "${path}Data/Weather_Labour_Unrest_Event_panel.csv", clear

*!* Preparing Data !*!
gen num_above_90_60d = 0
replace num_above_90_60d = 1 if nn_tavg_above_90_lag_60d  > 0
replace num_above_90_60d = 2 if nn_tavg_above_90_lag_60d  > 19
replace num_above_90_60d = 3 if nn_tavg_above_90_lag_60d  > 39

* Seasons *
gen season = .
replace season = 1 if inlist(month, 12, 1, 2)   // Winter: Dec, Jan, Feb
replace season = 2 if inlist(month, 3, 4, 5)    // Spring: Mar, Apr, May
replace season = 3 if inlist(month, 6, 7, 8)    // Summer: Jun, Jul, Aug
replace season = 4 if inlist(month, 9, 10, 11)  // Autumn: Sep, Oct, Nov

label define seasonlbl 1 "Winter" 2 "Spring" 3 "Summer" 4 "Autumn"
label values season seasonlbl

gen log_emp = log(emp) - ln(100000)

sum duration if strike
ppmlhdfe duration ///	
	i.num_above_90_60d ///
    i.year labour_unrest_goods_producing labour_unrest_professional_servi labour_unrest_non_professional_s labour_unrest_transport labour_unrest_healthcare labour_unrest_public_sector ///
    if season == 3 & strike == 1, ///
    absorb(state month) offset(log_emp)
	
ppmlhdfe duration ///	
	i.num_above_90_60d ///
    i.year ///
    if season == 3 & strike != 1, ///
    absorb(state month) offset(log_emp)
	
ppmlhdfe num_demands ///	
	i.num_above_90_60d ///
    i.year labour_unrest_goods_producing labour_unrest_professional_servi labour_unrest_non_professional_s labour_unrest_transport labour_unrest_healthcare labour_unrest_public_sector ///
    if season == 3 & strike == 1, ///
     absorb(state month) offset(log_emp)

ppmlhdfe num_demands ///	
	i.num_above_90_60d ///
    i.year labour_unrest_goods_producing labour_unrest_professional_servi labour_unrest_non_professional_s labour_unrest_transport labour_unrest_healthcare labour_unrest_public_sector ///
    if season == 3 & strike != 1, ///
     absorb(state month) offset(log_emp)
	 
ppmlhdfe approximate_number_of_participan ///	
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
     absorb(fips month) offset(log_emp) 
	 
	 approximate_number_of_participan