#################################
# Update gold price and gold production data in 
# logit and mlogit analysis
# 
# 06-28-2022
#################################


gold_prod_prices <- read_csv("~/GitHub/Guyana-concesssion/Eco_timber_data/gold_prod_prices_2.csv")


#### mlogit analysis data

C_M_panel_update <- subset(C_M_panel_update, select = -c(OBJECTID, OBJECTID1, gold_quantity, gold_price_real))
C_MT_panel_update <- subset(C_MT_panel_update, select = -c(OBJECTID, OBJECTID1, gold_quantity, gold_price_real))
C_T_panel_update <- subset(C_T_panel_update, select = -c(OBJECTID, OBJECTID1, gold_quantity, gold_price_real))
T_MT_panel_update <- subset(T_MT_panel_update, select = -c(OBJECTID, weights_x, gold_quantity, gold_price_real))


## get exchange rate and US CPI deflated price

price_ex_rate <- merge(gold_prod_prices_2, exchange_rate, by = c("year"))


C_M_panel_mlogit <- merge(C_M_panel_update, price_ex_rate, by = c("year"))
C_MT_panel_mlogit <- merge(C_MT_panel_update, price_ex_rate, by = c("year"))
C_T_panel_mlogit <- merge(C_T_panel_update, price_ex_rate, by = c("year"))
T_MT_panel_mlogit <- merge(T_MT_panel_update, price_ex_rate, by = c("year"))



library(foreign)
write.dta(C_M_panel_mlogit, "C_M_panel_mlogit.dta")
write.dta(C_MT_panel_mlogit, "C_MT_panel_mlogit.dta")
write.dta(C_T_panel_mlogit, "C_T_panel_mlogit.dta")
write.dta(T_MT_panel_mlogit, "T_MT_panel_mlogit.dta")



