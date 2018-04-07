#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(magrittr)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("GeoLV Testes"),
   leafletOutput("map")
   
   )

# Define server logic required to draw a histogram
server <- function(input, output) {
   geolv <- reactive({
     readRDS("parcial.rds")
   })
   
   output$map <- renderLeaflet({
     leaflet(geolv()) %>%
       addTiles() %>% 
       addMarkers(lat = ~latitude,
                  lng = ~longitude)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

