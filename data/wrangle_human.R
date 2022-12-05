# Eirik Åsheim
# 4-12-2022
# Script for rewrangling the human development index dataset.
 
# 0: Load the ‘human’ data into R. Explore the structure and describe.
library(tidyverse)
tb_human <- read_delim("data-human.txt")

str(tb_human)
# The "human" dataset contains various demographic and gender-inequality measures for all countries of the world, gathered by the UNited Nations development Programme.
# Each country is a row, columns represents various measures.
# HDI.rank    Human development index, ranked
# Country     Name of country (chr)
# HDI         Human development index
# Life.Exp    Life expectancy at birth
# Edu.exp     Expected years of schooling
# Edu.mean    Mean years of schooling
# GNI         Gross national income per capita
# GII.rank    Gender inequality index (ranked)
# GII         Gender inequality index, from 0 (equal) to 1 (unequal)
# Mat.Mor     Maternal mortality (deaths pr 100 000 births)
# Ado.Birth   Adolescent birth rate (births per 1000 women ages 15-19)
# Parli.F     % shars of seats in parliament by females
# Edu2.F      % of female population with at least some secondary education
# Edu2.M      % of male population with at least some secondary education
# Labo.F      % labour force participation, female
# Labo.M      % labour force participation, male
# Labo.FM     Ratio of female/male labour force participation
# Edu2.FM     Ratio of female/male population with at least some secondary education


# 1: Mutate the data: transform the Gross National Income (GNI) variable to numeric 
# Not necessary as read_delim does this automatically
# However, the way to do this would be to mutate the GNI column using the function as.numeric() 
is.numeric(tb_human$GNI)

# 2: Exclude unneeded variables
tb_human_edit <- 
  tb_human %>%
  select("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F") %>%
  # 3: Remove all rows with missing values
  na.omit() %>%
  # 4: Remove the observations which relate to regions instead of countries.
  filter( !Country %in% c(
    "Arab States",
    "East Asia and the Pacific",
    "Europe and Central Asia",
    "Latin America and the Caribbean",
    "South Asia",
    "Sub-Saharan Africa",
    "World"
  )) 


# Save as human.v2 
# Please see: https://i.imgflip.com/7345nz.jpg
write_delim(tb_human_edit,"data-human-v2.txt")

# 5: Then, save also a versio of the human dataset where Countries are row names
tb_human_edit %>%
  column_to_rownames("Country") %>% 
  write_delim("data-human-v2-countryRownames.txt")
