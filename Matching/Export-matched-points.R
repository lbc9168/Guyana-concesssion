#############################################
## Export matched points, UID and weights
##
##    1. Control vs Mining
##    2. Control vs Timber
##    3. Control vs Overlap
##    4. Timber vs Overlap
##
## Created by Bingcai Liu
## Date: 06-22-2022
#############################################


load("C:/Users/liu34/OneDrive/OSU/Working Papers/5 Guyana and Suriname/RProject/Propensity score matching/match_data_6group.RData")


C_M_Points <- rbind(C_M_control_wRepl, C_M_treat_wRepl)
C_M_Points <- subset(C_M_Points, select = c(UID, weights))

C_T_Points <- rbind(C_T_control_wRepl, C_T_treat_wRepl)
C_T_Points <- subset(C_T_Points, select = c(UID, weights))

C_MT_Points <- rbind(C_MT_control_wRepl, C_MT_treat_wRepl)
C_MT_Points <- subset(C_MT_Points, select = c(UID, weights))

