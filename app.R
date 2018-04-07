library(shiny)
library(leaflet)
library(magrittr)
library(dplyr)

# Define UI for application that draws a histogram
ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map",  width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("n", min = 1, max= 3659, valu = c(50, 100),
                            label = "Extenção de Pontos Observados"),
                checkboxGroupInput("provider",
                                   label = "Qual provedor?",
                                   choiceNames = c("Arc Gis", "Google Maps", "Here"),
                                   choiceValues = c("arcgis_online", "google_maps", "here_geocoder"),
                                   selected = "google_maps"))
                 )
   



# Define server logic required to draw a histogram
server <- function(input, output) {
  geolv <- reactive(readRDS("parcial.rds") %>% 
                      slice(input$n[1]:input$n[2]) %>% 
                      filter(provider %in% input$provider))
  
  
   output$map <- renderLeaflet({
     leaflet(geolv()) %>%
       addTiles() %>% 
       addMarkers(lat = ~latitude,
                  lng = ~longitude,
                  popup = ~stringr::str_c(Dados_Originais, "<br/>",
                                          Dados_Obtidos))
     })
}

# Run the application 
shinyApp(ui = ui, server = server)

