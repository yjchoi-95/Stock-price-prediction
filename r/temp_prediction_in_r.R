## library
if(!require(caret)) install.packages("caret"); library(caret)
if(!require(dplyr)) install.packages("dplyr"); library(dplyr)
if(!require(lime)) install.packages("lime"); library(lime)
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
if(!require(stringr)) install.packages("stringr"); library(stringr)
if(!require(lares)) install.packages("lares"); library(lares)

## setwd
setwd("~/GitHub/Stock-price-prediction/datasets")

## load data
list.files()
stock_df <- read.csv("stock_df_01.csv", encoding = "UTF-8")
stock_df %>% head()
stock_df$c_target <- factor(stock_df$c_target)
stock_df$n_target <- NULL

## data preproc
# var만 골라내기
data_x <- stock_df %>% head() %>% select(colnames(stock_df)[str_detect(colnames(stock_df), "var")])
data_x <- stock_df[,str_detect(colnames(stock_df), "var")]
data_x[is.na(data_x)] <- 0

## train test split
data_x %>% str
train_idx <- 1:(nrow(data_x)-1)
test_idx <- -train_idx

train_x <- data_x[train_idx, ]
test_x <- data_x[test_idx, ]
train_x$c_target <- stock_df$c_target[train_idx]
train_x %>% is.na %>% sum
train_x$c_target %>% mode

## fitting model
trctrl <- trainControl(method = "cv", number = 2)

tune_grid <- expand.grid(nrounds = 200,
                         max_depth = 5,
                         eta = 0.05,
                         gamma = 0.01,
                         colsample_bytree = 0.75,
                         min_child_weight = 0,
                         subsample = 0.5)

model_xgb <- train(c_target ~., data = train_x, method = "xgbTree",
                trControl=trctrl,
                tuneGrid = tune_grid)

predict_train <- predict(model_xgb, train_x)
confusionMatrix(train_x$c_target, predict_train)

## XAI with lime
explainer_caret <- lime(train_x, model_xgb, n_bins = 5)

explanation_caret <- explain(
  x = train_x[(nrow(train_x)-2):nrow(train_x),], 
  explainer = explainer_caret, 
  n_permutations = 5,
  dist_fun = "gower",
  kernel_width = .75,
  n_features = 10, 
  feature_select = "highest_weights",
  n_labels = 2
)

## plotting
windows()
plot_features(explanation_caret)

windows()
plot_explanations(explanation_caret)

mplot_density(c_target, predict_train)

## end of scripts