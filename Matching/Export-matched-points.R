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



## Get the most recent points for matching
load("C:/Users/liu34/Documents/ArcGIS/Projects/Guyana_concession_5group/Guyana_5group/R_project/PSM_032322.RData")

save(PSM_match_control, PSM_match_MiningOnly, PSM_match_MToverlap, PSM_match_TimberOnly, file = "points_to_match_220622.RData")



## Update matched points
load("~/GitHub/Guyana-concesssion/Matching/matched_points_220622.RData")

rm(PSM_match_control,PSM_match_IndTenure,PSM_match_MiningOnly,PSM_match_MToverlap,PSM_match_ProtectedOnly,PSM_match_TimberOnly)


## then go to "PSM_match_groups_creation.R" to match


## Back to this file
C_M_Points <- rbind(C_M_control_wRepl, C_M_treat_wRepl)
C_M_Points <- subset(C_M_Points, select = c(UID, weights))

C_T_Points <- rbind(C_T_control_wRepl, C_T_treat_wRepl)
C_T_Points <- subset(C_T_Points, select = c(UID, weights))

C_MT_Points <- rbind(C_MT_control_wRepl, C_MT_treat_wRepl)
C_MT_Points <- subset(C_MT_Points, select = c(UID, weights))

T_MT_points <- bind_rows(T_MT_control_wRepl, T_MT_treat_wRepl) %>% select(UID, weights)

## Export the points
save(C_M_Points, C_T_Points, C_MT_Points, T_MT_points, file = "matched_points_220622.RData")


## Combine matched points (weight) with panel data
Panel_C_MT <- merge(bal_panel_MT_matched, C_MT_Points, by = c("UID"), all.x = TRUE)
Panel_C_M <- merge(C_M_panel, C_M_Points, by = c("UID"), all.x = TRUE)
Panel_C_T <- merge(bal_panel_timber_matched, C_T_Points, by = c("UID"), all.x = TRUE)
Panel_T_MT <- merge(Panel_T_MT, T_MT_points, by = c("UID"), all.x = TRUE)

## Export data for regression
library(foreign)

write.dta(Panel_C_MT, "Panel_C_MT.dta")
write.dta(C_M_panel, "Panel_C_M.dta")
write.dta(bal_panel_timber_matched, "Panel_C_T.dta")
write.dta(T_MT_panel, "Panel_T_MT.dta")

#### export matched points data for mapping
load("~/GitHub/Guyana-concesssion/mlogit_data_combine/mlogit_data_combine.RData")

## Pick slat, slong, treatstatus of the matched points
C_M_positions <- subset(C_M_panel, select = c(UID,slat,slong,treatStatus))
C_T_positions <- subset(C_T_panel, select = c(UID,slat,slong,treatStatus))
C_MT_positions <- subset(C_MT_panel, select = c(UID,slat,slong,treatStatus))
T_MT_positions <- subset(T_MT_panel, select = c(UID,slat,slong,treatStatus))

C_M_positions <- merge(C_M_Points, C_M_positions, by = c("UID"))
C_M_positions <- C_M_positions[!duplicated(C_M_positions$UID),]

C_T_positions <- merge(C_T_Points, C_T_positions, by = c("UID"))
C_T_positions <- C_T_positions[!duplicated(C_T_positions$UID),]

C_MT_positions <- merge(C_MT_Points, C_MT_positions, by = c("UID"))
C_MT_positions <- C_MT_positions[!duplicated(C_MT_positions$UID),]

T_MT_positions <- merge(T_MT_points, T_MT_positions, by = c("UID"))
T_MT_positions <- T_MT_positions[!duplicated(T_MT_positions$UID),]

## export as csv file
write.csv(C_M_positions, "C_M_positions.csv")
write.csv(C_T_positions, "C_T_positions.csv")
write.csv(C_MT_positions, "C_MT_positions.csv")
write.csv(T_MT_positions, "T_MT_positions.csv")

