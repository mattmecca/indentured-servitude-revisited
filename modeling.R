### Libraries Used ###

library(readr)
library(lmtest)
library(plm)
library(splines)
library(SuppDists)

panel_data = data.frame(read_csv('/Users/MattMecca/Downloads/indentured-servitude-revisited-master/panel_data.csv'))


## Linear Models ##

fixed_effects = plm(d_wealth ~ d_loans_per_person + d_income_after + sqrt(panel_data$hs_grad) + sqrt(panel_data$d_coll_grad), data = panel_data, index = c("age_group", "time"), model = "within")
summary(fixed_effects)

random_effects = plm(d_wealth ~ d_loans_per_person + sqrt(hs_grad) + sqrt(d_coll_grad), data = panel_data, index = c("age_group", "time"), model = "random")
summary(random_effects)


## Nonlinear, GAM Models ##

""" ns() or bs() functions stand for NATURAL splines and CUBIC splines; by adding them 
to our model, we make parts of an otherwise LINEAR model NONLINEAR. NOTE: we still need
to take the FIRST DIFFERENCES of these variables """

""" Either college grad and high school grad proportions or something else is COLINEAR. 
I think I may be getting this error because some of my variables are NONSTATIONARY. """ 

GAM_FE = plm(d_wealth ~ ns(d_loans_per_person, df = 4) + ns(d_income_after, df = 4) + sqrt(d_coll_grad), data = panel_data, index = c("age_group", "time"), model = "within")
summary(GAM_FE)

# Cubic splines do not seem to have ANY EFFECT

GAM_RE = plm(d_wealth ~ ns(d_loans_per_person, df = 4) + ns(d_income_after, df = 4) + sqrt(d_coll_grad), data = panel_data, index = c("age_group", "time"), model = "random")
summary(GAM_RE)


### Calculating the Median ###

## Calculating Pearson's Coefficient of Skewness using Median ##

# I.e., skewness = (3*(mu - med))/SD


### Simulation Technique using Johnson Distribution ###

# These values were derived from a related research paper
mu = 33400
var = 2.31243e+22
skew = 6.5103e-08
kurt = 3
t = c(mu, var, skew, kurt) 

parms = JohnsonFit(t, moment = "use")
n = 11000
distribution = rJohnson(n, parms)


##  Fit illustration

hist(distribution,freq=FALSE)


### Running a Granger Causality Test (Average Tuition Rates vs. Government 
### Guaranteed Student Loans) ### 

# Almost like the government subsidizing the institutions at the expense of the borrowers 
# (i.e., the students)

under_30 = subset(panel_data, age_group == '21_30') 

attach(under_30)

# We aim to see whether an INCREASE in LOANS PER PERSON cause a DECREASE
# in HOME OWNERSHIP or vice versa

# NULL: LOANS PER PERSON does NOT cause HOME OWNERSHIP, where LOANS PER 
# PERSON is our sort of INDEPENDENT VAR. and HOME OWNERSHIP is our sort 
# of DEPENDENT VAR.

grangertest(d_home_own ~ d_Loans_per, order = 2)

# We see that our results are SIGNIFICANT and so we have to REJECT the 
# NULL hypothesis

grangertest(D_Loans_per ~ D_Home_Own, order = 2)

