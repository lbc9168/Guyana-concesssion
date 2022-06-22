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
