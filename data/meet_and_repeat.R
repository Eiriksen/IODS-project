# 
# Data wrangling (max 5 points)
# Create a new R script meet_and_repeat.R and prepare the two data sets for the analyses as follows:
 
#   1. Load the data sets (BPRS and RATS) into R using as the source the GitHub repository of MABS, where they are given in the wide form:
#   https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
#   https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt
#   As before, write the wrangled data sets to files in your IODS-project data-folder.
#   Also, take a look at the data sets: check their variable names, view the data contents and structures, and create some brief summaries of the variables , so that you understand the point of the wide form data. (1 point)

library(tidyverse)

tb_BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",header = T)
tb_rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",header = T)

str(tb_BPRS)
tb_BPRS$treatment %>% unique()
# The table countains data for 40 subjects
# each row is one subject and all belonging data (wide format)
# there are 8 columns, one giving the BPRS score for each individual for each week
# The BPRS score is a physciological rating scale, high values indicate schizophrenia.
# There is also one column indicating which treatment group each individual belongs to (1 or 2)

str(tb_rats)
tb_rats$Group %>% unique()
# The table contains data from 16 subject (rats)
# each row is one subject and all belonging data (wide format)
# Also here, there are 11 columns, each giving the weight of the rat at 11 different days over a 9 week period
# THere is also a group column, indicating which group each rat belongs to (1, 2 or 3)


# 2. Convert the categorical variables of both data sets to factors. (1 point)
tb_BPRS_long <- 
  tb_BPRS %>%
  as_tibble() %>%
  mutate(
    # Because the ID used in this dataset are not unique (they repeat in each treatment), we will give the a new unique ID
    subject = paste(treatment,subject,sep="-"),
    subject = factor(subject),
    treatment = factor(treatment),
    ) %>%
  # 3. Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS. (1 point)
  pivot_longer(
    cols=-c(treatment,subject),
    values_to = "BPRS",
    names_to = "week", 
    names_prefix = "week", 
    ) %>%
  mutate(
    week = as.numeric(week)
    )


# 2. Convert the categorical variables of both data sets to factors. (1 point)
tb_rats_long <- 
  tb_rats %>%
  mutate(
    ID = factor(ID),
    Group = factor(Group)
    ) %>%
  # 3. Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS. (1 point)
  pivot_longer(
    cols=-c(ID,Group),
    names_to="day", 
    names_prefix = "WD", 
    values_to="weight"
    ) %>%
  mutate(
    day = as.numeric(day)
    )
 
# saving:
write_delim(tb_BPRS_long,"data-bprs.txt")
write_delim(tb_rats_long,"data-rats.txt")

 
# 4. Now, take a serious look at the new data sets and compare them with their wide form versions: Check the variable names, view the data contents and structures, and create some brief summaries of the variables. Make sure that you understand the point of the long form data and the crucial difference between the wide and the long forms before proceeding the to Analysis exercise. (2 points)
str(tb_rats_long)
str(tb_BPRS_long)

# Dataset are now organized so each row is one observation, which is what we need to do proper analysis on them.
# Columns "ID", "Group" (or "subject", "treatment") connect each obersvation to the right individual.


# summaries:
hist(tb_rats_long$weight) 
# rats seem to diverge into two groups, one "low weight" and one "high weight" group
hist(tb_BPRS_long$BPRS) 
# subject seem to mostly have very low scores of BRPS, with decreasing numbers for higher values