########################################
# Combine concession information with logit and mlogit data
# for robustness check
#
# Created by Bingcai Liu
# 07/18/2022
########################################


library(tidyverse)
library(foreign)

colnames(Concession_info_TimberOnly)

info_TimberOnly <- Concession_info_TimberOnly %>%
  select(UID, OWNER, TYPE, ACRES)


info_MTOverlap <- Concession_info_MTOverlap %>%
  select(UID, OWNER, TYPE, ACRES)



#### Change dataframe names and combine with concession info, then export

## logit model

Panel_C_MT_logit <- merge(Panel_C_MT, info_MTOverlap, by = c("UID"), all.x = TRUE, all.y = FALSE)
Panel_C_T_logit <- merge(Panel_C_T, info_TimberOnly, by = c("UID"), all.x = TRUE)

write.dta(Panel_C_MT_logit, "Panel_C_MT_logit.dta")
write.dta(Panel_C_T_logit, "Panel_C_T_logit.dta")

rm(Panel_C_MT, Panel_C_T, Panel_C_MT_logit, Panel_C_T_logit)


## mlogit model
Panel_C_MT_mlogit <- merge(C_MT_panel_mlogit, info_MTOverlap, by = c("UID"), all.x = TRUE)
Panel_C_T_mlogit <- merge(C_T_panel_mlogit, info_TimberOnly, by = c("UID"), all.x = TRUE)

write.dta(Panel_C_MT_mlogit, "Panel_C_MT_mlogit.dta")
write.dta(Panel_C_T_mlogit, "Panel_C_T_mlogit.dta")

rm(Panel_C_T_mlogit, Panel_C_MT_mlogit, C_MT_panel_mlogit, C_T_panel_mlogit)



