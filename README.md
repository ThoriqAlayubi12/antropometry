# Antropometry Calculation

The anthro package allows you to perform comprehensive analysis of anthropometric survey data based on the method developed by the Department of Nutrition for Health and Development at the World Health Organization.

The package is modeled after the original R macros provided by WHO. In addition to z-scores, the package adds more accurate calculations of confidence intervals and standard errors around the prevalence estimates, taking into account complex sample designs, whenever is the case by using the survey package.

## activate the packages

```{r,echo=TRUE}
library(anthro)
library(readxl)
library(writexl)
```

## import the database

```{r,echo=TRUE}
lokasi <- "C:/Users/almo/Dropbox/portofolio/Antropometri"
dataa <- "data dummy"
```

for ensure the directory is right, set the directory with 'setwd' instruction

```{r,echo=TRUE}
setwd(lokasi)
```

import the file

```{r,echo=TRUE}
malming <- read_xlsx(paste(dataa,".xlsx",sep = ""))
```

inspect the row data

```{r}
data.table::data.table(malming)
```
or

```{r}
View(malming)
```

## create or recode sex variable

the sex variables in this package must set as "M" for males and "F" for female

```{r,echo=TRUE}
malming$sex_new <- ifelse(malming$sex==1,"M","F")
```

## calculate the anthropometry score for nutrition status

at this file, age is in a year format, so the "is_age_in_month" must be filled with "FALSE". if your dataset have a age data with month format, "is_age_in_month" is equal TRUE

```{r}
hasil <- anthro_zscores(sex = malming$sex_new,age =malming$age_in_month,
                        is_age_in_month = TRUE,weight = malming$weight,
                        lenhei = malming$height)
```

## the result

```{r}
data.table::data.table(hasil)
```
or
```{r}
View(malming)
```

A data.frame with three types of columns. Columns starting with a "c" are cleaned versions of the input arguments. Columns beginning with a "z" are the respective z-scores and columns prefixed by a "f" indicate if these z-scores are flagged (integers). The number of rows is given by the length of the input arguments.

The following columns are returned:

1. clenhei converted length/height for deriving z-score
2. cbmi BMI value based on length/height given by clenhei
3. zlen Length/Height-for-age z-score
4. flen 1, if abs(zlen) > 6
5. zwei Weight-for-age z-score
6. fwei 1, if zwei < -6 or zwei > 5
7. zwfl Weight-for-length/height z-score
8. fwfl 1, if abs(zwfl) > 5
9. zbmi BMI-for-age z-score
10. fbmi 1, if abs(zbmi) > 5
11. zhc Head circumference-for-age z-score
12. fhc 1, if abs(zhc) > 5
13. zac Arm circumference-for-age z-score
14. fac 1, if abs(zac) > 5
15. zts Triceps skinfold-for-age z-score
16. fts 1, if abs(zts) > 5
17. zss Subscapular skinfold-for-age z-score
18. fss 1, if abs(zss) > 5

If not all parameter values have equal length, parameter values will be repeated to match the maximum length of all arguments except is_age_in_month using rep_len. This happens without warnings.

Z-scores are only computed for children younger than 60 months (age in months < 60)

## Referensi

WHO Multicentre Growth Reference Study Group (2006). WHO Child Growth Standards: Length/height-for-age, weight-for-age, weight-for-length, weight-for-height and body mass index-for-age: Methods and development. Geneva: World Health Organization; pp 312. (web site: http://www.who.int/childgrowth/publications/en/ )

WHO Multicentre Growth Reference Study Group (2007). WHO Child Growth Standards: Head circumference-for-age, arm circumference-for-age, triceps skinfold-for-age and subscapular skinfold-for-age: Methods and development. Geneva: World Health Organization; pp 217. (web site: http://www.who.int/childgrowth/publications/en/ )

