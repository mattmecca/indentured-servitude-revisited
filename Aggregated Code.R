####################################################################################################
######################################## Thesis Project in R #######################################

#### Thesis ####

library(readr)
paneldata = read_csv("~/Documents/Graduate School/4th Semester Courses/Master's Thesis/Data Folder/Panel Data –– R Format.csv")
paneldata = na.omit(paneldata)
paneldata$ID = seq.int(nrow(paneldata))
D_Mort_Rate = read_csv("~/Documents/Graduate School/4th Semester Courses/Master's Thesis/Project Material/D_Mort_Rate.csv")


### Constructing our GAM ###


## Plot 

## Checking for Stationarity -- https://www.rdocumentation.org/packages/plm/versions/1.6-5/topics/purtest ##

library(plm)
AssetAccum_split = data.frame(split(paneldata$Wealth, paneldata$Age_Group))
Loans_per_split = data.frame(split(paneldata$Loans_per_person, paneldata$Age_Group))
Income_After_split = data.frame(split(paneldata$Income_After, paneldata$Age_Group))
HS_Grad_split = data.frame(split(paneldata$HS_Grad, paneldata$Age_Group))
Coll_Grad_split = data.frame(split(paneldata$Coll_Grad, paneldata$Age_Group))
Coll_Grad_split = data.frame(split(paneldata$Coll_Grad, paneldata$Age_Group))

purtest(AssetAccum_split, test = "levinlin") # Nonstationary
purtest(Loans_per_split, test = "levinlin") # Nonstationary
purtest(Income_After_split, test = "levinlin") # Nonstationary
purtest(HS_Grad_split, test = "levinlin") # Stationary
purtest(Coll_Grad_split, test = "levinlin") # Nonstationary


## Asset Accumulation DIFFERENCING ##

D_AssetAccum1 = data.frame(diff(AssetAccum_split$Under_30))
D_AssetAccum2 = data.frame(diff(AssetAccum_split$X30_39))
D_AssetAccum3 = data.frame(diff(AssetAccum_split$X40_49))
D_AssetAccum4 = data.frame(diff(AssetAccum_split$X50_59))
D_AssetAccum5 = data.frame(diff(AssetAccum_split$X60_plus))

D_AssetAccum1$ID = seq.int(nrow(D_AssetAccum1))
D_AssetAccum2$ID = seq.int(nrow(D_AssetAccum2))
D_AssetAccum3$ID = seq.int(nrow(D_AssetAccum3))
D_AssetAccum4$ID = seq.int(nrow(D_AssetAccum4))
D_AssetAccum5$ID = seq.int(nrow(D_AssetAccum5))

# remove(D_AssetAccum1, D_AssetAccum2, D_AssetAccum3, D_AssetAccum4 ,D_AssetAccum5)

D_AssetAccum = merge(D_AssetAccum1, D_AssetAccum2, by = "ID")
D_AssetAccum = merge(D_AssetAccum, D_AssetAccum3, by = "ID")
D_AssetAccum = merge(D_AssetAccum, D_AssetAccum4, by = "ID")
D_AssetAccum = merge(D_AssetAccum, D_AssetAccum5, by = "ID")


## Loans per Person DIFFERENCING ##

D_Loans_per = matrix(0, nrow=28, ncol = 5)

for (i in 1:5){
  D_Loans_per[,i] = diff(Loans_per_split[,i])
}

D_Loans_per = as.data.frame(D_Loans_per)

D_Loans_per = gather(D_Loans_per, key = "Age_group", value = "D_Loans_per", 1:5)

D_Loans_per$ID = seq.int(nrow(D_Loans_per))

paneldata = merge(paneldata, D_Loans_per, by = "ID")

paneldata$Age_group = NULL


## Income After DIFFERENCING ##

D_Income_After = matrix(0,nrow=28,ncol = 5)

for (i in 1:5){
  D_Income_After[,i] = diff(Income_After_split[,i])
}

D_Income_After = as.data.frame(D_Income_After)

D_Income_After = lag(D_Income_After$V2, k = 1)

D_Income_After = gather(D_Income_After, key = "Age_group", value = "D_Income_After", 1:5)

D_Income_After$ID = seq.int(nrow(D_Income_After))

paneldata = merge(paneldata, D_Income_After, by = "ID")

paneldata$Age_group = NULL


## College Proportion DIFFERENCING ##

D_Coll_Grad = matrix(0,nrow=28,ncol = 5)

for (i in 1:5){
  D_Coll_Grad[,i] = diff(Coll_Grad_split[,i])
}

D_Coll_Grad = as.data.frame(D_Coll_Grad)

D_Coll_Grad = gather(D_Coll_Grad, key = "Age_group", value = "D_Coll_Grad", 1:5)

D_Coll_Grad$ID = seq.int(nrow(D_Coll_Grad))

paneldata = merge(paneldata, D_Coll_Grad, by = "ID")

paneldata$D_Income_After.x = NULL
paneldata$D_Income_After.y = NULL
paneldata$Mortgage_Rate.x = NULL
paneldata$Mortgage_Rate.y = NULL
paneldata$Age_group = NULL
paneldata$Age_group.x = NULL
paneldata$Age_group.y = NULL
paneldata$D_Loans_per.x = NULL
paneldata$D_Loans_per.y = NULL
paneldata$D_Coll_Grad.x = NULL
paneldata$D_Coll_Grad.y = NULL


## Mortgage_Rate Proportion DIFFERENCING ##

D_Mort_Rate$ID = seq.int(nrow(D_Mort_Rate))
paneldata = merge(paneldata, D_Mort_Rate, by = "ID")


## Hootenanny ##
paneldata$Age_group = NULL
paneldata$Age_group.x = NULL
paneldata$Age_group.y = NULL
paneldata$D_Loans_per.x = NULL
paneldata$D_Loans_per.y = NULL
paneldata$Mortgage_Rate = NULL
paneldata$D_Asset_Accum = NULL


## Nonlinear GAM Models vs. Linear Models##

""" ns() or bs() functions stand for NATURAL splines and CUBIC splines; by adding them 
to our model, we make parts of an otherwise LINEAR model NONLINEAR. NOTE: we still need
to take the FIRST DIFFERENCES of these variables """

FE = plm(formula = D_Asset_Accum ~ D_Loans_per + D_Income_After + sqrt(Coll_Grad) + D_Mort_Rate, data = paneldata, index = c("Age_Group", "Time"), model = "within")
summary(FE)


# Must run K-FOLD CV in order to MERIT the SELECTION of 5 KNOTS

GAM_FE = plm(formula = D_Asset_Accum ~ ns(D_Loans_per, df = 6) + ns(L_D_Income_After, df = 6) + sqrt(Coll_Grad) + D_Mort_Rate, data = paneldata, index = c("Age_Group", "Time"), model = "within")
summary(GAM_FE)
plot(paneldata$D_Loans_per, paneldata$D_Asset_Accum)


## Exporting to Excel ##

# install.packages("devtools")
library(devtools)
# install_github("dgrtwo/broom")
library(broom)

## Random Effects Table ##
Tidied_Random_Effects = tidy(GAM_RE)
Tidied_Random_Effects
write.csv(Tidied_Random_Effects, "Tidied_Random_Effects.csv")

## Fixed Effects Table ##
Tidied_Fixed_Effects = tidy(GAM_FE)
Tidied_Fixed_Effects
# NOTE: there is NO INTERCEPT w/ FIXED EFFECTS (it's CANCELLED out)
write.csv(Tidied_Fixed_Effects, "Tidied_Fixed_Effects.csv")

## Hausman Table ##
Tidied_Hausman = tidy(Hausman)
Tidied_Hausman

write.csv(Tidied_Hausman, "Tidied_Hausman.csv")


### Running a Granger Causality Test (Average Tuition Rates vs. Government 
### Guaranteed Student Loans) ### 


# install.packages("lmtest")
library(lmtest)

## First we have to check STATIONARITY ##

## Using the Augmented Dickey Fuller test ##

# install.packages("urca")
library(urca)
Tuition_and_Federal_Loans$ID = seq.int(nrow(Tuition_and_Federal_Loans))

plot(Tuition_and_Federal_Loans$ID, Tuition_and_Federal_Loans$Dollars_Outstanding)
plot(Tuition_and_Federal_Loans$ID, Tuition_and_Federal_Loans$Tuition_Rates)

ADF_DollOut = ur.df(Tuition_and_Federal_Loans$Dollars_Outstanding, type = "trend", selectlags = "AIC")
summary(ADF_DollOut)

ADF_DollOut@lags # Telling us it's I(1)

ADF_TuiRate = ur.df(Tuition_and_Federal_Loans$Tuition_Rates, type = "trend", selectlags = "AIC")
summary(ADF_TuiRate)

ADF_TuiRate@lags


## Using the Philips Perron Test ## 

ADF_DollOut = ur.pp(Tuition_and_Federal_Loans$Dollars_Outstanding, type = "Z-tau", model = "trend")
summary(ADF_DollOut) # Significant in the first lag ==> I(1)

ADF_TuiRate = ur.pp(Tuition_and_Federal_Loans$Tuition_Rates, type = "Z-tau", model = "trend")
summary(ADF_TuiRate) # Significant in the first lag ==> I(1)

write.csv(paneldata, "Project_Data.csv")


## Actual Granger Causality Test ##

GrangerCaus = matrix(0, nrow=39, ncol = 0)
GrangerCaus = as.data.frame(GrangerCaus)
GrangerCaus$ID = seq.int(nrow(GrangerCaus))

GrangerCaus$D_Loans = diff(Tuition_and_Federal_Loans$Dollars_Outstanding)
GrangerCaus$D_Tuition = diff(Tuition_and_Federal_Loans$Tuition_Rates)

GrangerCaus$D_Debt_per_person = diff(Tuition_and_Federal_Loans$Debt_per_person)
GrangerCaus$D_Unduplicated_Recipients = diff(Tuition_and_Federal_Loans$Unduplicated_Recipients)

# The two series to be tested for GRANGER CAUSALITY are the above. We
# aim to see whether an INCREASE in LOANS PER PERSON cause an INCREASE
# in TUITION or vice versa

# NULL: LOANS PER PERSON does NOT cause higher TUITION RATES, where LOANS PER 
# PERSON is our sort of INDEPENDENT VAR. and TUITION RATES is our sort 
# of DEPENDENT VAR.

grangertest(GrangerCaus$D_Tuition ~ GrangerCaus$D_Loans, order = 2)


# We see that our results are INSIGNIFICANT and so we canNOT REJECT the 
# NULL hypothesis


## Unduplicated recipients sufficiently pushes our action ##


grangertest(GrangerCaus$D_Tuition ~ GrangerCaus$D_Unduplicated_Recipients, order = 2)
# TWO LAGS of CHANGE in UNDUPLICATED RECIPIENTS is used to explain CHANGE IN TUITION
# rather than two lags of change in tuition ==> simply replacing one by the other 
# and seeing if our model is at all significant (too many lags and we may get a significant
# F-stat simply because of the number of variables in our our equation; two few and we
# risk a biased test because of residual autocorrelation)


## Stacking the Columns ##
library(tidyr)
D_Asset_Accum = gather(D_AssetAccum, key = "Age_group", value = "D_Asset_Accum", 2:6)
D_Asset_Accum$ID = seq.int(nrow(D_Asset_Accum))

paneldata = merge(paneldata, D_Asset_Accum, by = "ID")
paneldata$Age_group = NULL # Drops column

# install.packages("gld")
library("gld")

## GENERALIZED LAMBDA DISTRIBUTION ##

# FINDING PARAMETERS


###############################################################################
########### Student Loan distributions for 1994, 2001 and 2009 ################
###############################################################################

## Initializing moments ##

nv = 3           # number of years considered
muy = c(15000,	22400,	24600) 
vary = c(49284,	65025,	19500) 
skwy = c(2.702702703,	43.52941176,	56.66666667) 
kury <- c(2.702702703*1.2,	43.52941176*1.2,	56.66666667*1.2)

## EXTRACTING PARAMETERS for GLD ##
Lambday <- as.data.frame(matrix((NA), nrow = nv, ncol = 4))
colnames(Lambday) <- c("h1", "h2", "h3", "h4") 
for (i in 1:nv) {
  Lambday[i,] <- fit.fkml.moments.val(moments=c(mean=muy[i], variance=vary[i], skewness=skwy[i], kurtosis=kury[i]), optim.method="Nelder-Mead", optim.control= list(),
                                      starting.point = c(0,0))
}

## GENERATING OBSERVATIONS FROM THE DISTRIBUTION ##

n = 20000
Y = as.data.frame(matrix((NA), nrow = nv, ncol = n))
for (i in 1:nv) {
  Y[i,] <- rgl(n, lambda1= Lambday$h1[i], lambda2 = Lambday$h2[i], lambda3 = Lambday$h3[i], lambda4 = Lambday$h4[i],
               param = "fkml", lambda5 = NULL)
}

for (i in 1:nv){
  i <- as.numeric(Y[i,])
  hist(i, freq = F,  main="Histogram for student loan debt", 
       xlab="students", 
       border="black", 
       col="dark red", 
       breaks=8)
  lines(density(i), lwd = 3, col = "dark blue")
  abline(v = muy[i], col = "red", lwd = '3')
}

### Sorting Y ##
Yt <- t(Y)

## Quartiles ##
Qy <- as.data.frame(matrix(NA), nrow = 5, ncol = nv)
for (i in 1:nv) {
  for (j in 1:5)
    Qy[j,i] = quantile(Yt[,i])[j]
}
rownames(Qy) <- c("0%","25%","50%","75%","100%")
colnames(Qy) <- c("1994", "2001", "2009")

###############################################################################
############       INCOME DISTRIBUTION FOR QUARTILES          #################
###############################################################################

#################### 1) Initializing moments for quartiles
##  1st quartile momments:
mux1 = c(33200, 39300, 34400)      # MEAN
varx1 = c(1473796, 611524, 641601) # VARIANCE
skwx1 = c(8.155, 28.389, 29.925)   # SKEWNESS
kurx1 <- c(8.155*1.2, 28.389*1.2, 29.925*1.2)               # KURTOSIS

##  2nd quartile momments:
mux2 = c(33200, 39300, 34400)      # MEAN
varx2 = c(1473796, 611524, 641601) # CARIANCE
skwx2 = c(8.155, 28.389, 29.925)   # SKEWNESS
kurx2 <- c(8.155*1.2, 28.389*1.2, 29.925*1.2)               # KURTOSIS

##  3rd quartile momments:
mux3 = c(33200, 39300, 34400)      # MEAN
varx3 = c(1473796, 611524, 641601) # vARIANCE
skwx3 = c(8.155, 28.389, 29.925)   # SKEWNESS
kurx3 <- c(8.155*1.2, 28.389*1.2, 29.925*1.2)               # KURTOSIS

##  4th quartile momments:                     
mux4 = c(33200, 39300, 34400)      # MEAN
varx4 = c(1473796, 611524, 641601) # vARIANCE
skwx4 = c(8.155, 28.389, 29.925)   # SKEWNESS
kurx4 <- c(8.155*1.2, 28.389*1.2, 29.925*1.2)               # KURTOSIS

############### 2) EXTRACTING PARAMETERS for GLD FOR ALL QUARTILES
# 1st quartile
Lambdax1 <- as.data.frame(matrix((NA), nrow = 3, ncol = 4))
colnames(Lambdax1) <- c("h1", "h2", "h3", "h4") 
for (i in 1:nv) {
  Lambdax1[i,] <- fit.fkml.moments.val(moments=c(mean=mux1[i], variance=varx1[i], skewness=skwx1[i], kurtosis=kurx1[i]), optim.method="Nelder-Mead", optim.control= list(),
                                       starting.point = c(0,0))
}

# 2nd quartile
Lambdax2 <- as.data.frame(matrix((NA), nrow = nv, ncol = 4))
colnames(Lambdax2) <- c("h1", "h2", "h3", "h4") 
for (i in 1:nv) {
  Lambdax2[i,] <- fit.fkml.moments.val(moments=c(mean=mux2[i], variance=varx2[i], skewness=skwx2[i], kurtosis=kurx2[i]), optim.method="Nelder-Mead", optim.control= list(),
                                       starting.point = c(0,0))
}

# 3rd quartile
Lambdax3 <- as.data.frame(matrix((NA), nrow = 3, ncol = 4))
colnames(Lambdax3) <- c("h1", "h2", "h3", "h4") 
for (i in 1:nv) {
  Lambdax3[i,] <- fit.fkml.moments.val(moments=c(mean=mux3[i], variance=varx3[i], skewness=skwx3[i], kurtosis=kurx3[i]), optim.method="Nelder-Mead", optim.control= list(),
                                       starting.point = c(0,0))
}

# 4th quartile
Lambdax4 <- as.data.frame(matrix((NA), nrow = 3, ncol = 4))
colnames(Lambdax4) <- c("h1", "h2", "h3", "h4") 
for (i in 1:nv) {
  Lambdax4[i,] <- fit.fkml.moments.val(moments=c(mean=mux4[i], variance=varx4[i], skewness=skwx4[i], kurtosis=kurx4[i]), optim.method="Nelder-Mead", optim.control= list(),
                                       starting.point = c(0,0))
}

############ 3) GENERATING OBSERVATIONS FROM THE DISTRIBUTION OF EACH QUARTILE
# 1ST quartile
X1 = as.data.frame(matrix((NA), nrow = nv, ncol = n))
for (i in 1:nv) {
  X1[i,] <- rgl(n, lambda1= Lambdax1$h1[i], lambda2 = Lambdax1$h2[i], lambda3 = Lambdax1$h3[i], lambda4 = Lambdax1$h4[i],
                param = "fkml", lambda5 = NULL)
}

# 2ND quartile
X2 = as.data.frame(matrix((NA), nrow = nv, ncol = n))
for (i in 1:nv) {
  X2[i,] <- rgl(n, lambda1= Lambdax2$h1[i], lambda2 = Lambdax2$h2[i], lambda3 = Lambdax2$h3[i], lambda4 = Lambdax2$h4[i],
                param = "fkml", lambda5 = NULL)
}

# 3RD quartile
X3 = as.data.frame(matrix((NA), nrow = nv, ncol = n))
for (i in 1:nv) {
  X3[i,] <- rgl(n, lambda1= Lambdax3$h1[i], lambda2 = Lambdax3$h2[i], lambda3 = Lambdax3$h3[i], lambda4 = Lambdax3$h4[i],
                param = "fkml", lambda5 = NULL)
}

# 4TH quartile
X4 = as.data.frame(matrix((NA), nrow = nv, ncol = n))
for (i in 1:nv) {
  X4[i,] <- rgl(n, lambda1= Lambdax4$h1[i], lambda2 = Lambdax4$h2[i], lambda3 = Lambdax4$h3[i], lambda4 = Lambdax4$h4[i],
                param = "fkml", lambda5 = NULL)
}

########### 4) PLOTTING THE HISTOGRAM OF THE GENERATED DATA
## 1ST quartile ##
for (i in 1:nv){
  i <- as.numeric(X1[i,])
  hist(i, freq = F,  main= c("Histogram for Annual Salary", "First year after graduation"), 
       xlab="students on 1st Quartile of student loan debt", 
       border="black", 
       col="dark green", 
       breaks=8)
  lines(density(i), lwd = 3, col = "dark blue")
  abline(v = mux1[i], col = "red", lwd = '3')
}

## 2ND quartile ##
for (i in 1:nv){
  i <- as.numeric(X2[i,])
  hist(i, freq = F,  main= c("Histogram for Annual Salary", "First year after graduation"), 
       xlab="students on 2nd Quartile of student loan debt", 
       border="black", 
       col="dark green", 
       breaks=8)
  lines(density(i), lwd = 3, col = "dark blue")
  abline(v = mux2[i], col = "red", lwd = '3')
}

## 3RD Quartile ##
for (i in 1:nv){
  i <- as.numeric(X3[i,])
  hist(i, freq = F,  main= c("Histogram for Annual Salary", "First year after graduation"), 
       xlab="students on 3rd Quartile of student loan debt", 
       border="black", 
       col="dark green", 
       breaks=8)
  lines(density(i), lwd = 3, col = "dark blue")
  abline(v = mux3[i], col = "red", lwd = '3')
}

## 4TH quartile ##
for (i in 1:nv){
  i <- as.numeric(X4[i,])
  hist(i, freq = F,  main= c("Histogram for Annual Salary", "First year after graduation"), 
       xlab="students on 4th Quartile of student loan debt", 
       border="black", 
       col="dark green", 
       breaks=8)
  lines(density(i), lwd = 3, col = "dark blue")
  abline(v = mux4[i], col = "red", lwd = '3')
}

#### Joint distributions of Loan debt and 1st year after graduation salary ####
n1 = 5518	
n2 = 7385
n3 = 11257

## Loan sampling ##
SLD_data1 <- as.data.frame(matrix((NA), nrow = n1, ncol = nv))
colnames(SLD_data1) <- c("Loan", "Quartile","Income")
SLD_data1[,1] <- rgl(n1, lambda1= Lambday$h1[1], lambda2 = Lambday$h2[1], lambda3 = Lambday$h3[1], lambda4 = Lambday$h4[1],
                     param = "fkml", lambda5 = NULL)

SLD_data2 <- as.data.frame(matrix((NA), nrow = n2, ncol = nv))
colnames(SLD_data2) <- c("Loan", "Quartile","Income")
SLD_data2[,1] <- rgl(n2, lambda1= Lambday$h1[2], lambda2 = Lambday$h2[2], lambda3 = Lambday$h3[2], lambda4 = Lambday$h4[2],
                     param = "fkml", lambda5 = NULL)

SLD_data3 <- as.data.frame(matrix((NA), nrow = n3, ncol = nv))
colnames(SLD_data3) <- c("Loan", "Quartile","Income")
SLD_data3[,1] <- rgl(n3, lambda1= Lambday$h1[3], lambda2 = Lambday$h2[3], lambda3 = Lambday$h3[3], lambda4 = Lambday$h4[3],
                     param = "fkml", lambda5 = NULL)

### Quartiles ###

## 1994 Data ##
for (i in 1:n1) {
  if (SLD_data1$Loan[i] < quantile(SLD_data1$Loan)[2]){
    SLD_data1$Quartile[i] = 1
  } else {
    if (SLD_data1$Loan[i] < quantile(SLD_data1$Loan)[3]){
      SLD_data1$Quartile[i] = 2
    } else {
      if (SLD_data1$Loan[i] < quantile(SLD_data1$Loan)[4]){
        SLD_data1$Quartile[i] = 3
      } else {
        SLD_data1$Quartile[i] = 4
      }}}}


## 2001 Data ##
for (i in 1:n2) {
  if (SLD_data2$Loan[i] < quantile(SLD_data2$Loan)[2]){
    SLD_data2$Quartile[i] = 1
  } else {
    if (SLD_data2$Loan[i] < quantile(SLD_data2$Loan)[3]){
      SLD_data2$Quartile[i] = 2
    } else {
      if (SLD_data2$Loan[i] < quantile(SLD_data2$Loan)[4]){
        SLD_data2$Quartile[i] = 3
      } else {
        SLD_data2$Quartile[i] = 4
      }}}}

## 2009 Data ##
for (i in 1:n3) {
  if (SLD_data3$Loan[i] < quantile(SLD_data3$Loan)[2]){
    SLD_data3$Quartile[i] = 1
  } else {
    if (SLD_data3$Loan[i] < quantile(SLD_data3$Loan)[3]){
      SLD_data3$Quartile[i] = 2
    } else {
      if (SLD_data3$Loan[i] < quantile(SLD_data3$Loan)[4]){
        SLD_data3$Quartile[i] = 3
      } else {
        SLD_data3$Quartile[i] = 4
      }}}}


### Income after 1st year of graduation ###

## 1994 Data ##
for (i in 1:n1) {
  if (SLD_data1$Quartile[i] == 1){
    SLD_data1$Income[i] = rgl(1, lambda1= Lambdax1$h1[1], lambda2 = Lambdax1$h2[1], lambda3 = Lambdax1$h3[1], lambda4 = Lambdax1$h4[1],
                              param = "fkml", lambda5 = NULL)
  } else {
    if (SLD_data1$Quartile[i] == 2){
      SLD_data1$Income[i] = rgl(1, lambda1= Lambdax2$h1[1], lambda2 = Lambdax2$h2[1], lambda3 = Lambdax2$h3[1], lambda4 = Lambdax2$h4[1],
                                param = "fkml", lambda5 = NULL)
    } else {
      if (SLD_data1$Quartile[i] == 3){
        SLD_data1$Income[i] = rgl(1, lambda1= Lambdax3$h1[1], lambda2 = Lambdax3$h2[1], lambda3 = Lambdax3$h3[1], lambda4 = Lambdax3$h4[1],
                                  param = "fkml", lambda5 = NULL)
      } else {
        SLD_data1$Income[i] = rgl(1, lambda1= Lambdax4$h1[1], lambda2 = Lambdax4$h2[1], lambda3 = Lambdax4$h3[1], lambda4 = Lambdax4$h4[1],
                                  param = "fkml", lambda5 = NULL)
      }}}}

## 2001 Data ##
for (i in 1:n2) {
  if (SLD_data2$Quartile[i] == 1){
    SLD_data2$Income[i] = rgl(1, lambda1= Lambdax1$h1[2], lambda2 = Lambdax1$h2[2], lambda3 = Lambdax1$h3[2], lambda4 = Lambdax1$h4[2],
                              param = "fkml", lambda5 = NULL)
  } else {
    if (SLD_data2$Quartile[i] == 2){
      SLD_data2$Income[i] = rgl(1, lambda1= Lambdax2$h1[2], lambda2 = Lambdax2$h2[2], lambda3 = Lambdax2$h3[2], lambda4 = Lambdax2$h4[2],
                                param = "fkml", lambda5 = NULL)
    } else {
      if (SLD_data2$Quartile[i] == 3){
        SLD_data2$Income[i] = rgl(1, lambda1= Lambdax3$h1[2], lambda2 = Lambdax3$h2[2], lambda3 = Lambdax3$h3[2], lambda4 = Lambdax3$h4[2],
                                  param = "fkml", lambda5 = NULL)
      } else {
        SLD_data2$Income[i] = rgl(1, lambda1= Lambdax4$h1[2], lambda2 = Lambdax4$h2[2], lambda3 = Lambdax4$h3[2], lambda4 = Lambdax4$h4[2],
                                  param = "fkml", lambda5 = NULL)
      }}}}

## 2009 Data ##
for (i in 1:n3) {
  if (SLD_data3$Quartile[i] == 1){
    SLD_data3$Income[i] = rgl(1, lambda1= Lambdax1$h1[3], lambda2 = Lambdax1$h2[3], lambda3 = Lambdax1$h3[3], lambda4 = Lambdax1$h4[3],
                              param = "fkml", lambda5 = NULL)
  } else {
    if (SLD_data3$Quartile[i] == 2){
      SLD_data3$Income[i] = rgl(1, lambda1= Lambdax2$h1[3], lambda2 = Lambdax2$h2[3], lambda3 = Lambdax2$h3[3], lambda4 = Lambdax2$h4[3],
                                param = "fkml", lambda5 = NULL)
    } else {
      if (SLD_data3$Quartile[i] == 3){
        SLD_data3$Income[i] = rgl(1, lambda1= Lambdax3$h1[3], lambda2 = Lambdax3$h2[3], lambda3 = Lambdax3$h3[3], lambda4 = Lambdax3$h4[3],
                                  param = "fkml", lambda5 = NULL)
      } else {
        SLD_data3$Income[i] = rgl(1, lambda1= Lambdax4$h1[3], lambda2 = Lambdax4$h2[3], lambda3 = Lambdax4$h3[3], lambda4 = Lambdax4$h4[3],
                                  param = "fkml", lambda5 = NULL)
      }}}}


## REORDERING COLUMNS ##
SLD_data1 <- SLD_data1[,c("Quartile","Loan","Income")]
SLD_data2 <- SLD_data2[,c("Quartile","Loan","Income")]
SLD_data3 <- SLD_data3[,c("Quartile","Loan","Income")]

scatter.smooth(SLD_data1$Loan, SLD_data1$Income, xlab = "Loan amount", ylab = "Income", main = "Income vs Student Loan 1994")
scatter.smooth(SLD_data2$Loan, SLD_data2$Income, xlab = "Loan amount", ylab = "Income", main = "Income vs Student Loan 2001")
scatter.smooth(SLD_data3$Loan, SLD_data3$Income, xlab = "Loan amount", ylab = "Income", main = "Income vs Student Loan 2009")

plot(SLD_data1$Loan, SLD_data1$Income)
plot(SLD_data2$Loan, SLD_data2$Income)
plot(SLD_data3$Loan, SLD_data3$Income)

plot(SLD_data1$Income, SLD_data1$Loan)
plot(SLD_data2$Income, SLD_data2$Loan)
plot(SLD_data3$Income, SLD_data3$Loan)

## Subsetting Data ## 

SubSLD_data1 = SLD_data1[sample(nrow(SLD_data1), replace = F, size = 500),
                         ]

SubSLD_data2 = SLD_data2[sample(nrow(SLD_data2), replace = F, size = 500),
                         ]

SubSLD_data3 = SLD_data3[sample(nrow(SLD_data3), replace = F, size = 500),
                         ]

plot(SubSLD_data1$Income, SubSLD_data1$Loan)
plot(SubSLD_data2$Income, SubSLD_data2$Loan)
plot(SubSLD_data3$Income, SubSLD_data3$Loan)


## Merging and Exporting Data ##

SubSLD_data1$ID = seq.int(nrow(SubSLD_data1))
SubSLD_data2$ID = seq.int(nrow(SubSLD_data2))
SubSLD_data3$ID = seq.int(nrow(SubSLD_data3))

SubSLD_data = merge(SubSLD_data1, SubSLD_data2, by = "ID")
SubSLD_data = merge(SubSLD_data, SubSLD_data3, by = "ID")

write.csv(SubSLD_data, "SubSLD_data.csv")

