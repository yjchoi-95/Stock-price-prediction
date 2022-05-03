rm(list=ls())

## library
if(!require(caret)) install.packages("caret"); library(caret)
if(!require(dplyr)) install.packages("dplyr"); library(dplyr)
if(!require(devtools)) install.packages("devtools"); library(devtools)
if(!require(readAny))install_github("plgrmr/readAny", force = TRUE); library(readAny)
if(!require(mice)) install.packages("mice"); library(mice)

## setwd
setwd("~/GitHub/Stock-price-prediction/datasets")

## load data
list.files()
stock_df <- read.csv("before_nan2.csv", encoding = "UTF-8")
null_df <- stock_df[,!(stock_df %>% colnames) %in% c("c_target", "date")]

## Mice imputation
filled_df <- mice(null_df, m=5, method = "cart")
com_df01 <- complete(filled_df, 1)
com_df02 <- complete(filled_df, 2)
com_df03 <- complete(filled_df, 3)
com_df04 <- complete(filled_df, 4)
com_df05 <- complete(filled_df, 5)

mean_df <- (com_df01 + com_df02 + com_df03 + com_df04 + com_df05) / 5
mean_df <- cbind(stock_df$date, mean_df, stock_df$c_target)

write.csv(mean_df, "mice_df.csv", row.names = F)

## end of scripts