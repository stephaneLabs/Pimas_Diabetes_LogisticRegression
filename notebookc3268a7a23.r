{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "433ad32b",
   "metadata": {
    "_execution_state": "idle",
    "_uuid": "051d70d956493feee0c6d64651c6a088724dca2a",
    "papermill": {
     "duration": 0.003289,
     "end_time": "2023-02-15T09:18:31.815390",
     "exception": false,
     "start_time": "2023-02-15T09:18:31.812101",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": []
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "c1e05ea1",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-02-15T09:18:31.825405Z",
     "iopub.status.busy": "2023-02-15T09:18:31.822425Z",
     "iopub.status.idle": "2023-02-15T09:18:31.976549Z",
     "shell.execute_reply": "2023-02-15T09:18:31.973787Z"
    },
    "papermill": {
     "duration": 0.162717,
     "end_time": "2023-02-15T09:18:31.980367",
     "exception": false,
     "start_time": "2023-02-15T09:18:31.817650",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Pima Indians Diabetes Database Analysis with Logistic Regression\" author : \"Stéphane Lassalvy 2023\"\n",
    "# Script to apply logistic regression to Pima's diabetes data here at github, url  :\n",
    "# https://github.com/stephaneLabs/LogisticRegression"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "ef0875a8",
   "metadata": {
    "papermill": {
     "duration": 0.002042,
     "end_time": "2023-02-15T09:18:31.984580",
     "exception": false,
     "start_time": "2023-02-15T09:18:31.982538",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "---\n",
    "title : \"Pima Indians Diabetes Database Analysis with Logistic Regression\"\n",
    "author : \"Stéphane Lassalvy 2023\"\n",
    "---\n",
    "\n",
    "# References\n",
    "Antoniadis, A., Berruyer, J., & Carmona, R. (1992). Régression non linéaire et applications. Economica.\n",
    "\n",
    "Smith, J.W., Everhart, J.E., Dickson, W.C., Knowler, W.C., & Johannes, R.S. (1988). Using the ADAP learning algorithm to forecast the onset of diabetes mellitus. In Proceedings of the Symposium on Computer Applications and Medical Care (pp. 261--265). IEEE Computer Society Press.\n",
    "https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database\n",
    "\n",
    "<!-- #' Logit regression of diabete data -->\n",
    "<!-- #' -->\n",
    "<!-- #' Copyright Stéphane Lassalvy 2023 -->\n",
    "<!-- #'  -->\n",
    "<!-- #' This R code in under GPL-3 Licence -->\n",
    "<!-- #'  -->\n",
    "<!-- #' Disclaimer of Warranty : -->\n",
    "<!-- #' THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  -->\n",
    "<!-- #' EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES -->\n",
    "<!-- #' PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, -->\n",
    "<!-- #' INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS -->\n",
    "<!-- #' FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. -->\n",
    "<!-- #' SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, -->\n",
    "<!-- #' REPAIR OR CORRECTION. -->\n",
    "<!-- #'  -->\n",
    "<!-- #' Diabete data are available on Kaggle under licence CC0: -->\n",
    "<!-- #' License : CC0: Public Domain. Smith, J.W., Everhart, J.E., Dickson, W.C., Knowler, W.C., & Johannes, R.S. (1988). -->\n",
    "<!-- #' Using the ADAP learning algorithm to forecast the onset of diabetes mellitus. In Proceedings of the Symposium on -->\n",
    "<!-- #' Computer Applications and Medical Care (pp. 261--265). IEEE Computer Society Press -->\n",
    "<!-- #' https://www.kaggle.com/datasets/whenamancodes/predict-diabities -->\n",
    "<!-- #'  -->\n",
    "\n",
    "```{r}\n",
    "library(knitr)\n",
    "```\n",
    "\n",
    "knitr::opts_chunk$set(message = FALSE, warning = FALSE, fig.width = 9, fig.height  = 9)\n",
    "\n",
    "```{r}\n",
    "library(devtools)\n",
    "library(rmarkdown)\n",
    "library(tidyverse)\n",
    "library(FactoMineR)\n",
    "library(missMDA)\n",
    "library(InformationValue)\n",
    "library(ISLR)\n",
    "library(caret)\n",
    "```\n",
    "\n",
    "# Context\n",
    "This dataset is originally from the National Institute of Diabetes and Digestive and Kidney Diseases. The objective of the dataset is to diagnostically predict whether or not a patient has diabetes, based on certain diagnostic measurements included in the dataset. Several constraints were placed on the selection of these instances from a larger database. In particular, all patients here are females at least 21 years old of Pima Indian heritage. (text from Kaggle, https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database)\n",
    "\n",
    "# Content\n",
    "The datasets consists of several medical predictor variables and one target variable, Outcome. Predictor variables includes the number of pregnancies the patient has had, their BMI, insulin level, age, and so on.\n",
    "\n",
    "The datasets consists of several medical predictor variables and one target variable, Outcome. Predictor variables includes the number of pregnancies the patient has had, their BMI, insulin level, age, and so on. (text from Kaggle, https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database)\n",
    "\n",
    "```{r}\n",
    "# Read the dataset\n",
    "df <- read.csv(\"~/Documents/Info_Stats/R/Kaggle_Diabete/diabetes.csv\")\n",
    "df <- as_tibble(df)\n",
    "dim(df)\n",
    "```\n",
    "\n",
    "This work is based on a set of R functions especially built to fit and assess a logistic regression model. The response variable is the variable Outcome which is binary. The predictors are quantitative.\n",
    "```{r}\n",
    "# Source the R addons That I have coded for the logistic regression under R\n",
    "# devtools::source_url(\"https://github.com/stephaneLabs/Logistic_Addons/logisticRegressionAddons_20230209.R\")\n",
    "source(\"~/Documents/Info_Stats/R/Kaggle_Diabete/logisticRegressionAddons_20230215.R\")\n",
    "```\n",
    "\n",
    "```{r formatting data}\n",
    "# Quick format of the data\n",
    "df <- df %>% mutate(Pregnancies      = Pregnancies %>% as.numeric(),\n",
    "                    Glucose          = Glucose %>% as.numeric(),\n",
    "                    SkinThickness    = SkinThickness %>% as.numeric(),\n",
    "                    Insulin          = Insulin %>% as.numeric(),\n",
    "                    BMI              = BMI %>% as.numeric(),\n",
    "                    DiabetesPedigreeFunction = DiabetesPedigreeFunction %>% as.numeric(),\n",
    "                    Age              = Age %>% as.numeric(),\n",
    "                    Outcome = Outcome %>% as.factor())\n",
    "```\n",
    "\n",
    "# Data exploration : descriptive statistics of the continuous predictors\n",
    "## Pregnancies\n",
    "```{r}\n",
    "quantitativeVariableDescription(df = df, variableName = \"Pregnancies\")\n",
    "```\n",
    "\n",
    "## Glucose\n",
    "```{r}\n",
    "# Glucose, seems a little O inflated and 0 is an outlier, 0 glucose in blood seems odd to me, put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"Glucose\")\n",
    "```\n",
    "\n",
    "## Blood pressure\n",
    "```{r}\n",
    "# Blood pressure, put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"BloodPressure\")\n",
    "```\n",
    "\n",
    "## SkinThickness\n",
    "```{r}\n",
    "# SkinThickness, very 0 inflated, 0 for skin thickness seems odd too, put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"SkinThickness\")\n",
    "```\n",
    "\n",
    "## Insulin\n",
    "```{r}\n",
    "# Insulin, a little 0 inflated, 0 for Insulin seems a little odd to me, put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"Insulin\")\n",
    "```\n",
    "\n",
    "## BMI\n",
    "```{r}\n",
    "# BMI, 0 is very strange a BMI of 0 would imply a weight of 0 for the individual, put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"BMI\")\n",
    "```\n",
    "\n",
    "## DiabetesPedigreeFunction\n",
    "```{r}\n",
    "# DiabetesPedigreeFunction, seems OK\n",
    "quantitativeVariableDescription(df = df, variableName = \"DiabetesPedigreeFunction\")\n",
    "```\n",
    "\n",
    "## Age\n",
    "```{r}\n",
    "# Age, seems OK\n",
    "quantitativeVariableDescription(df = df, variableName = \"Age\")\n",
    "```\n",
    "\n",
    "# Pairs plot of the predictors\n",
    "```{r}\n",
    "# Strange paterns wich make think that 0 are NA for some variables\n",
    "pairs(df[,1:8])\n",
    "```\n",
    "\n",
    "\n",
    "The different univariate analyses show the histogram of each predictor, the corresponding kernel density estimator, skewness, kurtosis and the distribution of a Gaussian distribution having for mean the sample mean and for standard deviation the sample standard deviation.\n",
    "\n",
    "Some variables appears to be zero inflated. For one having no human biology notions it is difficult to determine if those 0 values are consistent with reality or are artefacts. However some good sense can be helpful : a blood sugar equal to zero sounds strange as well as an insulin rate equal to zero. A blood pressure equal to 0 seems not possible as a BMI equal to zero would mean a weight of zero for the individual, which is erratic. For skinthickness the 0 values seem very detached of the whole distribution, and considering the range of values, having a skin thickness of 0 seems very improbable. \n",
    "\n",
    "Moreover the pairs plot shows patterns which seems to indicate that those 0 are really odd.\n",
    "\n",
    "Then for Glucose, Insulin, SkinThickness ans BMI, the 0 values are replaced by missing values.\n",
    "\n",
    "\n",
    "```{r}\n",
    "# Replacing problematic zeros by NAs\n",
    "df$Glucose[df$Glucose==0]             <- NA\n",
    "df$BloodPressure[df$BloodPressure==0] <- NA\n",
    "df$SkinThickness[df$SkinThickness==0] <- NA\n",
    "df$Insulin[df$Insulin == 0]           <- NA\n",
    "df$BMI[df$BMI==0]                     <- NA\n",
    "```\n",
    "\n",
    "# Re-plotting the modified variables\n",
    "## Glucose\n",
    "```{r}\n",
    "# Glucose, seems a little O inflated and 0 is an outlier, 0 glucose in blood seems odd to me, put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"Glucose\")\n",
    "```\n",
    "\n",
    "## Blood pressure\n",
    "```{r}\n",
    "# Blood pressure, put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"BloodPressure\")\n",
    "```\n",
    "\n",
    "## SkinThickness\n",
    "```{r}\n",
    "# SkinThickness, very 0 inflated, 0 for skin thickness seems odd too, put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"SkinThickness\")\n",
    "```\n",
    "\n",
    "## Insulin\n",
    "```{r}\n",
    "# Insulin, a little 0 inflated, 0 for Insulin seems a little odd to me, put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"Insulin\")\n",
    "```\n",
    "\n",
    "## BMI\n",
    "```{r}\n",
    "# BMI, 0 is very strange a BMI of 0 would imply a weight of 0 for the individual, , put 0 to NA\n",
    "quantitativeVariableDescription(df = df, variableName = \"BMI\")\n",
    "```\n",
    "\n",
    "After having changed the 0 by NA, the distributions of Glucose, SkinThickness ans BMI are closer to a normal distribution. It is not the case for Insulin but it does not bother me to keep it like this.\n",
    "\n",
    "\n",
    "# PCA of the predictors\n",
    "\n",
    "The following shows the PCA of the predictor variables, the missing values are replaced by the mean of the available values for the variable. This step is mostly performed to see if there is colinearity in this set of variables, which is the case.\n",
    "\n",
    "```{r}\n",
    "# PCA of data, NA are replaced by the mean of the variable\n",
    "# PCA replace missing values by the mean of the variable, some variable are highly correlated (colinearity problems ?)\n",
    "df_PCA <- PCA(X = df, scale.unit = TRUE, ncp = 8, quali.sup = 9, graph = FALSE)\n",
    "\n",
    "# 6 components explains 89% of the data\n",
    "barplot(df_PCA$eig[,2])\n",
    "\n",
    "kable(df_PCA$eig)\n",
    "\n",
    "# Discrimination of the 2 diagnostics are not very good in the 1st plane of the PCA\n",
    "plot(df_PCA,axes = c(1,2), choix = \"var\")\n",
    "plot(df_PCA,axes = c(1,2), choix = \"ind\", habillage = 9)\n",
    "# 5 axes explain 82% of the inertia\n",
    "```\n",
    "\n",
    "As we can see, five axes explains 82% of the variability of the data. Pregnancies and Age are highly correlated, and a symetrical direction (with respect to the horizontal axis) is given by Skinthickness and BMI which are very correlated too.\n",
    "\n",
    "# Imputing missing data\n",
    "\n",
    "To get a better imputation of missing data, we take advantage here of the missMDA R packages, choosing an imputation method based on PCA and choosing 5  (we saw in the previous section 5 axes explain 82% of the data) as the number of components to be used for the data reconstruction.\n",
    "\n",
    "```{r}\n",
    "# summary(df$Outcome)\n",
    "# \n",
    "# estim_ncpPCA(df, ncp.max = 9, scale = FALSE, quali.sup = 9)\n",
    "# Impute missing values with a better method following a PCA model\n",
    "df_Imputation <- imputePCA(df, quali.sup = 9, ncp = 5, maxiter = 5000, scale = FALSE)\n",
    "df_Complete <- df_Imputation$completeObs\n",
    "df_Complete <- droplevels(df_Complete)\n",
    "```\n",
    "# Checking the linearity of the relationship between odds and the quantitative predictors\n",
    "\n",
    "We check here the relationship between the log odds of the diabetes and the predictors. A linear relationship has to be observed to use the predictor as quantitative. If the relationship is not quantitative a transformation or a transformation into factor has to be done.\n",
    "\n",
    "To get the values for the data of our plot, groups are done with a discretization function and the means of the groups are plotted to see is we get a linear shape. The method used for discretization is the \"cluster\" option of the function \"discretize\" of the \"arules\" package. This method is based on k-means clustering.\n",
    "\n",
    "## Pregnancies\n",
    "```{r}\n",
    "# description between the log(odds) and the quantitative predictors (should be linear)\n",
    "logOddsVsQuantitativePredictor(df = df_Complete, binaryResponse = \"Outcome\", method = \"cluster\", breaks = 10, quantitativePredictor = \"Pregnancies\")\n",
    "```\n",
    "\n",
    "## Glucose\n",
    "```{r}\n",
    "logOddsVsQuantitativePredictor(df = df_Complete, binaryResponse = \"Outcome\", method = \"cluster\", breaks = 10, quantitativePredictor = \"Glucose\")\n",
    "```\n",
    "\n",
    "## Blood pressure\n",
    "```{r}\n",
    "logOddsVsQuantitativePredictor(df = df_Complete, binaryResponse = \"Outcome\", method = \"cluster\", breaks = 10, quantitativePredictor = \"BloodPressure\")\n",
    "```\n",
    "\n",
    "## SkinThickness\n",
    "```{r}\n",
    "logOddsVsQuantitativePredictor(df = df_Complete, binaryResponse = \"Outcome\", method = \"cluster\", breaks = 10, quantitativePredictor = \"SkinThickness\")\n",
    "```\n",
    "\n",
    "## Insulin\n",
    "```{r}\n",
    "logOddsVsQuantitativePredictor(df = df_Complete, binaryResponse = \"Outcome\", method = \"cluster\", breaks = 10, quantitativePredictor = \"Insulin\")\n",
    "```\n",
    "\n",
    "## BMI\n",
    "```{r}\n",
    "logOddsVsQuantitativePredictor(df = df_Complete, binaryResponse = \"Outcome\", method = \"cluster\", breaks = 10, quantitativePredictor = \"BMI\")\n",
    "```\n",
    "\n",
    "## DiabetesPedigreeFunction\n",
    "```{r}\n",
    "logOddsVsQuantitativePredictor(df = df_Complete, binaryResponse = \"Outcome\", digits = 1, quantitativePredictor = \"DiabetesPedigreeFunction\")\n",
    "```\n",
    "\n",
    "## Age\n",
    "```{r}\n",
    "logOddsVsQuantitativePredictor(df = df_Complete, binaryResponse = \"Outcome\", digits = 1, quantitativePredictor = \"Age\")\n",
    "```\n",
    "\n",
    "# Discretization for problematic variables\n",
    "\n",
    "## Insulin\n",
    "```{r}\n",
    "# For insulin the relationship is not so good, we choose do discretize this variable\n",
    "df_Complete <- df_Complete %>% mutate(Insulin_grouped = as.factor(discretize(Insulin, method = \"frequency\", breaks = 3)))\n",
    "attr(df_Complete$Insulin_grouped, \"discretized:breaks\") <- NULL\n",
    "attr(df_Complete$Insulin_grouped, \"discretized:method\") <- NULL\n",
    "Insulin_groupedFreq <- binaryResponseVSCategoricalPredictor(df = df_Complete, binaryResponse = \"Outcome\",                                                                                                                       categoricalPredictor = \"Insulin_grouped\")\n",
    "# Frequencies\n",
    "kable(Insulin_groupedFreq$frequencies)\n",
    "# Proportions\n",
    "kable(Insulin_groupedFreq$proportions)\n",
    "# Chi2 test of independence\n",
    "print(Insulin_groupedFreq$independanceChi2)\n",
    "# Proportions conditioned by outcome\n",
    "kable(Insulin_groupedFreq$ConditionnalProportions1)\n",
    "# Proportions conditioned by predictor\n",
    "kable(Insulin_groupedFreq$ConditionnalProportions2)\n",
    "# seems to have a slightly influence on the outcome\n",
    "```\n",
    "\n",
    "## DiabetesPedigreeFunction\n",
    "```{r}\n",
    "# DiabetesPedigreeFunction discretized too\n",
    "df_Complete <- df_Complete %>% mutate(DiabetesPedigreeFunction_grouped = as.factor(discretize(DiabetesPedigreeFunction, method = \"frequency\", breaks = 3)))\n",
    "attr(df_Complete$DiabetesPedigreeFunction_grouped, \"discretized:breaks\") <- NULL\n",
    "attr(df_Complete$DiabetesPedigreeFunction_grouped, \"discretized:method\") <- NULL\n",
    "DiabetesPedigreeFunction_groupedFreq <- binaryResponseVSCategoricalPredictor(df = df_Complete, binaryResponse = \"Outcome\",                                                                                                                       categoricalPredictor = \"DiabetesPedigreeFunction_grouped\")\n",
    "# Frequencies\n",
    "kable(DiabetesPedigreeFunction_groupedFreq$frequencies)\n",
    "# Proportions\n",
    "kable(DiabetesPedigreeFunction_groupedFreq$proportions)\n",
    "# Chi2 test of independence\n",
    "print(DiabetesPedigreeFunction_groupedFreq$independanceChi2)\n",
    "# Proportions conditioned by outcome\n",
    "kable(DiabetesPedigreeFunction_groupedFreq$ConditionnalProportions1)\n",
    "# Proportions conditioned by predictor\n",
    "kable(DiabetesPedigreeFunction_groupedFreq$ConditionnalProportions2)\n",
    "\n",
    "```\n",
    "\n",
    "```{r}\n",
    "# Age discretized too\n",
    "df_Complete <- df_Complete %>% mutate(Age_grouped = as.factor(discretize(Age, method = \"frequency\", breaks = 3)))\n",
    "attr(df_Complete$Age_grouped, \"discretized:breaks\") <- NULL\n",
    "attr(df_Complete$Age_grouped, \"discretized:method\") <- NULL\n",
    "Age_groupedFreq <- binaryResponseVSCategoricalPredictor(df = df_Complete, binaryResponse = \"Outcome\",\n",
    "                                                        categoricalPredictor = \"Age_grouped\")\n",
    "# Frequencies\n",
    "kable(Age_groupedFreq$frequencies)\n",
    "# Proportions\n",
    "kable(Age_groupedFreq$proportions)\n",
    "# Chi2 test of independence\n",
    "print(Age_groupedFreq$independanceChi2)\n",
    "# Proportions conditioned by outcome\n",
    "kable(Age_groupedFreq$ConditionnalProportions1)\n",
    "# Proportions conditioned by predictor\n",
    "kable(Age_groupedFreq$ConditionnalProportions2)\n",
    "```\n",
    "\n",
    "# Splitting the data into a training and a testing set\n",
    "```{r}\n",
    "#make this example reproducible\n",
    "set.seed(1)\n",
    "\n",
    "#Use 70% of dataset as training set and remaining 30% as testing set\n",
    "sample_train   <- sample(c(TRUE, FALSE), nrow(df_Complete), replace = TRUE, prob = c(0.7,0.3))\n",
    "df_train       <- df_Complete[sample_train, ]\n",
    "df_test        <- df_Complete[!sample_train, ]\n",
    "```\n",
    "\n",
    "# Fitting the null model\n",
    "```{r}\n",
    "# Null model\n",
    "m0 <- glm(Outcome ~ 1, family=binomial(link = logit),\n",
    "          data = df_train)\n",
    "AIC(m0)\n",
    "```\n",
    "\n",
    "# Fitting the initial model\n",
    "```{r}\n",
    "# Initial model\n",
    "m1 <- glm(Outcome ~ Pregnancies + Glucose + BloodPressure + SkinThickness + Insulin_grouped + BMI + DiabetesPedigreeFunction_grouped + Age_grouped,\n",
    "          family = binomial(link = logit), data = df_train)\n",
    "```\n",
    "\n",
    "## Variance inflation factor (VIF)\n",
    "```{r}\n",
    "VIFTable <- plotVIF(m1)\n",
    "kable(VIFTable)\n",
    "```\n",
    "\n",
    "Some collinearity is detected with a VIF value close to 2.5 for BMI.\n",
    "\n",
    "## Deviance table\n",
    "```{r}\n",
    "anova(m1, test = \"Chisq\")\n",
    "```\n",
    "\n",
    "Blood pressure has a p-value of 0.36 which suggest to remove it from the model.\n",
    "\n",
    "## AIC Value\n",
    "```{r}\n",
    "AIC(m1)\n",
    "```\n",
    "\n",
    "## R2 values\n",
    "```{r}\n",
    "print(computeR2s(m1, m0))\n",
    "```\n",
    "\n",
    "## Area under the ROC curve\n",
    "```{r}\n",
    "Cstat(m1)\n",
    "```\n",
    "\n",
    "## Hosmer and Lemeshow goodness of fit test\n",
    "```{r}\n",
    "HoslemTest(m1)\n",
    "```\n",
    "\n",
    "## Residual plots\n",
    "```{r}\n",
    "residualPlots(m1, binaryresponse = \"Outcome\")\n",
    "```\n",
    "\n",
    " \n",
    "# Backward elimination\n",
    "Backward elimination is seen as the less bad method for variable selection so let us try it.\n",
    "\n",
    "```{r}\n",
    "m <- m1\n",
    "m <- update(m, . ~ . - BloodPressure)\n",
    "```\n",
    "\n",
    "## Variance inflation factor (VIF)\n",
    "```{r}\n",
    "plotVIF(m)\n",
    "```\n",
    "\n",
    "## Deviance table\n",
    "```{r}\n",
    "anova(m, test = \"Chisq\")\n",
    "```\n",
    "\n",
    "## AIC Value\n",
    "```{r}\n",
    "AIC(m)\n",
    "```\n",
    "\n",
    "## R2 values\n",
    "```{r}\n",
    "print(computeR2s(m, m0))\n",
    "```\n",
    "\n",
    "## Area under the ROC curve\n",
    "```{r}\n",
    "Cstat(m)\n",
    "```\n",
    "\n",
    "## Hosmer and Lemeshow goodness of fit test\n",
    "```{r}\n",
    "HoslemTest(m)\n",
    "```\n",
    "\n",
    "## Residual plots\n",
    "```{r}\n",
    "residualPlots(m, binaryresponse = \"Outcome\")\n",
    "```\n",
    "\n",
    "## Removing DiabetesPedigreeFunction_grouped\n",
    "```{r}\n",
    "m <- update(m, . ~ . - DiabetesPedigreeFunction_grouped)\n",
    "```\n",
    "\n",
    "## Variance inflation factor (VIF)\n",
    "```{r}\n",
    "plotVIF(m)\n",
    "```\n",
    "\n",
    "## Deviance table\n",
    "```{r}\n",
    "anova(m, test = \"Chisq\")\n",
    "```\n",
    "\n",
    "## AIC Value\n",
    "```{r}\n",
    "AIC(m)\n",
    "```\n",
    "\n",
    "## R2 values\n",
    "```{r}\n",
    "print(computeR2s(m, m0))\n",
    "```\n",
    "\n",
    "## Area under the ROC curve\n",
    "```{r}\n",
    "Cstat(m)\n",
    "```\n",
    "\n",
    "## Hosmer and Lemeshow goodness of fit test\n",
    "```{r}\n",
    "HoslemTest(m)\n",
    "```\n",
    "\n",
    "## Residual plots\n",
    "```{r}\n",
    "residualPlots(m, binaryresponse = \"Outcome\")\n",
    "```\n",
    "\n",
    "The deviance table suggests to discard DiabetesPedigreeFunction_grouped but AIC disagree and the Cstats function is a little less than in the initial model. This suggest that there is not a great gain in suppressing the DiabetesPedigreeFunction_grouped factor from the model. The backward selection ends here. We keep all the variable of our initial model.\n",
    "\n",
    "# Interpretting the Odds ratios\n",
    "\n",
    "## Exponentiation of the estimated coefficients of the confidence intervals\n",
    "```{r}\n",
    "oddsRatios   <- exp(coef(m))\n",
    "oddsRatios   <- data.frame(oddsRatios = oddsRatios) %>% rownames_to_column(var = \"rowname\")\n",
    "oddsRatiosCI <- as.data.frame(exp(confint(m))) %>% rownames_to_column(var = \"rowname\")\n",
    "oddsRatios   <- full_join(oddsRatios, oddsRatiosCI)\n",
    "kable(oddsRatios)\n",
    "```\n",
    "Odds of getting diabetes are increasing with 14.4% per unit of pregnancies, 3.6% per unit of glucose, 10.5% per unit of BMI, 103.0% when age is in [25,36) and 133.6% when age is in [36,81] which seems huge.\n",
    "\n",
    "# Roc curves for the training and the testing sets\n",
    "```{r}\n",
    "m_train <- m1\n",
    "\n",
    "observations_train  <- df_train$Outcome\n",
    "predictedProb_train <- predict(m_train, type = \"response\")\n",
    "\n",
    "rocCurve(m_train, testDf = df_test)\n",
    "```\n",
    "\n",
    "\n",
    "\n"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 4.439624,
   "end_time": "2023-02-15T09:18:32.111444",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2023-02-15T09:18:27.671820",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
