* Set-up *
global path "C:/Users/20234503/Desktop/Research/Weather and Strikes/Project/"
import delimited "${path}Data/Weather_Labour_Unrest_Event.csv", clear

* Processing Data
gen date2 = date(date, "YMD")
drop date
rename date2 date
format date %td
xtset fips date

gen month = month(date)
gen year = year(date)
egen county_month = group(fips month)
gen month_year = ym(year(date), month(date))
format month_year %tm
encode state, gen(state_encoded)
egen state_year = group(state year)
egen state_date = group(state date)
egen state_month = group(state month)
gen doy = doy(date)

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

* Temperature Shock *
* (Alt Window Lenght)
gen num_above_90_30d = 0
replace num_above_90_30d = 1 if nn_tavg_above_90_lag_30d  > 0
replace num_above_90_30d = 2 if nn_tavg_above_90_lag_30d  > 9
replace num_above_90_30d = 3 if nn_tavg_above_90_lag_30d  > 19

gen num_above_90_60d = 0
replace num_above_90_60d = 1 if nn_tavg_above_90_lag_60d  > 0
replace num_above_90_60d = 2 if nn_tavg_above_90_lag_60d  > 19
replace num_above_90_60d = 3 if nn_tavg_above_90_lag_60d  > 39

gen num_above_90_90d = 0
replace num_above_90_90d = 1 if nn_tavg_above_90_lag_90d  > 0
replace num_above_90_90d = 2 if nn_tavg_above_90_lag_90d  > 19
replace num_above_90_90d = 3 if nn_tavg_above_90_lag_90d  > 39
replace num_above_90_90d = 4 if nn_tavg_above_90_lag_90d  > 59

* (Alt Temperature Threshold)
egen above_85 = rowtotal(nn_tavg_above_90_lag_60d ///
                        nn_tavg_85_90_lag_60d)

gen num_above_85_60d = 0
replace num_above_85_60d = 1 if above_85  > 0
replace num_above_85_60d = 2 if above_85  > 19
replace num_above_85_60d = 3 if above_85  > 39

egen above_80 = rowtotal(nn_tavg_above_90_lag_60d ///
                        nn_tavg_80_85_lag_60d ///
                        nn_tavg_85_90_lag_60d)

gen num_above_80_60d = 0
replace num_above_80_60d = 1 if above_80  > 0
replace num_above_80_60d = 2 if above_80  > 19
replace num_above_80_60d = 3 if above_80  > 39

* Alternative Bin Structure *
gen num_above_90_60d_10I = 0
replace num_above_90_60d_10I = 1 if nn_tavg_above_90_lag_60d  > 0
replace num_above_90_60d_10I = 2 if nn_tavg_above_90_lag_60d  > 9
replace num_above_90_60d_10I = 3 if nn_tavg_above_90_lag_60d  > 19
replace num_above_90_60d_10I = 4 if nn_tavg_above_90_lag_60d  > 29
replace num_above_90_60d_10I = 5 if nn_tavg_above_90_lag_60d  > 39

* Cold Shock *
gen num_below_10_30d = 0
replace num_below_10_30d = 1 if nn_tavg_below_10_lag_30d  > 0
replace num_below_10_30d = 2 if nn_tavg_below_10_lag_30d > 9
replace num_below_10_30d = 3 if nn_tavg_below_10_lag_30d  > 19