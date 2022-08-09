*****************************************
** Update the Staggered DID models
** 	1. Change the effecive time of TSA (Valid for 25 years), and use 1990-2016 data
**  2. use 2006-2015 data as robustness check
**
** Date: 08-09-2022
** Created by: Bingcai Liu
*****************************************



** TSA are vaild for 25 years, 
** change value of "withConcession" to 0 if current year is out of concession

gen YEAR_EXPIRE = YEAR_ISSUE + 25 if TYPE == "TSA"
replace withConcession = 0 if YEAR_EXPIRE < year

** generate a new time stage variable, seperated by 2010
gen Tstage_3 = 1
replace Tstage_3 = 0 if year < 2010

** updated staggered DID model

****** 1b. mlogit with DID setting *********
mlogit annual_change_val i.treatStatus i.withConcession /*
				  */ annual_temp_Kelvin annual_rainfall_m /* 
				  */ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				  */ [pweight = weights] if year <= 2016
				  
				  
				  
****** 1d. Subgroup impact, using DID settings *******

** TSA Group
mlogit annual_change_val i.treatStatus i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if timber_concession_type != 1 & year <= 2016

** SFP Group 
mlogit annual_change_val i.treatStatus i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if timber_concession_type != 2 & year <= 2016		 		  
				 
				 
********* 2b. logit DID setting:  *************
** treatStatus: On land with concession
** withConcession: On land with concession & time after issue date
logit forest_type_binary i.treatStatus i.withConcession /*
				*/ annual_temp_Kelvin annual_rainfall_m /* 
				*/ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k /*
                */ dist_harbor dist_road dist_river dist_settlement i.Tstage_2 /*
				*/ [pweight = weights] if year <= 2016
	

***************************************
********** Robustness check ***********
** Use DID model, time: 2006-2015

**** mlogit with DID settings ****
mlogit annual_change_val i.treatStatus i.withConcession /*
				  */ annual_temp_Kelvin annual_rainfall_m /* 
				  */ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */ dist_harbor dist_road dist_river dist_settlement i.Tstage_3 /*
				  */ [pweight = weights] if year <= 2015 & year >=2006 
				  
**** mlogit with fixed effect settings ****
mlogit annual_change_val i.treatStatus /*
				  */ annual_temp_Kelvin annual_rainfall_m /* 
				  */ timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */ dist_harbor dist_road dist_river dist_settlement i.Tstage_3 /*
				  */ [pweight = weights] if year <= 2015 & year >=2006 				  
				  
**** Subgroup impact, using DID settings ****

** TSA Group
mlogit annual_change_val i.treatStatus i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_3 [pweight = weights] /*
				 */ if timber_concession_type != 1 & year <= 2015 & year >=2006

** SFP Group 
mlogit annual_change_val i.treatStatus i.withConcession annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_3 [pweight = weights] /*
				 */ if timber_concession_type != 2 & year <= 2015 & year >=2006	 		  				  
				  