rm(list = ls())

library(tidyverse)

data_df <- read_rds("banco.rds")

sample <- data_df %>% 
  mutate(QUALIDADE_NEG =  data_df$dispersion * clusters_count * (4 - providers_count)) %>% 
  filter(!is.na(QUALIDADE_NEG)) %>% 
  sample_n(100, weight = QUALIDADE_NEG)

sample <- sample %>% 
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

leaflet(sample) %>% 
  addTiles() %>% 
  addMarkers(lat   = ~latitude,
             lng   = ~longitude,
             popup = ~POP_UP)

# write_rds(sample, "amostra.rds") #Banco para o Shiny
# 
# sample %>%
#   select(X1, LOCAL_VOTACAO, FORNECIDOS, OBTIDOS) %>%
#   arrange(X1) %>%
#   write_csv("amostra.csv") # Banco para o Google Sheets
