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
replace timber_concession_type = 2 if TYPE == "TSA"
replace timber_concession_type = 0 if TYPE == "control"

** Generate concession treatment effect (for single group panel)
gen withConcession = 0
replace withConcession = 1 if (YEAR_ISSUE < year)

** record degredation as forest
gen forest_type_binary = 0
replace forest_type_binary = 1 if (annual_change_val == 3)


****** Create a clean dataset and save as a new data file ******
tab TYPE annual_change_val





***************************************************
*********** 1. mlogit with DID settings ***********

mlogit annual_change_val i.treatStatus i.withConcession /*
				  */ annual_temp_Kelvin annual_rainfall_m /* 
				  */ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				  */ [pweight = weights] if (annual_change_val < 4 & TYPE != "NA")
				  
				  

****** Subgroup impact *******

tab annual_change_val withConcession if timber_concession_type != 2
tab TYPE annual_change_val



** TSA Group
mlogit annual_change_val i.treatStatus i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if (annual_change_val < 4) & timber_concession_type != 1

** SFP Group 
** ERROR MESSAGE: highly singular in MT setting
mlogit annual_change_val i.treatStatus i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if (annual_change_val < 4) & timber_concession_type != 2


********************************************************************
*********** 2. logit with degredation recorded as forest ***********

tab annual_change_val withConcession, chi2
tab annual_change_val treatStatus, chi2



** fixed effect setting
logit forest_type_binary i.treatStatus /*
				*/ annual_temp_Kelvin annual_rainfall_m /* 
				*/ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				*/ [pweight = weights] if (annual_change_val != 4 & TYPE != "NA")

** DID setting: 
** treatStatus: On land with concession
** withConcession: On land with concession & time after issue date
logit forest_type_binary i.treatStatus i.withConcession /*
				*/ annual_temp_Kelvin annual_rainfall_m /* 
				*/ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				*/ [pweight = weights] if (annual_change_val != 4 & TYPE != "NA")




