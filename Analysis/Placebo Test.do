*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (All Other Seasons) - Table 1
*-------------------------
forvalues x = 1/4 {
foreach var of varlist strike {
ppmlhdfe `var' ///
        tavg_norm ///
        hot_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == `x', ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
		esttab using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\Raw\placebo_`var'_`x'_r.csv", ///
cells("b se") noobs plain replace

	*estimates store `var'_`x'_r
}
}

esttab labour_unrest_1_r labour_unrest_2_r  labour_unrest_3_r labour_unrest_4_r using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\baseline_all_seasons.tex", replace ///
    keep(hot_day) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{4}{c}} \toprule  &\multicolumn{1}{c}{Winter}&\multicolumn{1}{c}{Spring}&\multicolumn{1}{c}{Summer}&\multicolumn{1}{c}{Fall}\\ \midrule \multicolumn{5}{l}{\emph{Panel A: Labour Conflict Incidence per 100,000 firms}} \\") ///
postfoot("\midrule ")

esttab protest_1_r protest_2_r  protest_3_r protest_4_r using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\baseline_all_seasons.tex", append ///
    keep(hot_day) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\addlinespace \multicolumn{5}{l}{\emph{Panel B: Protest Incidence per 100,000 firms}} \\") ///
	postfoot("\midrule ")
	
esttab strike_1_r strike_2_r  strike_3_r strike_4_r using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\baseline_all_seasons.tex", append ///
    keep(hot_day) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\addlinespace \multicolumn{5}{l}{\emph{Panel C: Strike Incidence per 100,000 firms}} \\") ///
	postfoot("\midrule \\ County, Month, Year FE & \checkmark & \checkmark & \checkmark \\ Con. Temp. & \checkmark & \checkmark & \checkmark \\ \# Obs. & 117024 & 85744 & 71024 \\ \bottomrule \end{tabular}")
	
*-------------------------
* 1. App: Labour Unrest, Strikes, Protests (Cold Shocks) - Table 2
*-------------------------
egen cold_day = rowtotal(tavg_norm_sd_m30_lead_30d)
forvalues x = 1/4 {
foreach var of varlist labour_unrest protest strike {
ppmlhdfe `var' ///
        tavg_norm ///
		hot_day ///
        cold_day ///
    i.year ///
    if year != 2020 & (year < 2024 | (year == 2024 & month <= 10)) & season == `x', ///
    absorb(fips month) cluster(fips date) offset(log_firms)
	
	estimates store `var'_`x'_r
}
}

esttab labour_unrest_1_r labour_unrest_2_r  labour_unrest_3_r labour_unrest_4_r using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\cold_shock_all_seasons.tex", replace ///
    keep(cold_day hot_day) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{4}{c}} \toprule  &\multicolumn{1}{c}{Winter}&\multicolumn{1}{c}{Spring}&\multicolumn{1}{c}{Summer}&\multicolumn{1}{c}{Fall}\\ \midrule \multicolumn{5}{l}{\emph{Panel A: Labour Conflict Incidence per 100,000 firms}} \\") ///
postfoot("\midrule ")

esttab protest_1_r protest_2_r  protest_3_r protest_4_r using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\cold_shock_all_seasons.tex", append ///
    keep(cold_day hot_day) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\addlinespace \multicolumn{5}{l}{\emph{Panel B: Protest Incidence per 100,000 firms}} \\") ///
	postfoot("\midrule ")
	
esttab strike_1_r strike_2_r  strike_3_r strike_4_r using "C:\Users\20234503\Desktop\Research\Weather and Strikes\Project\Results_2\cold_shock_all_seasons.tex", append ///
    keep(cold_day hot_day) ///
    booktabs label nonote star(* 0.10 ** 0.05 *** 0.01) noobs nomtitles ///
	prehead("\addlinespace \multicolumn{5}{l}{\emph{Panel C: Strike Incidence per 100,000 firms}} \\") ///
	postfoot("\midrule \\ County, Month, Year FE & \checkmark & \checkmark & \checkmark \\ Con. Temp. & \checkmark & \checkmark & \checkmark \\ \# Obs. & 117024 & 85744 & 71024 \\ \bottomrule \end{tabular}")