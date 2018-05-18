library(magrittr)
library(shiny)
library(leaflet)

data <- readr::read_rds("banco_ssa.rds") %>% 
  dplyr::arrange(X1)

# Define UI for application that draws a histogram

ui <- fluidPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "70%", height = "600"),
  absolutePanel(top = 10, right = 10,
               selectInput("select", "Selecionar Observações",
                            data$X1
                ))
)

# Define server logic required to draw a histogram
server <- function(input, output, session){
  
  select <- shiny::reactive({
    data %>% 
      dplyr::filter(X1 %in% input$select)
    })
  
   output$map <- leaflet::renderLeaflet({
     leaflet::leaflet(data) %>%
       leaflet::addTiles() %>% 
       leaflet::addAwesomeMarkers(lng   = ~longitude,
                                  lat   = ~latitude,
                                  popup = ~POP_UP)
     })
   
   observe({
     leafletProxy("map") %>% 
       setView(lng = select()$longitude,
               lat = select()$latitude,
               zoom = 15)
   })
}

# Run the application 
shiny::shinyApp(ui = ui, server = server)

