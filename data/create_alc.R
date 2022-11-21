# Author: Eirik Ryvoll Åsheim
# Data wrangling script for the Student Performance Data Set (ISBN 978-9077381-39-7, https://archive.ics.uci.edu/ml/datasets/Student+Performance)

library(tidyverse)

tb_mat <- read_delim("student-mat.csv")
tb_por <- read_delim("student-por.csv")

str(tb_mat)
str(tb_por)
# Both datasets have the same number of variables (33) but different number of rows (observations, N=395 for math and N=649 for Portuguese).
# Each row is one students, and the columns are their answers to different questions relating to their personal life, as well as some variables relating to their course outcomes

# Merge the datasets and mark variables which appear in both (but may differ) with _m for math and _p for portuguese
# Merge by all variables except failues, paid, absences, G1, G2, and G3
tb_full <- merge(
    tb_mat,tb_por,
    by=names(tb_mat)[!names(tb_mat) %in% c("failures","paid","absences","G1","G2","G3")],
    suffixes = c("_m","_p") 
  ) %>%
  # remove duplicate rows
  distinct() %>%
  # calculate avg alcohol consumption and mark high_use students
  mutate(
    alc_use = (Dalc+Walc)/2,
    high_use = as.logical(if_else(alc_use > 2, T, F)),
  ) %>%
  # calculate average values for math and portuguese course variables
  rowwise() %>%
  mutate(
    failures = mean(c(failures_m,failures_p)),
    absences = mean(c(absences_m, absences_p)),
    G1 = mean(c(G1_m,G1_p)),
    G2 = mean(c(G2_m,G2_p)),
    G3 = mean(c(G3_m,G3_p))
  )

# explore dataset
str(tb_full)

# Save the dataset:
write_delim(tb_full,"data-alc.txt")


