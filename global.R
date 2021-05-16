library(tidyverse)
library(ggplot2)
library(scales)

summary <- function(data) {
  data %>% 
    summarize(
      average_gross = dollar(round(mean(Statistics.Gross),2)),
      average_attendants = round(mean(Statistics.Attendance),2),
      occupancy = round(mean(Statistics.Capacity),2)
    )
  
}

plot <- function(data) {
  data %>% 
    ggplot(aes(x = Date.Full, y = Statistics.Attendance, color = Show.Name)) +
    geom_line() +
    labs(x = "Date of performance", y = "Number of Attendants", color = "Show name") +
    theme(legend.position = "bottom")
}

bar_chart <- function(data) {
  data %>% 
    group_by(Show.Name) %>% 
    summarise(avg_rev_per_att = mean(rev_per_att)) %>% 
    ggplot(aes(x = Show.Name, y = avg_rev_per_att)) +
    geom_bar(stat = "identity") +
    labs(x = "Show names", y = "Average price per attendant") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
}
