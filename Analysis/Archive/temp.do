*------------------------------------------------------
* Step 1: Run each specification and save sample indicators
*------------------------------------------------------

* Preferred: fips + month + year FE
ppmlhdfe labour_unrest ///
    c.nn_tavg_above_90_lag_90d i.year ///
    if year != 2020 & season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
gen sample_pref = e(sample)

* Ranson: state_month + county_year FE
ppmlhdfe labour_unrest ///
    c.nn_tavg_above_90_lag_90d ///
    if year != 2020 & season == 3, ///
    absorb(state_month county_year) cluster(state_year) offset(log_emp)
gen sample_ranson = e(sample)

* Demanding: county_month + year FE
ppmlhdfe labour_unrest ///
    c.nn_tavg_above_90_lag_90d ///
    if year != 2020 & season == 3, ///
    absorb(county_month year) cluster(state_year) offset(log_emp)
gen sample_cm = e(sample)

*------------------------------------------------------
* Step 2: Verify sample sizes match regression output
*------------------------------------------------------

count if sample_pref    
count if sample_ranson  
count if sample_cm      

*------------------------------------------------------
* Step 3: Within-cell SD of continuous treatment
* by specification sample
*------------------------------------------------------

* Preferred
reghdfe nn_tavg_above_90_lag_90d if sample_pref, ///
    absorb(fips month year) residuals(resid_cont_pref)
sum resid_cont_pref if sample_pref

* Ranson
reghdfe nn_tavg_above_90_lag_90d if sample_ranson, ///
    absorb(state_month county_year) residuals(resid_cont_ranson)
sum resid_cont_ranson if sample_ranson

* County×month
reghdfe nn_tavg_above_90_lag_90d if sample_cm, ///
    absorb(county_month year) residuals(resid_cont_cm)
sum resid_cont_cm if sample_cm

*------------------------------------------------------
* Step 4: Within-cell SD for each bin indicator
* by specification sample
*------------------------------------------------------

* Generate bin indicators
gen heat_bin1 = (num_above_90_90d == 1)
gen heat_bin2 = (num_above_90_90d == 2)
gen heat_bin3 = (num_above_90_90d == 3)
gen heat_bin4 = (num_above_90_90d >= 4)

* Loop over bins and specifications
foreach bin in 1 2 3 4 {
    
    * Preferred
    reghdfe heat_bin`bin' if sample_pref, ///
        absorb(fips month year) residuals(resid_bin`bin'_pref)
    sum resid_bin`bin'_pref if sample_pref
    
    * Ranson
    reghdfe heat_bin`bin' if sample_ranson, ///
        absorb(state_month county_year) residuals(resid_bin`bin'_ranson)
    sum resid_bin`bin'_ranson if sample_ranson
    
    * County×month
    reghdfe heat_bin`bin' if sample_cm, ///
        absorb(county_month year) residuals(resid_bin`bin'_cm)
    sum resid_bin`bin'_cm if sample_cm
}

*------------------------------------------------------
* Step 5: Share of cells containing each bin
* by specification sample
*------------------------------------------------------

* Preferred cells
egen cell_pref = group(fips month year) if sample_pref

foreach bin in 1 2 3 4 {
    bysort cell_pref: ///
        egen has_bin`bin'_pref = max(heat_bin`bin') if sample_pref
}
sum has_bin1_pref has_bin2_pref has_bin3_pref has_bin4_pref ///
    if sample_pref

* Ranson cells — use county_year as the relevant cell
* since identification comes from within county-year variation
egen cell_ranson = group(county_year) if sample_ranson

foreach bin in 1 2 3 4 {
    bysort cell_ranson: ///
        egen has_bin`bin'_ranson = max(heat_bin`bin') if sample_ranson
}
sum has_bin1_ranson has_bin2_ranson has_bin3_ranson has_bin4_ranson ///
    if sample_ranson

* County×month cells
egen cell_cm = group(county_month) if sample_cm

foreach bin in 1 2 3 4 {
    bysort cell_cm: ///
        egen has_bin`bin'_cm = max(heat_bin`bin') if sample_cm
}
sum has_bin1_cm has_bin2_cm has_bin3_cm has_bin4_cm ///
    if sample_cm

*------------------------------------------------------
* Step 6: Collect results into a summary table
*------------------------------------------------------

* Continuous treatment within-cell SD
foreach spec in pref ranson cm {
    quietly sum resid_cont_`spec' if sample_`spec'
    di "Continuous SD (`spec'): " r(sd)
}

* Bin within-cell SDs
foreach bin in 1 2 3 4 {
    foreach spec in pref ranson cm {
        quietly sum resid_bin`bin'_`spec' if sample_`spec'
        di "Bin `bin' SD (`spec'): " r(sd)
    }
}

* Share of cells with each bin
foreach bin in 1 2 3 4 {
    foreach spec in pref ranson cm {
        quietly sum has_bin`bin'_`spec' if sample_`spec'
        di "Share of cells with bin `bin' (`spec'): " r(mean)
    }
}
}

foreach spec in pref ranson cm {
    foreach var of varlist labour_unrest strike protest {
        quietly sum `var' if sample_`spec'
        di "`var' (`spec') — share zero: " 1 - r(mean)/r(mean)
        quietly count if `var' == 0 & sample_`spec'
        scalar zeros = r(N)
        quietly count if sample_`spec'
        di "`var' (`spec') — share zero: " zeros/r(N)
    }
}

foreach spec in pref ranson cm {
    foreach var of varlist labour_unrest strike protest {
        quietly sum `var' if `var' > 0 & sample_`spec'
        di "`var' (`spec') — mean conditional on positive: " r(mean)
        di "`var' (`spec') — SD conditional on positive: " r(sd)
        di "`var' (`spec') — max: " r(max)
    }
}

foreach spec in pref ranson cm {
    di "Treatment distribution in `spec' sample:"
    tab num_above_90_90d if sample_`spec', missing
}

foreach spec in pref ranson cm {
    quietly distinct fips if sample_`spec'
    di "Unique counties (`spec'): " r(ndistinct)
}