*-------------------------
* 1. Baseline: Labour Unrest
*-------------------------
foreach var of varlist labour_unrest {	

ppmlhdfe `var' ///	
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
	
	esttab using "$path\Results (Final)\Raw\Baseline\baseline_`var'_18052026.csv", ///
        cells("b se") noobs plain replace
}

*-------------------------
* 2. Hetro: Action Type
*-------------------------
foreach var of varlist strike protest {	

ppmlhdfe `var' ///	
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)

	esttab using "$path\Results (Final)\Raw\Type\baseline_`var'_18052026.csv", ///
        cells("b se") noobs plain replace
}

*-------------------------
* 2. Hetro: Sector
*-------------------------
labour_unrest_goods_producing labour_unrest_professional_servi labour_unrest_non_professional_s labour_unrest_transport labour_unrest_healthcare labour_unrest_public_sector 

foreach var of varlist labour_unrest_transport labour_unrest_healthcare {	

ppmlhdfe `var' ///	
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
	
	esttab using "$path\Results (Final)\Raw\Industry\baseline_`var'_18052026.csv", ///
        cells("b se") noobs plain replace
}

*-------------------------
* 2. Appendix: Sensivity Analysis
*-------------------------
* Check the distribution of your heat variable
tab nn_tavg_above_90_lag_60d
sum nn_tavg_above_90_lag_60d, detail

* Quadratic Term
gen heat_sq = nn_tavg_above_90_lag_60d^2

* Labels
* Defining Labels 
label define num_above_90_60d_lbl ///
    0 "0 Heats Days (base)" ///
    1 "1-19 Heat days" ///
    2 "20-39 Heat days" ///
    3 "≥40 Heat days"
    
label values num_above_90_60d num_above_90_60d_lbl

label variable nn_tavg_above_90_lag_60d "Heat Days (60-day lag)" 
label variable heat_sq "Heat Days$^2$ (60-day lag)"

* ── Run and store all models ─────────────────────────────

* Panel A
foreach var of varlist labour_unrest {
    eststo A_m1: ppmlhdfe `var' nn_tavg_above_90_lag_60d ///
        if season == 3, absorb(fips month year) ///
        cluster(fips) offset(log_emp)

    eststo A_m2: ppmlhdfe `var' nn_tavg_above_90_lag_60d ///
        if season == 3, absorb(fips state_month year) ///
        cluster(fips) offset(log_emp)

    eststo A_m3: ppmlhdfe `var' nn_tavg_above_90_lag_60d ///
        if season == 3, absorb(fips month year_month) ///
        cluster(fips) offset(log_emp)
		
	eststo A_m4: ppmlhdfe `var' nn_tavg_above_90_lag_60d ///
        if season == 3, absorb(fips week year) ///
        cluster(fips) offset(log_emp)
		
	eststo A_m5: ppmlhdfe `var' nn_tavg_above_90_lag_60d ///
        if season == 3, absorb(fips doy year) ///
        cluster(fips) offset(log_emp)
}

* Panel B
foreach var of varlist labour_unrest {
    eststo B_m1: ppmlhdfe `var' nn_tavg_above_90_lag_60d heat_sq ///
        if season == 3, absorb(fips month year) ///
        cluster(fips) offset(log_emp)

    eststo B_m2: ppmlhdfe `var' nn_tavg_above_90_lag_60d heat_sq ///
        if season == 3, absorb(fips state_month year) ///
        cluster(fips) offset(log_emp)

    eststo B_m3: ppmlhdfe `var' nn_tavg_above_90_lag_60d heat_sq ///
        if season == 3, absorb(fips month year_month) ///
        cluster(fips) offset(log_emp)
		
	eststo B_m4: ppmlhdfe `var' nn_tavg_above_90_lag_60d heat_sq ///
        if season == 3, absorb(fips week year) ///
        cluster(fips) offset(log_emp)
		
	eststo B_m5: ppmlhdfe `var' nn_tavg_above_90_lag_60d heat_sq ///
        if season == 3, absorb(fips doy year) ///
        cluster(fips) offset(log_emp)
}

* Panel C
foreach var of varlist labour_unrest {
    eststo C_m1: ppmlhdfe `var' b0.i.num_above_90_60d ///
        if season == 3, absorb(fips month year) ///
        cluster(fips) offset(log_emp)

    eststo C_m2: ppmlhdfe `var' b0.i.num_above_90_60d ///
        if season == 3, absorb(fips state_month year) ///
        cluster(fips) offset(log_emp)

    eststo C_m3: ppmlhdfe `var' b0.i.num_above_90_60d ///
        if season == 3, absorb(fips month year_month) ///
        cluster(fips) offset(log_emp)
		
	eststo C_m4: ppmlhdfe `var' b0.i.num_above_90_60d /// ///
        if season == 3, absorb(fips week year) ///
        cluster(fips) offset(log_emp)
		
	eststo C_m5: ppmlhdfe `var' b0.i.num_above_90_60d /// ///
        if season == 3, absorb(fips doy year) ///
        cluster(fips) offset(log_emp)
}

* ── Three separate esttab calls, appending to same file ──

* Panel A — opens the file
esttab A_m1 A_m2 A_m3 A_m4 A_m5 using "$path\Results (Final)\alt_spec_sensivity.tex", replace booktabs ///
    keep(nn_tavg_above_90_lag_60d) ///
    label se star(* 0.10 ** 0.05 *** 0.01) ///
	b(4) se(4) ///
    nomtitles nonotes noobs nonum ///
    prehead("\centering" ///
            "\begin{tabular}{lccccc}" ///
            "\toprule" ///
            " & (1) & (2) & (3) & (4) & (5) \\" ///
            "\midrule" ///
            "\multicolumn{6}{l}{\textit{Panel A: Linear}} \\") ///
    postfoot("\midrule")

* Panel B — appends
esttab B_m1 B_m2 B_m3 B_m4 B_m5 using "$path\Results (Final)\alt_spec_sensivity.tex", append booktabs ///
    keep(nn_tavg_above_90_lag_60d heat_sq) ///
    label se star(* 0.10 ** 0.05 *** 0.01) ///
	b(4) se(4) ///
    nomtitles nonotes noobs nonum ///
    prehead("\multicolumn{6}{l}{\textit{Panel B: Quadratic}} \\") ///
    postfoot("\midrule")

* Panel C — appends and closes the table
esttab C_m1 C_m2 C_m3 C_m4 C_m5 using "$path\Results (Final)\alt_spec_sensivity.tex", append booktabs ///
    keep(0.num_above_90_60d 1.num_above_90_60d 2.num_above_90_60d 3.num_above_90_60d) ///  // adjust levels as needed
    label se star(* 0.10 ** 0.05 *** 0.01) ///
	b(4) se(4) ///
    nomtitles nonotes noobs nonum ///
    prehead("\multicolumn{4}{l}{\textit{Panel C: Count Bins}} \\") ///
    postfoot("\bottomrule" ///
             "County FE       & $\checkmark$ & $\checkmark$ & $\checkmark$ & 	$\checkmark$ & $\checkmark$ \\" ///
			"Month FE        & $\checkmark$ &              & $\checkmark$ & & \\" ///
			"Week FE        &  &              & & $\checkmark$ &  \\" ///
			"DOY FE        &  &              & & & $\checkmark$ \\" ///
			"Year FE         & $\checkmark$ & $\checkmark$ & & $\checkmark$ & $\checkmark$     \\" ///
			"State-Month FE  &              & $\checkmark$ & & &            \\" ///
			"Month-Year FE   &              &              & $\checkmark$ & & \\" ///
			"\bottomrule" ///
			"\end{tabular}")


	 
	 
*-------------------------
* 2. Appendix: Alt Heat Threshold
*-------------------------
*!* Alternative Heat Threshold *!*
foreach var of varlist labour_unrest {	

eststo m1: ppmlhdfe `var' ///
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}

* Defining Labels 
label define num_above_85_60d_lbl ///
    0 "0 Heats Days (base)" ///
    1 "1-19 Heat days" ///
    2 "20-39 Heat days" ///
    3 "\geq 40 Heat days"
    
label values num_above_85_60d num_above_85_60d_lbl

foreach var of varlist labour_unrest {	
	
eststo m2: ppmlhdfe `var' ///
	i.num_above_85_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
	
}

* Defining Labels 
label define num_above_80_60d_lbl ///
    0 "0 Heats Days (base)" ///
    1 "1-19 Heat days" ///
    2 "20-39 Heat days" ///
    3 "\geq 40 Heat days"
    
label values num_above_80_60d num_above_80_60d_lbl

foreach var of varlist labour_unrest {	
	
eststo m3: ppmlhdfe `var' ///
	i.num_above_80_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
	
}

esttab m1 m2 m3 using "$path/Results (Final)/baseline_alt_threshold.tex", ///
    replace booktabs ///
    keep(0.num_above_90_60d ///
         1.num_above_90_60d ///
         2.num_above_90_60d ///
         3.num_above_90_60d ///
		 0.num_above_85_60d ///
         1.num_above_85_60d ///
         2.num_above_85_60d ///
         3.num_above_85_60d ///
		 0.num_above_80_60d ///
         1.num_above_80_60d ///
         2.num_above_80_60d ///
         3.num_above_80_60d ///
		 ) ///
    label se star(* 0.10 ** 0.05 *** 0.01) ///
    nomtitles nonotes baselevels ///
	refcat(0.num_above_90_60d "\textit{\(90^oF\) Threshold}" ///
     0.num_above_85_60d "\textit{\(85^oF\) Threshold}" ///
	 0.num_above_80_60d "\textit{\(80^oF\) Threshold}", nolabel) ///
	 noobs
	 
* Corresponding Summary Stats
*!* Exporting Sample for each model specification *!*
foreach var of varlist labour_unrest {

    * Model 1
    ppmlhdfe `var' ///
        c.nn_tavg_above_90_lag_60d ///
        i.year ///
        if season == 3, ///
        absorb(fips month) cluster(fips) offset(log_emp)
    
    gen in_sample_m1 = e(sample)

}

* num_above_80_60d
gen num_above_80_60d_0 = 0
replace num_above_80_60d_0 = 1 if num_above_80_60d == 0
label variable num_above_80_60d_0 "0 Heat Days (base)"
gen num_above_80_60d_1 = 0
replace num_above_80_60d_1 = 1 if num_above_80_60d == 1
label variable num_above_80_60d_1 "1-19 Heat Days"
gen num_above_80_60d_2 = 0
replace num_above_80_60d_2 = 1 if num_above_80_60d == 2
label variable num_above_80_60d_2 "20-39 Heat Days"
gen num_above_80_60d_3 = 0
replace num_above_80_60d_3 = 1 if num_above_80_60d == 3
label variable num_above_80_60d_3 "\geq 40 Heat Days"
sum num_above_80_60d_0 num_above_80_60d_1 num_above_80_60d_2 num_above_80_60d_3 if season == 3 & in_sample_m1 == 1

* num_above_85_60d
gen num_above_85_60d_0 = 0
replace num_above_85_60d_0 = 1 if num_above_85_60d == 0
label variable num_above_85_60d_0 "0 Heat Days (base)"
gen num_above_85_60d_1 = 0
replace num_above_85_60d_1 = 1 if num_above_85_60d == 1
label variable num_above_85_60d_1 "1-19 Heat Days"
gen num_above_85_60d_2 = 0
replace num_above_85_60d_2 = 1 if num_above_85_60d == 2
label variable num_above_85_60d_2 "20-39 Heat Days"
gen num_above_85_60d_3 = 0
replace num_above_85_60d_3 = 1 if num_above_85_60d == 3
label variable num_above_85_60d_3 "\geq 40 Heat Days"
sum num_above_85_60d_0 num_above_85_60d_1 num_above_85_60d_2 num_above_85_60d_3 if season == 3 & in_sample_m1 == 1

* num_above_90_60d
gen num_above_90_60d_0 = 0
replace num_above_90_60d_0 = 1 if num_above_90_60d == 0
label variable num_above_90_60d_0 "0 Heat Days (base)"
gen num_above_90_60d_1 = 0
replace num_above_90_60d_1 = 1 if num_above_90_60d == 1
label variable num_above_90_60d_1 "1-19 Heat Days"
gen num_above_90_60d_2 = 0
replace num_above_90_60d_2 = 1 if num_above_90_60d == 2
label variable num_above_90_60d_2 "20-39 Heat Days"
gen num_above_90_60d_3 = 0
replace num_above_90_60d_3 = 1 if num_above_90_60d == 3
label variable num_above_90_60d_3 "≥40 Heat Days"
sum num_above_90_60d_0 num_above_90_60d_1 num_above_90_60d_2 num_above_90_60d_3 if season == 3 & in_sample_m1 == 1

*Generating Summary Stats for each Temperature Variables
estpost tabstat num_above_90_60d_0 num_above_90_60d_1 num_above_90_60d_2 num_above_90_60d_3 if season == 3 & in_sample_m1 == 1, stat(count mean sd min max) c(stat)
estimates store ss1

estpost tabstat num_above_85_60d_0 num_above_85_60d_1 num_above_85_60d_2 num_above_85_60d_3 if season == 3 & in_sample_m1 == 1, stat(count mean sd min max) c(stat)
estimates store ss2

estpost tabstat num_above_80_60d_0 num_above_80_60d_1 num_above_80_60d_2 num_above_80_60d_3 if season == 3 & in_sample_m1 == 1, stat(count mean sd min max) c(stat)
estimates store ss3

esttab ss1 ss2 ss3 using "$path/Results (Final)/sum_stat_alt_thresholds.tex", replace cells("mean(fmt(4))") nostar compress nonote unstack noobs nogap booktabs mlabels(none) collabels(none) varlabels(`e(labels)') label numbers ///
refcat(num_above_90_60d_0 "\textit{\(90^oF\) Threshold}" ///
     num_above_85_60d_0 "\textit{\(85^oF\) Threshold}" ///
	 num_above_80_60d_0 "\textit{\(80^oF\) Threshold}", nolabel)

*-------------------------
* 2. Appendix: Alt Heat Window Lenght
*------------------------- 
label define num_above_90_14d_lbl ///
    0 "0 Heats Days (base)" ///
    1 "1-9 Heat days" ///
    2 "9+ Heat days"
    
label values num_above_90_14d num_above_90_14d_lbl

foreach var of varlist labour_unrest {	

eststo m1: ppmlhdfe `var' ///
	i.num_above_90_14d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}

label define num_above_90_30d_lbl ///
    0 "0 Heats Days (base)" ///
    1 "1-9 Heat days" ///
    2 "10-19 Heat days" ///
    3 "\geq 20 Heat days"
label values num_above_90_30d num_above_90_30d_lbl

foreach var of varlist labour_unrest {	

eststo m2: ppmlhdfe `var' ///
	i.num_above_90_30d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}

foreach var of varlist labour_unrest {	

eststo m3: ppmlhdfe `var' ///
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}

label define num_above_90_90d_lbl ///
    0 "0 Heats Days (base)" ///
    1 "1-19 Heat days" ///
    2 "20-39 Heat days" ///
    3 "40-59 Heat days" ///
	4 "\geq 60 Heat Days" 
	
label values num_above_90_90d num_above_90_90d_lbl

foreach var of varlist labour_unrest {	

eststo m4: ppmlhdfe `var' ///
	i.num_above_90_90d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}


esttab m2 m3 m4 using "$path/Results (Final)/baseline_alt_window_length.tex", ///
    replace booktabs ///
    keep(0.num_above_90_30d ///
         1.num_above_90_30d ///
         2.num_above_90_30d ///
         3.num_above_90_30d ///
		 0.num_above_90_60d ///
         1.num_above_90_60d ///
         2.num_above_90_60d ///
         3.num_above_90_60d ///
		 0.num_above_90_90d ///
         1.num_above_90_90d ///
         2.num_above_90_90d ///
         3.num_above_90_90d ///
		 4.num_above_90_90d ///
		 ) ///
    label se star(* 0.10 ** 0.05 *** 0.01) ///
    nomtitles nonotes baselevels ///
	 noobs ///
	 refcat(0.num_above_90_30d "\textit{30 Day Lag Window}" /// 
	 0.num_above_90_60d "\textit{60 Day Lag Window}" ///
	 0.num_above_90_90d "\textit{90 Day Lag Window}" ///
	 , nolabel)
	 
*-------------------------
* 2. Appendix: Cold Exposure
*------------------------- 	 
label define num_below_40_60d_lbl ///
    0 "0 Cold Days (base)" ///
    1 "1-19 Cold days" ///
    2 "20-39 Cold days" ///
	3 "\geq 40 Cold Days" 
	
label values num_below_40_60d num_below_40_60d_lbl

foreach var of varlist labour_unrest {	

eststo m1: ppmlhdfe `var' ///
	i.num_below_40_60d ///
    i.year ///
    if season == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}

label define num_below_35_60d_lbl ///
    0 "0 Cold Days (base)" ///
    1 "1-19 Cold days" ///
    2 "20-39 Cold days" ///
	3 "\geq 40 Cold Days" 
	
label values num_below_35_60d num_below_35_60d_lbl

foreach var of varlist labour_unrest {	

eststo m2: ppmlhdfe `var' ///
	i.num_below_35_60d ///
    i.year ///
    if season == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}

label define num_below_30_60d_lbl ///
    0 "0 Cold Days (base)" ///
    1 "1-19 Cold days" ///
    2 "20-39 Cold days" ///
	3 "\geq 40 Cold Days" 
	
label values num_below_30_60d num_below_30_60d_lbl

foreach var of varlist labour_unrest {	

eststo m3: ppmlhdfe `var' ///
	i.num_below_30_60d ///
    i.year ///
    if season == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}

esttab m1 m2 m3 using "$path/Results (Final)/cold_shock_alt_threshold.tex", ///
    replace booktabs ///
    keep(0.num_below_40_60d ///
         1.num_below_40_60d ///
         2.num_below_40_60d ///
         3.num_below_40_60d ///
		 0.num_below_35_60d ///
         1.num_below_35_60d ///
         2.num_below_35_60d ///
         3.num_below_35_60d ///
		 0.num_below_30_60d ///
         1.num_below_30_60d ///
         2.num_below_30_60d ///
         3.num_below_30_60d ///
		 ) ///
    label se star(* 0.10 ** 0.05 *** 0.01) ///
    nomtitles nonotes baselevels ///
	refcat(0.num_below_40_60d "\textit{\(40^oF\) Threshold}" ///
     0.num_below_35_60d "\textit{\(35^oF\) Threshold}" ///
	 0.num_below_30_60d "\textit{\(30^oF\) Threshold}", nolabel)


* Alternative Threshold *
label define num_below_35_30d_lbl ///
    0 "0 Cold Days (base)" ///
    1 "1-9 Cold days" ///
    2 "10-19 Cold days" ///
	3 "\geq 19 Cold Days" 
	
label values num_below_35_30d num_below_35_30d_lbl

foreach var of varlist labour_unrest {	

eststo m1: ppmlhdfe `var' ///
	i.num_below_35_30d ///
    i.year ///
    if season == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}

foreach var of varlist labour_unrest {	

eststo m2: ppmlhdfe `var' ///
	i.num_below_35_60d ///
    i.year ///
    if season == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}

label define num_below_35_90d_lbl ///
    0 "0 Cold Days (base)" ///
    1 "1-19 Cold days" ///
    2 "20-39 Cold days" ///
	3 "39-59 Cold Days" ///
	4 "\geq 60 Cold Days"
	
label values num_below_35_90d num_below_35_90d_lbl

foreach var of varlist labour_unrest {	

eststo m3: ppmlhdfe `var' ///
	i.num_below_35_90d ///
    i.year ///
    if season == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}


esttab m1 m2 m3 using "$path/Results (Final)/cold_shock_alt_window_length.tex", ///
    replace booktabs ///
    keep(0.num_below_35_30d ///
         1.num_below_35_30d ///
         2.num_below_35_30d ///
         3.num_below_35_30d ///
		 0.num_below_35_60d ///
         1.num_below_35_60d ///
         2.num_below_35_60d ///
         3.num_below_35_60d ///
		 0.num_below_35_90d ///
         1.num_below_35_90d ///
         2.num_below_35_90d ///
         3.num_below_35_90d ///
		 4.num_below_35_90d ///
		 ) ///
    label se star(* 0.10 ** 0.05 *** 0.01) ///
    nomtitles nonotes baselevels ///
	refcat(0.num_below_35_30d "\textit{30 Day Lag Window}" ///
     0.num_below_35_60d "\textit{60 Day Lag Window}" ///
	 0.num_below_35_90d "\textit{90 Day Lag Window}", nolabel) 

*-------------------------
* 2. Appendix: Lag, Contemporaneous, and Lead Effects
*------------------------- 
foreach var of varlist labour_unrest {	

eststo m1: ppmlhdfe `var' ///	
	i.num_above_90_60d c.nn_tavg_above_90 i.num_above_90_60d_lead ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
	
	esttab using "$path\Results (Final)\Raw\Leads\baseline_lead.csv", ///
        cells("b se") noobs plain replace
}

*-------------------------
* 2. Appendix: Extending the study window (Summer (June-August))), (Extended Summer (May-September)), Full Period (May-October)
*------------------------- 
* Baseline: Heating Period (June–August) — main sample

* Extended: Heating + Cooling Period (May–October)
gen heating_cooling_sep = inlist(month, 6, 7, 8, 9)
gen heating_cooling_oct = inlist(month, 6, 7, 8, 9, 10)

foreach var of varlist labour_unrest {	

ppmlhdfe `var' ///	
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)

esttab using "$path\Results (Final)\Raw\Period\summer_`var'_18052026.csv", ///
        cells("b se") noobs plain replace
		
ppmlhdfe `var' ///	
	i.num_above_90_60d ///
    i.year ///
    if heating_cooling_sep == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)

esttab using "$path\Results (Final)\Raw\Period\summer_extn1_`var'_18052026.csv", ///
        cells("b se") noobs plain replace
		
ppmlhdfe `var' ///	
	i.num_above_90_60d ///
    i.year ///
    if heating_cooling_oct == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)
	
esttab using "$path\Results (Final)\Raw\Period\summer_extn2_`var'_18052026.csv", ///
        cells("b se") noobs plain replace	
}

******
foreach var of varlist labour_unrest {	
ppmlhdfe `var' ///
        c.nn_tavg_above_90_lag_60d ///
        i.year ///
        if season == 3, ///
        absorb(fips month) cluster(fips) offset(log_emp)
    
    gen in_sample_m1_`var' = e(sample)
}	

* Estimating Baseline Rate and Exposure for attrtibutable event calucaltions
* Samples for each dependent variable
local i = 1

foreach depvar in ///
    labour_unrest ///
    strike ///
    protest ///
    labour_unrest_goods_producing ///
    labour_unrest_professional ///
    labour_unrest_non_professional ///
    labour_unrest_transport ///
    labour_unrest_healthcare ///
    labour_unrest_public_sector {
	
	ppmlhdfe `depvar' ///
        c.nn_tavg_above_90_lag_60d ///
        i.year ///
        if season == 3, ///
        absorb(fips month) cluster(fips) offset(log_emp)

    gen sample_`i' = e(sample)

    di "sample_`i' corresponds to `depvar'"

    local ++i
}

*Baseline Rates
local outcomes ///
    labour_unrest ///
    strike ///
    protest ///
    labour_unrest_goods_producing ///
    labour_unrest_professional ///
    labour_unrest_non_professional ///
    labour_unrest_transport ///
    labour_unrest_healthcare ///
    labour_unrest_public_sector

local i = 1

foreach outcome of local outcomes {

    sum `outcome' if num_above_90_60d == 0 & sample_`i' == 1

    di "`outcome': " %9.7f r(mean)

    local ++i
}

* Incidence of Heat Exposure
local i = 1

foreach outcome in ///
    labour_unrest ///
    strike ///
    protest ///
    labour_unrest_goods_producing ///
    labour_unrest_professional ///
    labour_unrest_non_professional ///
    labour_unrest_transport ///
    labour_unrest_healthcare ///
    labour_unrest_public_sector {

    di ""
    di "`outcome'"

    count if num_above_90_60d == 0 & sample_`i' == 1
    di "0 Days: " r(N)

    count if num_above_90_60d == 1 & sample_`i' == 1
    di "1-19 Days: " r(N)

    count if num_above_90_60d == 2 & sample_`i' == 1
    di "20-39 Days: " r(N)

    count if num_above_90_60d == 3 & sample_`i' == 1
    di ">=40 Days: " r(N)

    local ++i
}

*-------------------------
* Other Tests not included in Paper
*------------------------- 
gen hot_period_v1 = 0
replace hot_period_v1 = 1 if inlist(month, 6, 7, 8, 9, 10)    // Summer: Jun, Jul, Aug, September, October

gen hot_period_v2 = 0
replace hot_period_v2 = 1 if inlist(month, 6, 7, 8, 9)    // Summer: Jun, Jul, Aug, September

foreach var of varlist labour_unrest {	
	
ppmlhdfe `var' ///	
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)

ppmlhdfe `var' ///	
	i.num_above_90_60d ///
    i.year ///
    if hot_period_v1 == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)
	
ppmlhdfe `var' ///	
	i.num_above_90_60d ///
    i.year ///
    if hot_period_v2 == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)
}


foreach var of varlist labour_unrest {	
	
eststo m1: ppmlhdfe `var' ///	
	c.nn_tavg_above_90_lag_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)

esttab using "${path}Results (Final)/Raw/Baseline/con_M1_`var'.csv", ///
        cells("b se") noobs plain replace
		
eststo m2: ppmlhdfe `var' ///	
	c.nn_tavg_above_90_lag_60d ///
    if season == 3, ///
    absorb(county_month year) cluster(fips) offset(log_emp)

esttab using "${path}Results (Final)/Raw/Baseline/con_M2_`var'.csv", ///
        cells("b se") noobs plain replace
		
eststo m3: ppmlhdfe `var' ///
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
	
esttab using "${path}Results (Final)/Raw/Baseline/bin_M1_`var'.csv", ///
        cells("b se") noobs plain replace
		
eststo m4: ppmlhdfe `var' ///
	i.num_above_90_60d ///
    if season == 3, ///
    absorb(county_month year) cluster(fips) offset(log_emp)
	
esttab using "${path}Results (Final)/Raw/Baseline/bin_M2_`var'.csv", ///
        cells("b se") noobs plain replace
}

* Defining Labels 
label define num_above_90_60d_lbl ///
    0 "0 Heats Days (base)" ///
    1 "1-20 Heat days" ///
    2 "21-40 Heat days" ///
    3 "41+ Heat days"
    
label values num_above_90_60d num_above_90_60d_lbl

label var nn_tavg_above_90_lag_60d "Heat Days"

esttab m1 m3 m2 m4 using "$path/Results (Final)/baseline.tex", ///
    replace booktabs ///
    keep(nn_tavg_above_90_lag_60d ///
		0.num_above_90_60d ///
         1.num_above_90_60d ///
         2.num_above_90_60d ///
         3.num_above_90_60d) ///
    label se star(* 0.10 ** 0.05 *** 0.01) ///
    nomtitles nonotes baselevels ///
	refcat(nn_tavg_above_90_lag_60d "\textit{Continuous measure}" ///
     0.num_above_90_60d "\textit{Binned measure}", nolabel) ///
	 noobs
/*
* Exporting CSV *
eststo clear
foreach var of varlist labour_unrest {	
ppmlhdfe `var' ///	
	c.nn_tavg_above_90_lag_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)

esttab using "${path}Results (Final)/Raw/Baseline/con_M1_`var'.csv", ///
        cells("b se") noobs plain replace
		
ppmlhdfe `var' ///	
	c.nn_tavg_above_90_lag_60d ///
    if season == 3, ///
    absorb(county_month year) cluster(fips) offset(log_emp)

esttab using "${path}Results (Final)/Raw/Baseline/con_M2_`var'.csv", ///
        cells("b se") noobs plain replace
		
ppmlhdfe `var' ///
	i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(fips month) cluster(fips) offset(log_emp)
	
esttab using "${path}Results (Final)/Raw/Baseline/bin_M1_`var'.csv", ///
        cells("b se") noobs plain replace
		
ppmlhdfe `var' ///
	i.num_above_90_60d ///
    if season == 3, ///
    absorb(county_month year) cluster(fips) offset(log_emp)
	
esttab using "${path}Results (Final)/Raw/Baseline/bin_M2_`var'.csv", ///
        cells("b se") noobs plain replace
}

*!* Exporting Sample for each model specification *!*
foreach var of varlist labour_unrest {

    * Model 1
    ppmlhdfe `var' ///
        c.nn_tavg_above_90_lag_60d ///
        i.year ///
        if season == 3, ///
        absorb(fips month) cluster(fips) offset(log_emp)
    
    gen in_sample_m1 = e(sample)

    * Model 2
    ppmlhdfe `var' ///
        c.nn_tavg_above_90_lag_60d ///
        if season == 3, ///
        absorb(county_month year) cluster(fips state_year) offset(log_emp)
    
    gen in_sample_m2 = e(sample)

}

* Export
preserve
    keep event_id in_sample_m1 in_sample_m2
    export delimited using "${path}Data/model_samples.csv", replace
restore



*!* Prefered Model with robust specification sample *!*
foreach var of varlist labour_unrest {	
	
eststo m1: ppmlhdfe `var' ///	
	c.nn_tavg_above_90_lag_60d ///
    i.year ///
    if season == 3 & in_sample_m2 == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)

eststo m2: ppmlhdfe `var' ///	
	c.nn_tavg_above_90_lag_60d ///
    if season == 3, ///
    absorb(county_month year) cluster(fips) offset(log_emp)

eststo m3: ppmlhdfe `var' ///
	i.num_above_90_60d ///
    i.year ///
    if season == 3 & in_sample_m2 == 1, ///
    absorb(fips month) cluster(fips) offset(log_emp)

eststo m4: ppmlhdfe `var' ///
	i.num_above_90_60d ///
    if season == 3, ///
    absorb(county_month year) cluster(fips) offset(log_emp)
}

esttab m1 m3 m2 m4 using "$path/Results (Final)/baseline_m2_est_sample.tex", ///
    replace booktabs ///
    keep(nn_tavg_above_90_lag_60d ///
		0.num_above_90_60d ///
         1.num_above_90_60d ///
         2.num_above_90_60d ///
         3.num_above_90_60d) ///
    label se star(* 0.10 ** 0.05 *** 0.01) ///
    nomtitles nonotes baselevels ///
	refcat(nn_tavg_above_90_lag_60d "\textit{Continuous measure}" ///
     0.num_above_90_60d "\textit{Binned measure}", nolabel) ///
	 noobs
	 
*/

 





C:\Users\20234503\Dropbox\PhD Project\Research\Weather and Strikes\Project\Results (Final)\Raw\Leads
* Note: Issue with positve and signifigant lead effect in robust specification
* Note: It does not persist under county month year specification (Maybe this should be robust specification??)
* The mean labour unrest value is one! 

* Num Heat days
tabstat nn_tavg_above_90 if in_sample_m1 == 1, stats(sum)
tabstat nn_tavg_above_90 if in_sample_m2 == 1, stats(sum)
* Binned
tab num_above_90_60d if in_sample_m1 == 1
tab num_above_90_60d if in_sample_m2 == 1
sum labour_unrest if in_sample_m1 == 1 & num_above_90_60d == 0
sum labour_unrest if in_sample_m2 == 1 & num_above_90_60d == 0

