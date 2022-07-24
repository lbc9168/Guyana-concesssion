########################################
# Calculate area of each concession type
#  
#
# Created by Bingcai Liu
# 07/19/2022
########################################



library(tidyverse)
library(dplyr)
library(plyr)

colnames(Concession_info_MTOverlap)


## Calculate the summation of each type of concession land
area_sum_MTOverlap <- ddply(Concession_info_MTOverlap, .(TYPE), summarize, sum_geo_area = sum(geo_area))
area_sum_TimberOnly <- ddply(Concession_info_TimberOnly, .(TYPE), summarize, sum_geo_area = sum(geo_area))

area_sum_Guyana <- ddply(Concession_info_Guyana, .(TYPE), summarize, sum_geo_area = sum(HECTARES))
