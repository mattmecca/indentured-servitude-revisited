### Libraries Used ###

library(readr)
library(plm)


### Data Import ###

unitroot_test_df = data.frame(read_csv('/Users/MattMecca/Downloads/indentured-servitude-revisited-master/unitroot_test_df.csv'))
features = c('wealth', 'loans_per_person', 'income_after', 'hs_grad', 'coll_grad')
for (feat in features){
  sub_df = subset(unitroot_test_df, var_of_int == feat)[c(4:dim(unitroot_test_df)[2])]
  print(purtest(sub_df, test = 'levinlin'))
}