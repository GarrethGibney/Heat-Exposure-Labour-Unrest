* Set-up *
global path "C:/Users/20234503/Dropbox/PhD Project/Research/Weather and Strikes/Project/"
import delimited "${path}Data/Weather_Labour_Unrest_Event.csv", clear

* Processing Data
gen date2 = date(date, "YMD")
drop date
rename date2 date
format date %td
xtset fips date

gen month = month(date)
gen week = week(date)
gen year = year(date)
egen county_month = group(fips month)
egen county_year = group(fips year)
gen month_year = ym(year(date), month(date))
format month_year %tm
encode state, gen(state_encoded)
egen state_year = group(state year)
egen state_date = group(state date)
egen state_month = group(state month)
egen year_month = group(month year)
gen doy = doy(date)
egen fips_date = group(fips date)
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
gen num_above_90_14d = 0
replace num_above_90_14d = 1 if nn_tavg_above_90_lag_14d  > 0
replace num_above_90_14d = 2 if nn_tavg_above_90_lag_14d  > 9

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

* (Alt Frequency of bin Interval)
gen num_above_90_60d_5b = 0
replace num_above_90_60d_5b = 1 if nn_tavg_above_90_lag_60d  > 0
replace num_above_90_60d_5b = 2 if nn_tavg_above_90_lag_60d  > 9
replace num_above_90_60d_5b = 3 if nn_tavg_above_90_lag_60d  > 19
replace num_above_90_60d_5b = 4 if nn_tavg_above_90_lag_60d  > 29


gen num_above_90_60d_9b = 0
replace num_above_90_60d_9b = 1 if nn_tavg_above_90_lag_60d  > 0
replace num_above_90_60d_9b = 2 if nn_tavg_above_90_lag_60d  > 4
replace num_above_90_60d_9b = 3 if nn_tavg_above_90_lag_60d  > 9
replace num_above_90_60d_9b = 4 if nn_tavg_above_90_lag_60d  > 14
replace num_above_90_60d_9b = 5 if nn_tavg_above_90_lag_60d  > 19
replace num_above_90_60d_9b = 6 if nn_tavg_above_90_lag_60d  > 24
replace num_above_90_60d_9b = 7 if nn_tavg_above_90_lag_60d  > 29
replace num_above_90_60d_9b = 8 if nn_tavg_above_90_lag_60d  > 34
replace num_above_90_60d_9b = 9 if nn_tavg_above_90_lag_60d  > 39

* Cold Exposure *
egen below_45_60d = rowtotal( nn_tavg_40_45_lag_60d /// 
						nn_tavg_35_40_lag_60d ///
						nn_tavg_30_35_lag_60d ///
                        nn_tavg_25_30_lag_60d ///
                        nn_tavg_20_25_lag_60d ///
						nn_tavg_15_20_lag_60d ///
						nn_tavg_10_15_lag_60d ///
						nn_tavg_below_10_lag_60d ///
						)
						
gen num_below_45_60d = 0
replace num_below_45_60d = 1 if below_45_60d  > 0
replace num_below_45_60d = 2 if below_45_60d  > 19
replace num_below_45_60d = 3 if below_45_60d  > 39


egen below_40_60d = rowtotal( nn_tavg_35_40_lag_60d ///
						nn_tavg_30_35_lag_60d ///
                        nn_tavg_25_30_lag_60d ///
                        nn_tavg_20_25_lag_60d ///
						nn_tavg_15_20_lag_60d ///
						nn_tavg_10_15_lag_60d ///
						nn_tavg_below_10_lag_60d ///
						)
						
gen num_below_40_60d = 0
replace num_below_40_60d = 1 if below_40_60d  > 0
replace num_below_40_60d = 2 if below_40_60d  > 19
replace num_below_40_60d = 3 if below_40_60d  > 39

					
egen below_35_60d = rowtotal(nn_tavg_30_35_lag_60d ///
                        nn_tavg_25_30_lag_60d ///
                        nn_tavg_20_25_lag_60d ///
						nn_tavg_15_20_lag_60d ///
						nn_tavg_10_15_lag_60d ///
						nn_tavg_below_10_lag_60d ///
						)

gen num_below_35_60d = 0
replace num_below_35_60d = 1 if below_35_60d  > 0
replace num_below_35_60d = 2 if below_35_60d  > 19
replace num_below_35_60d = 3 if below_35_60d  > 39
						
egen below_30_60d = rowtotal(nn_tavg_25_30_lag_60d ///
                        nn_tavg_20_25_lag_60d ///
						nn_tavg_15_20_lag_60d ///
						nn_tavg_10_15_lag_60d ///
						nn_tavg_below_10_lag_60d ///
						)

gen num_below_30_60d = 0
replace num_below_30_60d = 1 if below_30_60d  > 0
replace num_below_30_60d = 2 if below_30_60d  > 19
replace num_below_30_60d = 3 if below_30_60d  > 39


* Alt Exposure Window Length *
egen below_35_30d = rowtotal(nn_tavg_30_35_lag_30d ///
                        nn_tavg_25_30_lag_30d ///
                        nn_tavg_20_25_lag_30d ///
						nn_tavg_15_20_lag_30d ///
						nn_tavg_10_15_lag_30d ///
						nn_tavg_below_10_lag_60d ///
						)

gen num_below_35_30d = 0
replace num_below_35_30d = 1 if below_35_30d  > 0
replace num_below_35_30d = 2 if below_35_30d  > 9
replace num_below_35_30d = 3 if below_35_30d  > 19

egen below_35_90d = rowtotal(nn_tavg_30_35_lag_90d ///
                        nn_tavg_25_30_lag_90d ///
                        nn_tavg_20_25_lag_90d ///
						nn_tavg_15_20_lag_90d ///
						nn_tavg_10_15_lag_90d ///
						nn_tavg_below_10_lag_90d ///
						)

gen num_below_35_90d = 0
replace num_below_35_90d = 1 if below_35_90d  > 0
replace num_below_35_90d = 2 if below_35_90d  > 19
replace num_below_35_90d = 3 if below_35_90d  > 39
replace num_below_35_90d = 4 if below_35_90d  > 59

*!* Lead Heat Bins *!*
gen num_above_90_60d_lead = 0
replace num_above_90_60d_lead = 1 if nn_tavg_above_90_lead_60d  > 0
replace num_above_90_60d_lead = 2 if nn_tavg_above_90_lead_60d  > 19
replace num_above_90_60d_lead = 3 if nn_tavg_above_90_lead_60d  > 39
			
						
