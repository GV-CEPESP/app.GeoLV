library(magrittr)

data <- readr::read_rds("amostra.rds")

# Define UI for application that draws a histogram

ui <- shiny::bootstrapPage(
  shiny::tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leaflet::leafletOutput("map", width = "100%", height = "100%"),
  shiny::absolutePanel(top = 10, right = 10,
                selectInput("select", label = "Selecionar Observações", choices = sort(data$X1), multiple = T)
                )
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

