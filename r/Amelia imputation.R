rm(list=ls())

## library
if(!require(caret)) install.packages("caret"); library(caret)
if(!require(dplyr)) install.packages("dplyr"); library(dplyr)
if(!require(devtools)) install.packages("devtools"); library(devtools)
if(!require(readAny))install_github("plgrmr/readAny", force = TRUE); library(readAny)
if(!require(Amelia)) install.packages("Amelia"); library(Amelia)

## setwd
setwd("~/GitHub/Stock-price-prediction/datasets")

## load data
list.files()
stock_df <- read.csv("before_nan2.csv", encoding = "UTF-8")
null_df <- stock_df[,!(stock_df %>% colnames) %in% c("c_target", "date")]

## Amelia imputation
stock_df %>% head
filled_df <- amelia(null_df, m=5)

## mean results
filled_df$imputations[[1]]


## end of scripts