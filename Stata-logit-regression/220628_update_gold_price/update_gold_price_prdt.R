#################################
# Update gold price and gold production data in 
# logit and mlogit analysis
# 
# 06-28-2022
#################################


gold_prod_prices <- read_csv("~/GitHub/Guyana-concesssion/Eco_timber_data/gold_prod_prices.csv")


#### logit analysis data

Panel_C_M <- subset(Panel_C_M, select = -c(OBJECTID, OBJECTID1))
Panel_C_MT <- subset(Panel_C_MT, select = -c(OBJECTID, OBJECTID1))
Panel_C_T <- subset(Panel_C_T, select = -c(OBJECTID, OBJECTID1))
Panel_T_MT <- subset(T_MT_panel, select = -c(OBJECTID, weights.x, gold_quantity, gold_price_real))


## get exchange rate and US CPI deflated price

price_ex_rate <- merge(gold_prod_prices_2, exchange_rate, by = c("year"))


Panel_C_M <- merge(Panel_C_M, price_ex_rate, by = c("year"))
Panel_C_MT <- merge(Panel_C_MT, price_ex_rate, by = c("year"))
Panel_C_T <- merge(Panel_C_T, price_ex_rate, by = c("year"))
Panel_T_MT <- merge(Panel_T_MT, price_ex_rate, by = c("year"))

library(foreign)
write.dta(Panel_C_MT, "Panel_C_MT.dta")
write.dta(Panel_C_M, "Panel_C_M.dta")
write.dta(Panel_C_T, "Panel_C_T.dta")
write.dta(Panel_T_MT, "Panel_T_MT.dta")


#### mlogit analysis data
