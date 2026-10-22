*-------------------------
* 1. Action Type: Strike and Protests
*-------------------------
foreach var of varlist strike protest {	
ppmlhdfe `var' ///
	b0.i.num_above_90_60d ///
    i.year ///
    if season == 3, ///
    absorb(county_month) cluster(fips) offset(log_emp)
	
	*esttab using "${path}\Results (Final)\Raw\Type\baseline_`var'.csv", ///
        cells("b se") noobs plain replace
		
	*gen in_sample_`var' = e(sample)
}

*-------------------------
* 1. Sector: Goods Producing, professtional service, non-professtional service, transport, healthcare and public
*-------------------------
foreach var of varlist labour_unrest_goods_producing labour_unrest_professional_servi labour_unrest_non_professional_s labour_unrest_transport labour_unrest_healthcare labour_unrest_public_sector{	
ppmlhdfe `var' ///
	b0.i.num_above_90_90d ///
    i.year ///
    if season == 3, ///
    absorb(county_month) cluster(fips) offset(log_emp)
	
	*esttab using "${path}\Results (Final)\Raw\Type\baseline_`var'.csv", ///
        cells("b se") noobs plain replace
		
}

local vars        "labour_unrest_goods_producing labour_unrest_professional_servi labour_unrest_non_professional_s labour_unrest_transport labour_unrest_healthcare labour_unrest_public_sector"
local stubs       "goods_prod prof_serv non_prof_serv transport healthcare public_sector"

local n : word count `vars'
forvalues i = 1/`n' {
    local var   : word `i' of `vars'
    local stub  : word `i' of `stubs'
    
    ppmlhdfe `var' ///
        b0.i.num_above_90_60d ///
        i.year ///
        if season == 3, ///
        absorb(fips month) cluster(fips) offset(log_emp)

    esttab using "$path\Results (Final)\Raw\Industry\baseline_`var'.csv", ///
        cells("b se") noobs plain replace

    gen in_`stub' = e(sample)
}

* Summaray of Heat days
*Strike & Protests
tab num_above_90_60d if in_sample_strike == 1
tab num_above_90_60d if in_sample_protest == 1
sum strike if in_sample_strike == 1 & num_above_90_60d == 0
sum protest if in_sample_protest == 1 & num_above_90_60d == 0

*Sector
*Sector
tab num_above_90_60d if in_goods_prod == 1
sum labour_unrest_goods_producing if in_goods_prod == 1 & num_above_90_60d == 0

tab num_above_90_60d if in_prof_serv == 1
sum labour_unrest_professional_servi if in_prof_serv == 1 & num_above_90_60d == 0

tab num_above_90_60d if in_non_prof_serv == 1
sum labour_unrest_non_professional_s if in_non_prof_serv == 1 & num_above_90_60d == 0

tab num_above_90_60d if in_transport == 1
sum labour_unrest_transport if in_transport == 1 & num_above_90_60d == 0

tab num_above_90_60d if in_healthcare == 1
sum labour_unrest_healthcare if in_healthcare == 1 & num_above_90_60d == 0

tab num_above_90_60d if in_public_sector == 1
sum labour_unrest_public_sector if in_public_sector == 1 & num_above_90_60d == 0









in_goods_prod in_prof_serv in_non_prof_serv in_transport in_healthcare in_public_sector