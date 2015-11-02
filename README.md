# ppR

Prior period variable creation for longitudinal data in R.

`ppR` contains methods to handle the creation and implementation of by-group
weighted mean and count variables for preceding records of the same group in
data which spans time.

Visually:

```
  (Summarise response over earlier data)    (Use as predictor on later record)

       +--------------------------+  -  -  -  -  -  -  -  -  -
       |                          |                          |
  >----^--------------------------^--------------------------v-------------->
                              ----> Time ---->
```

This can yield some pretty powerful predictors.

`ppR` operates by groups (such as territory or producer ID) and uses a sliding
window to produce summary variables for all time-group combinations which can be
merged to new data. Backend is largely c++ mediated by `data.table`.

The main function for training these variables is `train_ppgrid`,
which will create a just-in-time summary for each time-group combination.
This can be scored on new data with the method `merge_ppgrid`,
which returns the just-in-time weighted mean and count for a new dataframe as
a list.

## Example
```R
# install.packages("devtools")
# devtools::install_github("DexGroves/ppR")

library("ppR")

# Data
set.seed(1234)
ppdf <- make_longitudinal_data(1000)
ppdf_train <- ppdf[ppdf$date < 1150, ]
ppdf_test <- ppdf[ppdf$date >= 1150, ]

# Training
ppgrid <- train_ppgrid(ppdf_train$id,
                       ppdf_train$date,
                       ppdf_train$resp,
                       lag = 25,
                       window_size = 25,
                       granularity = 25)

# Scoring
merge_ppgrid(ppdf_test$id,
             ppdf_test$date,
             ppgrid)
```
