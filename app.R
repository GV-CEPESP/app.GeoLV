library(shiny)
library(leaflet)
library(magrittr)
library(dplyr)

data <- readr::read_rds("amostra.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
  mainPanel(
    leafletOutput("map", width = "100%", height = "700")
  ),
  sidebarPanel(position = "right",
    selectInput("select", 
                label = "Observação",
                choices = sort(data$X1),
                multiple = T
                )
    )
  )
  )

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

