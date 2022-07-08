#################
## Make balanced panel data

# from :
# C:/Users/liu34/Documents/ArcGIS/Projects/Guyana_concession_5group/Guyana_5group/R_project/Guyana_timber_concession_combine.R


load("~/ArcGIS/Projects/Guyana_concession_5group/Guyana_5group/R_project/PSM_032322.RData")

###### make panel data ######

## Timber concession
## 04-28-2022
## panel data with land type 1 and 3 Only
Panel_timber_2type <- subset(Panel_timber, (annual_change_val == 1 | annual_change_val == 3))
Panel_MToverlap_2type <- subset(Panel_MToverlap, (annual_change_val == 1 | annual_change_val == 3))

## Balance panel data
bal_panel_timber_2type <- complete(Panel_timber_2type, UID, year)
bal_panel_timber_2type <- subset(bal_panel_timber_2type, !UID %in% unique(UID[is.na(slat)]))

bal_panel_MToverlap_2type <- complete(Panel_MToverlap_2type, UID, year)
bal_panel_MToverlap_2type <- subset(bal_panel_MToverlap_2type, !UID %in% unique(UID[is.na(slat)]))

## output data
library(foreign)
write.dta(bal_panel_timber_2type, "bal_panel_timber_2type.dta")
write.dta(bal_panel_MToverlap_2type, "bal_panel_MToverlap_2type.dta")




######## using matched data to make panel data

## mountain and overlap concession
## merge matched dataset with concession information data
Panel_timber_matched <- merge(x = C_T_panel,  y = info_TimberOnly, 
                              by.x = c("UID"), by.y = c("UID"), all.x = TRUE)
Panel_MT_matched <- merge(x = C_MT_panel,  y = info_MTOverlap, 
                          by.x = c("UID"), by.y = c("UID"), all.x = TRUE)
Panel_mining_matched

## Subset panel data for two land type
Panel_timber_matched <- subset(Panel_timber_matched, (annual_change_val == 1 | annual_change_val == 3))
Panel_MT_matched <- subset(Panel_MT_matched, (annual_change_val == 1 | annual_change_val == 3))
Panel_mining_matched <- subset()

## Balance panel data
bal_panel_timber_matched <- complete(Panel_timber_matched, UID, year)
bal_panel_timber_matched <- subset(bal_panel_timber_matched, !UID %in% unique(UID[is.na(slat)]))

bal_panel_MT_matched <- complete(Panel_MT_matched, UID, year)
bal_panel_MT_matched <- subset(bal_panel_MT_matched, !UID %in% unique(UID[is.na(slat)]))


## output data
write.dta(bal_panel_timber_matched, "bal_panel_timber_matched.dta")
write.dta(bal_panel_MT_matched, "bal_panel_MT_matched.dta")

save(bal_panel_MT_matched, bal_panel_MToverlap_2type, bal_panel_timber_2type, bal_panel_timber_matched, 
     file = "panel_2type.RData")