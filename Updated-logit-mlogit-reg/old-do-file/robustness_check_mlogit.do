*** mlogit robustness check
*** 07/18/2022

**** Create TSA, SFP, and Control group
replace TYPE = "control" if strmatch(UID,"control*") == 1

gen concession_type = 1
replace concession_type = 2 if TYPE == "TSA"
replace concession_type = 0 if TYPE == "control"

tab annual_change_val concession_type, chi2


** 1. Subgroup impact

** TSA Group
mlogit annual_change_val i.treatStatus annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if (annual_change_val < 4) & concession_type != 1

** SFP Group
mlogit annual_change_val i.treatStatus annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement i.Tstage_2 [pweight = weights] /*
				 */ if (annual_change_val < 4) & concession_type != 2
				
				
** 2. Time stage interact with concession
** (not concave)
mlogit annual_change_val i.treatStatus#i.Tstage_2 annual_temp_Kelvin annual_rainfall_m /* 
					*/timber_price_GYD_k gold_price_GYD_k GUY_LABOR_k  /*
                  */dist_harbor dist_road dist_river dist_settlement [pweight = weights] /*
				 */ if (annual_change_val < 4) 


** 3. Time stage interact with price
		