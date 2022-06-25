#############################
# combine weight and economic data with old mlogit dataset
#
# 06-24-2022
#############################


C_T_panel <- merge(C_T_panel, Guy_ECO, by = c("year"))
C_T_panel <- merge(C_T_panel, C_T_Points, by = c("UID"), all.y = TRUE)

C_M_panel <- merge(C_M_panel, Guy_ECO, by = c("year"))
C_M_panel <- merge(C_M_panel, C_M_Points, by = c("UID"), all.y = TRUE)

C_MT_panel <- merge(C_MT_panel, Guy_ECO, by = c("year"))
C_MT_panel <- merge(C_MT_panel, C_MT_Points, by = c("UID"), all.y = TRUE)

T_MT_panel <- merge(MT_T_panel, Guy_ECO, by = c("year"))
T_MT_panel <- merge(T_MT_panel, T_MT_points, by = c("UID"), all.y = TRUE)


library(foreign)
write.dta(C_T_panel, "C_T_panel_update.dta")
write.dta(C_M_panel, "C_M_panel_update.dta")
write.dta(C_MT_panel, "C_MT_panel_update.dta")
write.dta(T_MT_panel, "T_MT_panel_update.dta")