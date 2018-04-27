rm(list = ls())

library(tidyverse)
library(geosphere)
library(foreign)

data_df <- read_csv("banco.csv")

data_df <- data_df %>% 
  mutate(LOCAL_VOTACAO = str_c(NM_LOCVOT),
         FORNECIDOS    = str_c(NM_LOCALIDADE, " - ", DS_ENDERECO,". CEP: ", NR_CEP),
         OBTIDOS       = str_c(locality, " - ", street_name, ", ", street_number, ". CEP: ", postal_code),
         LON           = longitude,
         LAT           = latitude,
         POP_UP        = str_c("<strong>Número da Observação</strong>: ", X1, "</br>",
                               "<strong>Local de Votavação</strong>: ", LOCAL_VOTACAO, "</br>",
                               "<strong>Dados Foerncedidos</strong>: ", FORNECIDOS, "</br>",
                               "<strong>Dados Obtidos</strong>: ", OBTIDOS, "</br>",
                               "<strong>Coordenadas</strong>: LAT ", LAT, " LON ", LON))

pre_sample_min <- data_df %>% 
  filter(dispersion > quantile(dispersion, 0.75, na.rm = T)) %>% 
  sample_n(30)

pre_sample_max <- data_df %>% 
  filter(dispersion < quantile(dispersion, 0.25, na.rm = T)) %>% 
  sample_n(30)

sample_df <- pre_sample_min %>% 
  bind_rows(pre_sample_max)

leaflet(sample_df) %>% 
  addTiles() %>% 
  addMarkers(lat   = ~latitude,
             lng   = ~longitude,
             popup = ~POP_UP)

# readr::write_rds(sample_df, "amostra.rds") #Banco para o Shiny
# 
# sample_df %>%
#   select(X1, LOCAL_VOTACAO, FORNECIDOS, OBTIDOS) %>%
#   arrange(X1) %>%
#   write_csv("amostra.csv") # Banco para o Google Sheets
