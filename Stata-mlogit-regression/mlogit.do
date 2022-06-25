******************
** Created at: 03-20-2022
** Edited at: 03-28-2022



**** The result depend on which dataset you read

tab annual_change_val treatStatus, chi2


**** drop the water and other land type points
drop if annual_change_val == 5
drop if annual_change_val == 6

**** Convert distance variables' unit from m to km
gen dist_harbor = NEAR_DIST_harbor/1000
gen dist_road = NEAR_DIST_road/1000
gen dist_river = NEAR_DIST_river/1000
gen dist_settlement = NEAR_DIST_settlement/1000

gen annual_rainfall_y = annual_rainfall_m * 12

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

**** Generate string variables, but string variables can't be used in regression
* gen land_type = "Undisturbed"
* replace land_type = "Degraded" if (annual_change_val == 2)
* replace land_type = "Deforested" if (annual_change_val == 3)
* replace land_type = "Regrowth" if (annual_change_val == 4)

* gen Tstage_3 = "1990-1994"
* replace Tstage_3 = "1995-1999" if (year >= 1995 & year < 2000)
* replace Tstage_3 = "2000-2004" if (year >= 2000 & year < 2005)
* replace Tstage_3 = "2005-2009" if (year >= 2005 & year < 2010)
* replace Tstage_3 = "2010-2014" if (year >= 2010 & year < 2015)
* replace Tstage_3 = "after2014" if (year >= 2015)


********** Mlogit regression, with cross sectional data **********

* sometimes there are multiple weights merged
gen weights = weights_y 

mlogit annual_change_val i.treatStatus annual_temp_Kelvin annual_rainfall_y /* 
					*/ price_roundwood_real gold_price_real	GUY_LABOR_k GUY_GDP /*
                  */   dist_harbor  dist_road  dist_river  dist_settlement [pweight = weights]

mlogit annual_change_val i.treatStatus annual_temp_Kelvin annual_rainfall_y /* 
					*/price_roundwood_real gold_price_real GUY_LABOR_k GUY_GDP /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] if (annual_change_val < 4)

mlogit annual_change_val i.treatStatus annual_temp_Kelvin annual_rainfall_y /* 
					*/price_roundwood_real gold_price_real	GUY_LABOR_k GUY_GDP /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2
				  
		  
mlogit, rrr

test treatStatus

margins treatStatus, atmeans predict(outcome(3))
	  
marginsplot 
	
***** Try logit regression (06-25-2022)
gen land_type = 0
replace land_type = 1 if (annual_change_val > 1)

logit land_type i.treatStatus annual_temp_Kelvin annual_rainfall_y /* 
					*/price_roundwood_real gold_price_real /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] if (annual_change_val < 4)


	
******* Panel Mlogit regression, with panel data *********
******* 04-27-2022

** Specify panel identifier, remove characters in "UID"
gen UniqueID = UID
replace UniqueID = subinstr(UniqueID, "mtoverlap", "", .)
destring UniqueID, replace

xtset UniqueID

xtmlogit annual_change_val  i.withConcession /* 
                    */ if UniqueID < 500, rrr 

mlogit annual_change_val i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/price_sawnwood_real price_roundwood_real gold_price_real /*
                    */dist_harbor  dist_road  dist_river  dist_settlement i.Tstage_2, rrr

mlogit annual_change_val i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/price_sawnwood_real price_roundwood_real gold_price_real /*
                    */dist_harbor  dist_road  dist_river  dist_settlement i.year, rrr	
	
	
cor annual_change_val annual_temp_Kelvin annual_rainfall_m price_sawnwood_real price_roundwood_real gold_price_real dist_harbor  dist_road dist_river dist_settlement
	
	


				  
	
**** Predict results for annual_change_val = 1,2,3,4
	  



** In Control vs Mining Only, use the change of gold price

margins, at(gold_price_real = (200 (100) 900)) predict(outcome(3)) vsquish				  
predict p1 p2 p3 p4	
		  
twoway (mband p1 gold_price_real if treatStatus == 0) (mband p1 gold_price_real if treatStatus == 1), ///
	legend(order(1 "Control Group" 2 "Mining Only" ) ring(0) position(7) row(2))
twoway (mband p2 gold_price_real if treatStatus == 0) (mband p2 gold_price_real if treatStatus == 1), ///
	legend(order(1 "Control Group" 2 "Mining Only" ) ring(0) position(7) row(2))	
twoway (mband p3 gold_price_real if treatStatus == 0) (mband p3 gold_price_real if treatStatus == 1), ///
	legend(order(1 "Control Group" 2 "Mining Only" ) ring(0) position(10) row(2))
twoway (mband p4 gold_price_real if treatStatus == 0) (mband p4 gold_price_real if treatStatus == 1), ///
	legend(order(1 "Control Group" 2 "Mining Only" ) ring(0) position(10) row(2))

** In Control vs Timber Only, use the change of timber price

margins, at(price_roundwood_real = (40 (40) 240)) predict(outcome(3)) vsquish				  
predict p1 p2 p3 p4	
		  
twoway (mband p1 price_roundwood_real if treatStatus == 0) (mband p1 price_roundwood_real if treatStatus == 1), ///
	legend(order(1 "Control Group" 2 "Timber Only" ) ring(0) position(7) row(2))
twoway (mband p3 price_roundwood_real if treatStatus == 0) (mband p3 price_roundwood_real if treatStatus == 1), ///
	legend(order(1 "Control Group" 2 "Timber Only" ) ring(0) position(10) row(2))

	
	
** Control vs Protected Only
twoway (mband p3 price_sawnwood_real if treatStatus == 0) (mband p3 price_sawnwood_real if treatStatus == 1), ///
	legend(order(1 "Control Group" 2 "Protected Only" ) ring(0) position(10) row(2))
twoway (mband p3 price_roundwood_real if treatStatus == 0) (mband p3 price_roundwood_real if treatStatus == 1), ///
	legend(order(1 "Control Group" 2 "Protected Only" ) ring(0) position(10) row(2))
twoway (mband p3 annual_temp_Kelvin if treatStatus == 0) (mband p3 annual_temp_Kelvin if treatStatus == 1), ///
	legend(order(1 "Control Group" 2 "Protected Only" ) ring(0) position(10) row(2))
	
	
	
** Mining Only (0) vs MT Overlap (1)
twoway (mband p2 gold_price_real if treatStatus == 0) (mband p2 gold_price_real if treatStatus == 1), ///
	legend(order(1 "Mining Only" 2 "MT Overlap" ) ring(0) position(10) row(2))


	
	

	
***************************
** Graphing panel data
** 04-16-2022


ssc install distplot

graph bar (count) annual_change_val, over (year) if annual_change_val == 3

