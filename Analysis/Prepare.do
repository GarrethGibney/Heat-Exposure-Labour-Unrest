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
 
******* Relative Temperature Measures *********
*-------------------------
* 1. Combine current-day bins
*-------------------------

egen tavg_sd_below3 = rowtotal(tavg_norm_below_m3sd)                                // < -3 SD
egen tavg_sd_n3_n2  = rowtotal(tavg_norm_sd_m30 tavg_norm_sd_m25)                   // [-3, -2)
egen tavg_sd_n2_n1  = rowtotal(tavg_norm_sd_m20 tavg_norm_sd_m15)                   // [-2, -1)
egen tavg_sd_n1_0   = rowtotal(tavg_norm_sd_m10 tavg_norm_sd_m05)                   // [-1,  0)
egen tavg_sd_0_1    = rowtotal(tavg_norm_sd_00 tavg_norm_sd_05)                     // [ 0,  1)
egen tavg_sd_1_2    = rowtotal(tavg_norm_sd_10 tavg_norm_sd_15)                     // [ 1,  2)
egen tavg_sd_2_3    = rowtotal(tavg_norm_sd_20 tavg_norm_sd_25)                     // [ 2,  3)
egen tavg_sd_above3 = rowtotal(tavg_norm_above_3sd)                                // > +3 SD

*-------------------------
* 2. Combine lagged 30-day bins
*-------------------------

egen tavg_sd_below3_lag = rowtotal(tavg_norm_below_m3sd_lag_30d)                    // < -3 SD
egen tavg_sd_n3_n2_lag  = rowtotal(tavg_norm_sd_m30_lag_30d tavg_norm_sd_m25_lag_30d) // [-3, -2)
egen tavg_sd_n2_n1_lag  = rowtotal(tavg_norm_sd_m20_lag_30d tavg_norm_sd_m15_lag_30d) // [-2, -1)
egen tavg_sd_n1_0_lag   = rowtotal(tavg_norm_sd_m10_lag_30d tavg_norm_sd_m05_lag_30d) // [-1,  0)
egen tavg_sd_0_1_lag    = rowtotal(tavg_norm_sd_00_lag_30d tavg_norm_sd_05_lag_30d)   // [ 0,  1)
egen tavg_sd_1_2_lag    = rowtotal(tavg_norm_sd_10_lag_30d tavg_norm_sd_15_lag_30d)   // [ 1,  2)
egen tavg_sd_2_3_lag    = rowtotal(tavg_norm_sd_20_lag_30d tavg_norm_sd_25_lag_30d)   // [ 2,  3)
egen tavg_sd_above3_lag = rowtotal(tavg_norm_above_3sd_lag_30d)                     // > +3 SD

*-------------------------
* 2. Combine lagged 7-day bins
*-------------------------

egen tavg_sd_below3_lag_7 = rowtotal(tavg_norm_below_m3sd_lag_7)                         // < -3 SD
egen tavg_sd_n3_n2_lag_7  = rowtotal(tavg_norm_sd_m30_lag_7 tavg_norm_sd_m25_lag_7)      // [-3, -2)
egen tavg_sd_n2_n1_lag_7  = rowtotal(tavg_norm_sd_m20_lag_7 tavg_norm_sd_m15_lag_7)      // [-2, -1)
egen tavg_sd_n1_0_lag_7   = rowtotal(tavg_norm_sd_m10_lag_7 tavg_norm_sd_m05_lag_7)      // [-1,  0)
egen tavg_sd_0_1_lag_7    = rowtotal(tavg_norm_sd_00_lag_7  tavg_norm_sd_05_lag_7)       // [ 0,  1)
egen tavg_sd_1_2_lag_7    = rowtotal(tavg_norm_sd_10_lag_7 tavg_norm_sd_15_lag_7)        // [ 1,  2)
egen tavg_sd_2_3_lag_7    = rowtotal(tavg_norm_sd_20_lag_7 tavg_norm_sd_25_lag_7)        // [ 2,  3)
egen tavg_sd_above3_lag_7 = rowtotal(tavg_norm_above_3sd_lag_7)                           // > +3 SD

*-------------------------
* 2. Combine lagged 14-day bins
*-------------------------

egen tavg_sd_below3_lag_14 = rowtotal(tavg_norm_below_m3sd_lag_14)                        // < -3 SD
egen tavg_sd_n3_n2_lag_14  = rowtotal(tavg_norm_sd_m30_lag_14 tavg_norm_sd_m25_lag_14)    // [-3, -2)
egen tavg_sd_n2_n1_lag_14  = rowtotal(tavg_norm_sd_m20_lag_14 tavg_norm_sd_m15_lag_14)    // [-2, -1)
egen tavg_sd_n1_0_lag_14   = rowtotal(tavg_norm_sd_m10_lag_14 tavg_norm_sd_m05_lag_14)    // [-1,  0)
egen tavg_sd_0_1_lag_14    = rowtotal(tavg_norm_sd_00_lag_14  tavg_norm_sd_05_lag_14)     // [ 0,  1)
egen tavg_sd_1_2_lag_14    = rowtotal(tavg_norm_sd_10_lag_14 tavg_norm_sd_15_lag_14)      // [ 1,  2)
egen tavg_sd_2_3_lag_14    = rowtotal(tavg_norm_sd_20_lag_14 tavg_norm_sd_25_lag_14)      // [ 2,  3)
egen tavg_sd_above3_lag_14 = rowtotal(tavg_norm_above_3sd_lag_14)                         // > +3 SD

*-------------------------
* 2. Combine lagged 60-day bins
*-------------------------

egen tavg_sd_below3_lag_60 = rowtotal(tavg_norm_below_m3sd_lag_60)                        // < -3 SD
egen tavg_sd_n3_n2_lag_60  = rowtotal(tavg_norm_sd_m30_lag_60 tavg_norm_sd_m25_lag_60)    // [-3, -2)
egen tavg_sd_n2_n1_lag_60  = rowtotal(tavg_norm_sd_m20_lag_60 tavg_norm_sd_m15_lag_60)    // [-2, -1)
egen tavg_sd_n1_0_lag_60   = rowtotal(tavg_norm_sd_m10_lag_60 tavg_norm_sd_m05_lag_60)    // [-1,  0)
egen tavg_sd_0_1_lag_60    = rowtotal(tavg_norm_sd_00_lag_60  tavg_norm_sd_05_lag_60)     // [ 0,  1)
egen tavg_sd_1_2_lag_60    = rowtotal(tavg_norm_sd_10_lag_60 tavg_norm_sd_15_lag_60)      // [ 1,  2)
egen tavg_sd_2_3_lag_60    = rowtotal(tavg_norm_sd_20_lag_60 tavg_norm_sd_25_lag_60)      // [ 2,  3)
egen tavg_sd_above3_lag_60 = rowtotal(tavg_norm_above_3sd_lag_60)                         // > +3 SD

*-------------------------
* 2. Combine lagged 30-day bins (Absolute Temperature)
*-------------------------
egen nn_tavg_below_10_lag = rowtotal(nn_tavg_below_10_lag_30d)                        
egen nn_tavg_10_20_lag  = rowtotal(nn_tavg_10_15_lag_30d nn_tavg_15_20_lag_30d)   
egen nn_tavg_20_30_lag  = rowtotal(nn_tavg_20_25_lag_30d nn_tavg_25_30_lag_30d)    
egen nn_tavg_30_40_lag  = rowtotal(nn_tavg_30_35_lag_30d nn_tavg_35_40_lag_30d)    
egen nn_tavg_40_50_lag    = rowtotal(nn_tavg_40_45_lag_30d nn_tavg_45_50_lag_30d)     
egen nn_tavg_50_60_lag    = rowtotal(nn_tavg_50_55_lag_30d nn_tavg_55_60_lag_30d)      
egen nn_tavg_60_70_lag    = rowtotal(nn_tavg_60_65_lag_30d nn_tavg_65_70_lag_30d)     
egen nn_tavg_70_80_lag = rowtotal(nn_tavg_70_75_lag_30d nn_tavg_75_80_lag_30d)                         
egen nn_tavg_80_90_lag = rowtotal(nn_tavg_80_85_lag_30d nn_tavg_85_90_lag_30d) 
egen nn_tavg_above_90_lag = rowtotal(nn_tavg_above_90_lag_30d) 

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