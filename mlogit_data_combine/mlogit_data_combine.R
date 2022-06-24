#############################
# combine weight and economic data with old mlogit dataset
#
# 06-24-2022
#############################


C_T_panel <- merge(C_T_panel, Guy_ECO, by = c("year"))
C_T_panel <- merge(C_T_panel, C_T_Points, by = c("UID"), all.x = TRUE)


library(foreign)
write.dta(C_T_panel, "C_T_panel_update.dta")
