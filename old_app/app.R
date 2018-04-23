library(shiny)
library(leaflet)
library(magrittr)
library(dplyr)
library(shinythemes)


# Define UI for application that draws a histogram
ui <- bootstrapPage("GeoLV",
                 tabPanel("Teste",tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                                       leafletOutput("map",  width = "100%", height = "100%"),
                          bootstrapPage(absolutePanel(top = 70, right = 10,
                                                      sliderInput("n", min = 1, max= 1040, value = c(1, 1040),
                                                                  label = "Faixa de Observações"),
                                                      checkboxGroupInput("provider", 
                                                                         label = "Qual provedor?",
                                                                         choiceNames = c("ArcGIS", "Google Maps", "Here"),
                                                                         choiceValues = c("arcgis_online", "google_maps", "here_geocoder"),
                                                                         selected = c("arcgis_online", "google_maps", "here_geocoder"))))))
   

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  geolv <- reactive({
    readr::read_rds("banco.rds") %>% 
      slice(input$n[1]:input$n[2])
    })
  
  icons <- reactive({
    awesomeIcons(
      icon = 'ion-ios-circle-filled',
      iconColor = 'black',
      library = 'ion',
      markerColor = geolv()[["color"]])
    })
  
   output$map <- renderLeaflet({
     leaflet(geolv()) %>%
       addTiles() %>% 
       addAwesomeMarkers(lat  = ~latitude,
                         lng  = ~longitude,
                         icon = icons(),
                         popup = ~stringr::str_c(Dados_Originais, "<br/>",
                                          Dados_Obtidos, "<br/>",
                                          Qualidade, "<br/>")) %>% 
       addLegend("bottomright",
                 colors = c("green", "blue", "red"),
                 labels = c("ArcGIS", "Google Maps", "Here"),
                 title = "Provedor",
                 opacity = 1) 
     })
}

# Run the application 
shinyApp(ui = ui, server = server)

