# R script for wrangling the human development and gender inequality datasets
# Eirik R. ?sheim 
# 2022 November 25


library(tidyverse)

# 2) Read data
tb_hd <- read_delim("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
tb_gii <- read_delim("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")


# 3) Explore data
str(tb_hd)
summary(tb_gii)
# 195 rows (countries), various measures of human development (numeric) values
str(tb_gii)
summary(tb_hd)
# 195 rows (contries), various measures of gender equality (numeric)


# 4) 

tb_hd_edit <- 
  tb_hd %>%
  rename(
   "HDI.rank" = "HDI Rank",
   "HDI" = "Human Development Index (HDI)",
   "Life.Exp" = "Life Expectancy at Birth",
   "Edu.Exp" = "Expected Years of Education",
   "Edu.mean" = "Mean Years of Education",
   "GNI" = "Gross National Income (GNI) per Capita",
   "GNI.subHDI" = "GNI per Capita Rank Minus HDI Rank"
  )

tb_gii_edit <- 
  tb_gii %>%
  rename(
   "GII.rank" =  "GII Rank",
   "GII" =  "Gender Inequality Index (GII)",
   "Mat.Mor" =  "Maternal Mortality Ratio",
   "Ado.Birth" =  "Adolescent Birth Rate",
   "Parli.F" =  "Percent Representation in Parliament",
   "Edu2.F" =  "Population with Secondary Education (Female)",
   "Edu2.M" =  "Population with Secondary Education (Male)",
   "Labo.F" =  "Labour Force Participation Rate (Female)",
   "Labo.M" =  "Labour Force Participation Rate (Male)",
  ) %>%
# 6)
  mutate(
    Labo.FM = Labo.F / Labo.M,
    Edu2.FM = Edu2.F / Edu2.M
  )


# 7)
tb_human <- 
  inner_join(tb_hd_edit,tb_gii_edit, by="Country")

write_delim(tb_human, "data-human.txt")
