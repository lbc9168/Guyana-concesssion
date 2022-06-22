########################################
# Build different matching combinations
#  
# 1) 5 treatment groups with control group
# 2) comparison between some treatment groups
#
# Using Mahalanobis distance matching with propensity score with replacement
#
# Created by Bingcai Liu
# 03/01/2022
########################################


### load libraries
library(MatchIt)
library(tidyverse)
library(cobalt)


########### 1. Control vs Mining only ############


# read in full panel data
rx0 <- PSM_match_control %>% mutate(treatStatus=0)  # fire untreated
rx1 <- PSM_match_MiningOnly %>% mutate(treatStatus=1) # fire treated


colnames(rx0);colnames(rx1)


# combine datasets
panel_data_C_M <- bind_rows(rx0,rx1) %>% select(elevation, slope, annual_temp_norm_Kelvin, 
                                                annual_rainfall_norm_m, NEAR_DIST_settlement, NEAR_DIST_harbor, 
                                                NEAR_DIST_road, NEAR_DIST_river, UID, treatStatus, slat, slong)  



# Matching process
## 03-28-22 update: basically the two matching methods lead to the same result,
## but the number of items are different, which we don't use for now
## So we can just use the shorter version to match

match_mahvars_ps_wRepl_1 <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_M,
                                  distance = "glm",
                                  mahvars = ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river,
                                  caliper = .2, ratio = 1, replace=T)

match_mahvars_ps_wRepl_2 <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                      NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                      NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_M,
                                    distance = "mahalanobis", replace=T)

plot(summary(match_mahvars_ps_wRepl_2), position = "topright")

match_mahvars_ps_wRepl
summary(match_mahvars_ps_wRepl_1)
summary(match_mahvars_ps_wRepl_2)

plot(summary(match_mahvars_ps_wRepl_2), position = "topright")



# extract control and treated matches
C_M_treat_wRepl <- match.data(match_mahvars_ps_wRepl_2,group = 'treat')
C_M_control_wRepl <- match.data(match_mahvars_ps_wRepl_2,group = 'control')




########### 2. Control vs Indigenous tenure only ############

# read in full panel data
rx0 <- PSM_match_control %>% mutate(treatStatus=0)  # fire untreated
rx1 <- PSM_match_IndTenure %>% mutate(treatStatus=1) # fire treated


colnames(rx0);colnames(rx1)


# combine datasets
panel_data_C_I <- bind_rows(rx0,rx1) %>% select(elevation, slope, annual_temp_norm_Kelvin, 
                                                annual_rainfall_norm_m, NEAR_DIST_settlement, NEAR_DIST_harbor, 
                                                NEAR_DIST_road, NEAR_DIST_river, UID, treatStatus, slat, slong)  



# Matching process
match_mahvars_ps_wRepl <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + NEAR_DIST_settlement +  
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_I,
                                  distance = "glm",
                                  mahvars = ~ elevation + slope + annual_rainfall_norm_m + NEAR_DIST_settlement +  
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river,
                                  caliper = .2, ratio = 1, replace=T)

match_mahvars_ps_wRepl
summary(match_mahvars_ps_wRepl)

match_mahvars_ps_wRepl_2 <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                      NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                      NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_I,
                                    distance = "mahalanobis", replace=T)
plot(summary(match_mahvars_ps_wRepl_2), position = "topright")

# extract control and treated matches
C_I_treat_wRepl <- match.data(match_mahvars_ps_wRepl,group = 'treat')
C_I_control_wRepl <- match.data(match_mahvars_ps_wRepl,group = 'control')






########### 3. Control vs Mining and Timber overlap ############

# read in full panel data
rx0 <- PSM_match_control %>% mutate(treatStatus=0)  # fire untreated
rx1 <- PSM_match_MToverlap %>% mutate(treatStatus=1) # fire treated


colnames(rx0);colnames(rx1)


# combine datasets
panel_data_C_MT <- bind_rows(rx0,rx1) %>% select(elevation, slope, annual_temp_norm_Kelvin, 
                                                annual_rainfall_norm_m, NEAR_DIST_settlement, NEAR_DIST_harbor, 
                                                NEAR_DIST_road, NEAR_DIST_river, UID, treatStatus, slat, slong)  



# Matching process
match_mahvars_ps_wRepl <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + NEAR_DIST_settlement +  
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_MT,
                                  distance = "glm",
                                  mahvars = ~ elevation + slope + annual_rainfall_norm_m + NEAR_DIST_settlement +  
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river,
                                  caliper = .2, ratio = 1, replace=T)

match_mahvars_ps_wRepl
summary(match_mahvars_ps_wRepl)

match_mahvars_ps_wRepl_2 <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                      NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                      NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_MT,
                                    distance = "mahalanobis", replace=T)
plot(summary(match_mahvars_ps_wRepl_2), position = "topright")



# extract control and treated matches
C_MT_treat_wRepl <- match.data(match_mahvars_ps_wRepl_2,group = 'treat')
C_MT_control_wRepl <- match.data(match_mahvars_ps_wRepl_2,group = 'control')






########### 4. Control vs Protected area only ############

# read in full panel data
rx0 <- PSM_match_control %>% mutate(treatStatus=0)  # fire untreated
rx1 <- PSM_match_ProtectedOnly %>% mutate(treatStatus=1) # fire treated


colnames(rx0);colnames(rx1)


# combine datasets
panel_data_C_P <- bind_rows(rx0,rx1) %>% select(elevation, slope, annual_temp_norm_Kelvin, 
                                                 annual_rainfall_norm_m, NEAR_DIST_settlement, NEAR_DIST_harbor, 
                                                 NEAR_DIST_road, NEAR_DIST_river, UID, treatStatus, slat, slong)  



# Matching process
match_mahvars_ps_wRepl <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + NEAR_DIST_settlement +  
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_P,
                                  distance = "glm",
                                  mahvars = ~ elevation + slope + annual_rainfall_norm_m + NEAR_DIST_settlement +  
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river,
                                  caliper = .2, ratio = 1, replace=T)

match_mahvars_ps_wRepl
summary(match_mahvars_ps_wRepl)

match_mahvars_ps_wRepl_2 <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                      NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                      NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_P,
                                    distance = "mahalanobis", replace=T)
plot(summary(match_mahvars_ps_wRepl_2), position = "topright")





###### 06-05-2022 update: 6. Timber vs Overlap
rx0 <- PSM_match_TimberOnly %>% mutate(treatStatus=1)  # fire untreated
rx1 <- PSM_match_MToverlap %>% mutate(treatStatus=0) # fire treated

colnames(rx0);colnames(rx1)

# combine datasets
Match_T_MT <- bind_rows(rx0,rx1) %>% select(elevation, slope, annual_temp_norm_Kelvin, 
                                                annual_rainfall_norm_m, NEAR_DIST_settlement, NEAR_DIST_harbor, 
                                                NEAR_DIST_road, NEAR_DIST_river, UID, treatStatus, slat, slong) 

match_mahvars_ps_wRepl_2 <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                      NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                      NEAR_DIST_road + NEAR_DIST_river, data = Match_T_MT,
                                    distance = "mahalanobis", replace=T)
plot(summary(match_mahvars_ps_wRepl_2), position = "topright")



# extract control and treated matches
T_MT_treat_wRepl <- match.data(match_mahvars_ps_wRepl_2,group = 'treat')
T_MT_control_wRepl <- match.data(match_mahvars_ps_wRepl_2,group = 'control')


## combine matched data, then export matched dataset
T_MT_points <- bind_rows(T_MT_control_wRepl, T_MT_treat_wRepl) %>% select(UID, treatStatus)

bal_T_MT_matched2 <- merge(bal_panel_T_MT_matched, T_MT_points, by = c("UID"))
bal_T_MT_matched2_invert <- merge(bal_panel_T_MT_matched, T_MT_points, by = c("UID"))

library(foreign)
write.dta(bal_T_MT_matched2, "bal_T_MT_matched2.dta")
write.dta(bal_T_MT_matched2_invert, "bal_T_MT_matched2_invert.dta")


########### 5. Control vs Timber only ############

# read in full panel data
rx0 <- PSM_match_control %>% mutate(treatStatus=0)  # untreated
rx1 <- PSM_match_TimberOnly %>% mutate(treatStatus=1) # treated


colnames(rx0);colnames(rx1)


# combine datasets
panel_data_C_T <- bind_rows(rx0,rx1) %>% select(elevation, slope, annual_temp_norm_Kelvin, 
                                                annual_rainfall_norm_m, NEAR_DIST_settlement, NEAR_DIST_harbor, 
                                                NEAR_DIST_road, NEAR_DIST_river, UID, treatStatus, slat, slong)  



# Matching process
match_mahvars_ps_wRepl <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + NEAR_DIST_settlement +  
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_T,
                                  distance = "glm",
                                  mahvars = ~ elevation + slope + annual_rainfall_norm_m + NEAR_DIST_settlement +  
                                    NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                    NEAR_DIST_road + NEAR_DIST_river,
                                  caliper = .2, ratio = 1, replace=T)

match_mahvars_ps_wRepl
summary(match_mahvars_ps_wRepl)

match_mahvars_ps_wRepl_2 <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                      NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                      NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_T,
                                    distance = "mahalanobis", replace=T)
plot(summary(match_mahvars_ps_wRepl_2), position = "top")

# extract control and treated matches
C_T_treat_wRepl <- match.data(match_mahvars_ps_wRepl_2,group = 'treat')
C_T_control_wRepl <- match.data(match_mahvars_ps_wRepl_2,group = 'control')


## 04-19-2022 GLM match to compare
match_ps_wRepl <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                      NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                      NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_T,
                                    distance = "glm", replace=T)
plot(summary(match_ps_wRepl), position = "top")

## 04-20-2022 MDM with no replacement
match_mahvars_ps_wRepl_2 <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                      NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                      NEAR_DIST_road + NEAR_DIST_river, data = panel_data_C_T,
                                    distance = "mahalanobis", replace=F)
plot(summary(match_mahvars_ps_wRepl_2), position = "top")



## 6. Timber vs. MT overlap

# read in full panel data
rx0 <- PSM_match_MToverlap %>% mutate(treatStatus=0)  # untreated
rx1 <- PSM_match_TimberOnly %>% mutate(treatStatus=1) # treated


# combine datasets
panel_data_MT_T <- bind_rows(rx0,rx1) %>% select(elevation, slope, annual_temp_norm_Kelvin, 
                                                annual_rainfall_norm_m, NEAR_DIST_settlement, NEAR_DIST_harbor, 
                                                NEAR_DIST_road, NEAR_DIST_river, UID, treatStatus, slat, slong)  


# Matching process
match_mahvars_ps_wRepl_2 <- matchit(treatStatus ~ elevation + slope + annual_rainfall_norm_m + annual_temp_norm_Kelvin + 
                                      NEAR_DIST_settlement + NEAR_DIST_harbor +  
                                      NEAR_DIST_road + NEAR_DIST_river, data = panel_data_MT_T,
                                    distance = "mahalanobis", replace=F)
plot(summary(match_mahvars_ps_wRepl_2), position = "topright")
