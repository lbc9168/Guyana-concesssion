****************************
* updated mlogit and logit regressions 
* 	1. with DID settings (include both time and location)
*   2. new logit regressions with degredation recorded as forest
*
* Created by: Bingcai Liu
* 2022-07-25


******** Adjust dataset, create factor variables ********

replace FID = 999 if strmatch(UID,"control*") == 1

**** Create TSA, SFP, and Control group
replace TYPE = "control" if strmatch(UID,"control*") == 1

gen timber_concession_type = 1
replace timber_concession_type = 2 if TYPE == "TSA" | TYPE == "WCL"
replace timber_concession_type = 0 if TYPE == "control"

** Generate concession treatment effect (for single group panel)
gen withConcession = 0
replace withConcession = 1 if (YEAR_ISSUE < year)

** record degredation as forest
gen forest_type_binary = 0
replace forest_type_binary = 1 if (annual_change_val == 3)


****** Create a clean dataset and save as a new data file ******
tab TYPE annual_change_val
tab timber_concession_type annual_change_val

** for C vs MT
drop if TYPE == "NA" | TYPE == "IWO" | TYPE == "NIL" | TYPE == "Mining Lease" 
drop if annual_change_val == 4
** for C vs T
drop if TYPE == "NA" | TYPE == "IWO" | TYPE == "NIL" | TYPE == "Agri Lease" 
drop if annual_change_val == 4
** for T vs MT
drop if TYPE == "NA" | TYPE == "IWO" | TYPE == "NIL" | TYPE == "Agri Lease" | TYPE == "Mining Lease"
drop if annual_change_val == 4
** for C vs M
drop if annual_change_val == 4




***************************************************
*********** 1. mlogit models ***********
				  
**** 1a. mlogit with fixed effect setting
mlogit annual_change_val i.treatStatus /*
				  */ annual_temp_Kelvin annual_rainfall_m /* 
				  */ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				  */ [pweight = weights] 
				  				  
**** 1b. mlogit with DID setting
mlogit annual_change_val i.treatStatus i.withConcession /*
				  */ annual_temp_Kelvin annual_rainfall_m /* 
				  */ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				  */ [pweight = weights] 
								  
								  
****** 1c. Subgroup impact, using fixed effect settings *******

tab annual_change_val Tstage_2 
tab TYPE annual_change_val
tab YEAR_ISSUE TYPE

** TSA Group
mlogit annual_change_val i.treatStatus annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if timber_concession_type != 1

** SFP Group 
** ERROR MESSAGE: highly singular in MT setting (07-26 update: because Tstage is correlated with result)
mlogit annual_change_val i.treatStatus annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if timber_concession_type != 2
				 
				 
****** 1d. Subgroup impact, using DID settings *******

** TSA Group
mlogit annual_change_val i.treatStatus i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if timber_concession_type != 1

** SFP Group 
mlogit annual_change_val i.treatStatus i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if timber_concession_type != 2


********************************************************************
*********** 2. logit with degredation recorded as forest ***********

tab annual_change_val withConcession, chi2
tab annual_change_val treatStatus, chi2


** 2a. fixed effect setting
logit forest_type_binary i.treatStatus /*
				*/ annual_temp_Kelvin annual_rainfall_m /* 
				*/ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				*/ [pweight = weights] 

** 2b. DID setting: 
** treatStatus: On land with concession
** withConcession: On land with concession & time after issue date
logit forest_type_binary i.treatStatus i.withConcession /*
				*/ annual_temp_Kelvin annual_rainfall_m /* 
				*/ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				*/ [pweight = weights] 


				
****************************************************************				
********* 2011-08-23 update *********
**** using 2-year lag gold price to test its impact to deforestation

** Generate 2-year lag gold price
sort UID year

by UID: gen gold_price_GYD_k_2ylag = gold_price_GYD_k[_n-2] if year == year[_n-2] + 2


** fixed effect model with mining (2 year lag gold price)
mlogit annual_change_val i.treatStatus /*
				  */ annual_temp_Kelvin annual_rainfall_m /* 
				  */ timber_price_GYD_k gold_price_GYD_k_2ylag GUY_LABOR_k  /*
                  */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				  */ [pweight = weights] 

** DID model with mining
mlogit annual_change_val i.treatStatus i.withConcession /*
				  */ annual_temp_Kelvin annual_rainfall_m /* 
				  */ timber_price_GYD_k gold_price_GYD_k_2ylag GUY_LABOR_k  /*
                  */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				  */ [pweight = weights] 