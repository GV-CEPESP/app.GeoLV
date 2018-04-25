rm(list = ls())

library(tidyverse)
library(geosphere)
library(foreign)

data_df <- read_csv("banco.csv")

data_compare_df <- read.dbf("Ctba_LocaisVotacao.dbf")

data_compare_df <- data_compare_df %>% 
  mutate(NR_ZONA   = as.numeric(COD_ZONA),
         NR_LOCVOT = COD_TRE) %>%
  select(NR_ZONA, NR_LOCVOT, COD_TRE, XCOORD, YCOORD)

data_df <- data_df %>% 
  mutate(NR_LOCVOT = as.character(NR_LOCVOT))

data_df <- data_df %>% 
  left_join(data_compare_df)

data_df$dist <- NA
for(i in 1:nrow(data_df)){
  data_df$dist[[i]] <- distm(c(data_df$longitude[[i]], data_df$longitude[[i]]), c(data_df$XCOORD[[i]], data_df$YCOORD[[i]]))
}

data_df %>% 
  ggplot(mapping = aes(x = dist)) +
  geom_histogram()

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
