library(shiny)
library(data.table)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(shinyWidgets)
library(DT)
library(wordcloud)
library(RColorBrewer)
library(pdftools)

source("global.R")

server <- function(input, output) {
  
  data <- read.csv("broadway.csv")
  data$Date.Full <- mdy(data$Date.Full)
  
  overview <- reactiveValues(
    subtitle = ("Musicals"),
    start = "1990-08-26",
    end = "1995-08-26")
  
  output$title <- renderText(overview$title)
  
  output$pick_show_type <- renderUI(
    awesomeRadio(
      inputId = "show_type_picker",
      label = "Select a show type", 
      choices = unique(data$Show.Type),
      selected = "Musical",
      status = "warning"
    )
  )
  
  output$dates <- renderUI(
    dateRangeInput("dates", label = ("Date range"),start = '1990-08-26', end = "2016-08-14")
  )
  
  
  observeEvent(input$show, {
    overview$subtitle <- as.character(input$show_type_picker)
    overview$start <- as.Date(input$dates[1])
    overview$end <- as.Date(input$dates[2])
    
    data_filter <<-   data %>% filter(data$Show.Type == overview$subtitle,
                                      data$Date.Full > overview$start,
                                      data$Date.Full < overview$end)
    
    output$pick_show <- renderUI(
      pickerInput(
        inputId = "show_picker",
        label = "Pick the specific shows",
        choices = sort(unique(data_filter$Show.Name)),
        options = list(
          `actions-box` = TRUE,
          size = 10,
          `selected-text-format` = "count > 3"
        ),
        multiple = TRUE
      )
    )
    
    output$data_button <- renderUI(
      actionButton("data", label = "See analysis")
    )
    
    output$subtitle <- renderUI(h2(overview$subtitle))
  })
  
  
  observeEvent( input$data, {
    
    shows <- as.list(input$show_picker)
    
    data_filter <- data_filter %>% filter(Show.Name %in% shows)
    
    output$data <- renderDT(select(data_filter, -Date.Day, -Date.Month, -Date.Year, -Show.Theatre, -Show.Type))
    
    output$summary <- renderDT(
      summary(data_filter),
      colnames = c('Avg. profit', 'Avg. attendants', 'Avg. Occupancy')
    )
    
    output$plot <- renderPlot(
      plot(data_filter)
    )
    
    data_filter$rev_per_att <- data_filter$Statistics.Gross / data_filter$Statistics.Attendance
    
    output$bar_chart <- renderPlot(
      bar_chart(data_filter)
    )
    
    output$info_box <- renderInfoBox(
      infoBox(
        title = "Most popular show",
        value = data_filter %>% arrange(data_filter$Statistics.Attendance, decreasing = TRUE) %>% select(Show.Name) %>% head(1),
        icon = icon("thumbs-up", lib = "glyphicon"),
        color = "purple"
      )
    )
    
    v <- data_filter %>% 
      group_by(Show.Theatre) %>% 
      count(Show.Theatre) %>% 
      arrange(desc(n))
    
    output$wordcloud <- renderPlot(
      wordcloud(words = v$Show.Theatre, freq = v$n, 
                scale=c(4,0.5),
                min.freq = 3, 
                colors=brewer.pal(8, "Dark2"),
                title = "Theaters used most commonly")
    )
    
  })
}