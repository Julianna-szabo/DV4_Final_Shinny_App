library(shiny)
library(shinythemes)
library(shinydashboard)
library(data.table)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(shinyWidgets)
library(DT)

# Define UI for application that draws a histogram

ui <- dashboardPage(
     dashboardHeader(title = "Shows on Brodway"),
     dashboardSidebar(
       uiOutput("pick_show_type"),
       uiOutput("dates"),
       actionButton("show", label = "See show names"),
       br(),
       uiOutput("pick_show"),
       uiOutput("data_button"),
       br(),
       sidebarMenu(
         menuItem(h3("Overview"), tabName = "overview"),
         menuItem(h3("Plots"), tabName = "plots"),
         menuItem(h3("Data"), tabName = "data")
       )
      ),
     dashboardBody(
       tabItems(
                tabItem( tabName = "overview",
                         uiOutput(("subtitle")),
                         br(),
                         infoBoxOutput("info_box"),
                         br(),
                         DTOutput("summary"),
                         plotOutput("wordcloud")
                ),
                tabItem(tabName = "plots",
                        plotOutput("plot"),
                        plotOutput("bar_chart")
                ),
                tabItem(tabName = "data",
                        DTOutput("data")
               )
       )
     )
)