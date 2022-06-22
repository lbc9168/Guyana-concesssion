*********************************************
* logit regression with 2 land types (1 and 3)
* Created at: 04-28-2022


tab annual_change_val withConcession, chi2
tab annual_change_val treatStatus, chi2

**** Convert distance variables' unit from m to km
gen dist_harbor = NEAR_DIST_harbor / 1000
gen dist_road = NEAR_DIST_road / 1000
gen dist_river = NEAR_DIST_river / 1000
gen dist_settlement = NEAR_DIST_settlement / 1000
gen dist_deforest = NEAR_DIST_ForestEdge / 1000


**** Generate concession treatment effect (for single group panel)
gen withConcession = 0
replace withConcession = 1 if (YEAR_ISSUE < year)


**** Generate Time stage fixed effect
gen Tstage = 0
replace Tstage = 1 if (year > 1997 & year < 2009)
replace Tstage = 2 if (year >= 2009)

gen Tstage_2 = 0
replace Tstage_2 = 1 if (year >= 1995 & year < 2000)
replace Tstage_2 = 2 if (year >= 2000 & year < 2005)
replace Tstage_2 = 3 if (year >= 2005 & year < 2010)
replace Tstage_2 = 4 if (year >= 2010 & year < 2015)
replace Tstage_2 = 5 if (year >= 2015)



**** for 2 land type datasets, convert dependent variable to 0-1 (2022-04-29)
drop if (annual_change_val == 4 | annual_change_val == 5 | annual_change_val == 6)
drop if (annual_change_val == 2)

gen landType = 0
replace landType = 1 if annual_change_val != 1
	
logit landType i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/ price_sawnwood_real price_roundwood_real gold_price_real /*
                    */ dist_harbor  dist_road  dist_river  dist_settlement  

logit landType i.withConcession  /*
				*/ annual_temp_Kelvin annual_rainfall_m elevation /* 
				*/ price_roundwood_real gold_price_real /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 

				
logit landType dist_deforest_ln
logit landType dist_harbor



**** For T vs MT: Create treatStatus variable based on UID
gen treatStatus = 0
replace treatStatus = 1 if strmatch(UID,"mtoverlap*") == 1

display(strmatch("mtoverlap1","mtoverlap*"))

*****************************
** 05-20-2022 Edit log
** generage a random value where distance to forest edge = 0
** and see if it solves the singularity problem
********************************

replace Rdm_num = rnormal(0.25, 0.1)
drop dist_deforest
gen dist_deforest = NEAR_DIST_ForestEdge / 1000

drop dist_deforest_ln
gen dist_deforest_ln = ln(dist_deforest)
summarize dist_deforest_ln, detail

replace dist_deforest = Rdm_num if dist_deforest == 0
replace dist_deforest = 0.1 if dist_deforest <= 0

*******************************
** 05-23-2022 notes
** After multiple tests, I confirmed the (iteration back up) problem comes from NEAR_DIST_ForestEdge
** Since the deforestation rate in Guyana is low, the distance to forest edge has high variation
** It brings singularity problem (a large distance means no deforestation)
** To solve this problem, we can put logarithm on the distance
** but I don't suggest to do this
*******************************

logit landType i.withConcession i.treatStatus /*
				*/ annual_temp_Kelvin annual_rainfall_m /* 
				*/ price_roundwood_real gold_price_real GUY_LABOR GUY_GDP /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 

logit landType i.withConcession /*
				*/ annual_temp_Kelvin annual_rainfall_m /* 
				*/ price_roundwood_real gold_price_real GUY_LABOR GUY_GDP /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 
				
				
				
				
				
************************************************
** 06-05-2022 update
**

gen annual_rainfall_mm = annual_rainfall_m * 1000 * 12
gen GUY_LABOR_k = GUY_LABOR * 1000

**** compare control and treated group, cross-sectional datasets
logit landType i.treatStatus /*
				*/ annual_temp_Kelvin annual_rainfall_mm /* 
				*/ price_roundwood_real gold_price_real GUY_LABOR_k GUY_GDP /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 

logit landType i.treatStatus /*
				*/ annual_temp_Kelvin annual_rainfall_mm /* 
				*/ price_roundwood_real gold_price_real GUY_LABOR_k GUY_GDP /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights]
			
**** Panel dataset with only concession group
logit landType i.withConcession /*
				*/ annual_temp_Kelvin annual_rainfall_mm /* 
				*/ price_roundwood_real gold_price_real GUY_LABOR_k GUY_GDP /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 if treatStatus == 1
				






				
				