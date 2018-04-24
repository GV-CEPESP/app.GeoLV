library(shiny)
library(leaflet)
library(magrittr)
library(dplyr)

data <- readr::read_rds("amostra.rds")

# Define UI for application that draws a histogram
ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                selectInput("select", 
                label = "Selecionar Observações",
                choices = sort(data$X1),
                multiple = T
                )))

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  geolv <- reactive({
    data %>% 
      dplyr::filter(X1 %in% input$select)
    })
  
   output$map <- renderLeaflet({
     leaflet(geolv()) %>%
       addTiles() %>% 
       addMarkers(lat  = ~latitude,
                  lng  = ~longitude,
                  popup = ~POP_UP)
     }
     )
}

# Run the application 
shinyApp(ui = ui, server = server)

