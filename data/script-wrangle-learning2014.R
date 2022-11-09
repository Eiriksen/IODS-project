# Author: Eirik Ryvoll Åsheim
# script for wrangling data fromthe create learning 2014 datast

library(tidyverse)


# reading the data
tb_learning <- read_delim("JYTOPKYS3-data.txt")


# This shows us a glance of what the data looks like: The columns, their names, their types, and some of their values
# We can see here that we're dealing with 60 variables and 183 observations, and that they're all coded as characters (chr)
str(tb_learning)


# Now hold on, there's a problem, it seems like all the numbers in the dataset is stored as characers with a lot of spaces included, like "  4" instead of 4.
# If we open the file itself in a text editor we can see why: it is because the separator between the values is not only a tab, but also some spaces.
# So, when the file reader is separating the values only by tab, it keeps all those spaces

# Easy fix! Include 'trim_ws=T' as an argument in read_delim(), it trims away all whitespace (spaces) before reading the file
tb_learning <- read_delim("JYTOPKYS3-data.txt", trim_ws=T)
str(tb_learning)

# now it looks good!


tb_learning_edited <- 
  tb_learning %>%
  mutate(
    d_sm =  D03+D11+D19+D27,
    d_ri =  D07+D14+D22+D30,
    d_ue =  D06+D15+D23+D31,
    deep =  d_sm + d_ri + d_ue,
    deep =  deep/12,
    
    su_lp = SU02+SU10+SU18+SU26,
    su_um = SU05+SU13+SU21+SU29,
    su_sb = SU08+SU16+SU24+SU32,
    surf =  su_lp + su_um + su_sb,
    surf =  surf/12,
    
    st_os = ST01+ST09+ST17+ST25,
    st_tm = ST04+ST12+ST20+ST28,
    stra =  st_os + st_tm,
    stra =  stra/8,
  ) %>%
  filter(Points != 0) %>%
  rename(age=Age, attitude=Attitude, points=Points) %>%
  select(gender, age, attitude, deep, stra, surf, points)



# saving the file  
write_delim(tb_learning_edited, delim="\t", file = "data-learning2014.txt")



# testing that it can be read
tb_test <- read_delim("data-learning2014.txt")
str(tb_test)
# looks good!
