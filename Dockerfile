FROM rocker/shiny

RUN install2.r shinyWidgets lubridate tidyverse wordcloud shinythemes shinydashboard 

RUN  mkdir /app
COPY broadway_app/* /app/

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app', port = 3838, host = '0.0.0.0')"]

