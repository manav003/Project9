# R Studio API
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

# Libraries
library(tidyverse)
library(lubridate)
library(ggplot2)

# Data Import

week9_tbl <- as.tibble(read_csv(file = "../data/week3.csv")) %>% 
  mutate(timeStart = ymd_hms(timeStart), timeEnd = ymd_hms(timeEnd)) %>%  
  mutate(condition = factor(condition, levels = c("A", "B", "C"), 
                            labels = c("Block A", "Block B", "Control")), 
         gender = factor(gender, levels = c("M", "F"), labels = c("Male", "Female"))) %>% 
  mutate(avg15 = (q1 + q2 + q3 + q4 + q5)/5, avg610 = (q6 + q7 + q8 + q9 + q10)/5)


saveRDS(week9_tbl, "../shiny/for_shiny.rds")


# Generate Prototype of Figures that Shiny Needs to Draw

ggplot(week9_tbl, aes(x=avg15, y= avg610)) + 
  geom_jitter() +
  labs(x = "Mean scores of Q1 - Q5", y = "Mean scores of Q6 - Q10") +
  geom_smooth(method = "lm", se = FALSE)

