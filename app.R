library(magrittr)
library(shiny)
library(leaflet)

data <- readr::read_rds("amostra.rds")

# Define UI for application that draws a histogram

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
               selectInput("select", "Selecionar Observações",
                            data$X1
                ))
)

# Define server logic required to draw a histogram
server <- function(input, output, session){
  
  geolv <- shiny::reactive({
    data %>% 
      dplyr::filter(X1 %in% input$select)
    })
  
   output$map <- leaflet::renderLeaflet({
     leaflet::leaflet(geolv()) %>%
       leaflet::addTiles() %>% 
       leaflet::addMarkers(lng   = ~longitude,
                           lat   = ~latitude,
                           popup = ~POP_UP)
     })
}

# Run the application 
shiny::shinyApp(ui = ui, server = server)

