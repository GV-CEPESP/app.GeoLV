rm(list = ls())

library(tidyverse)
library(geosphere)
library(leaflet)
library(foreign)

# 1. Validação Exerna dos Resultados --------------------------------------

data_df <- read_csv("banco.csv")

prova_df <- read.dbf("Ctba_LocaisVotacao.dbf") %>% 
  as.tibble()

data_df <- data_df %>% 
  filter(NM_LOCALIDADE == "CURITIBA") %>% 
  mutate(TIPO = "ORIGINAL")

prova_df <- prova_df %>% 
  mutate(NR_ZONA   = as.integer(as.character(COD_ZONA)),
         NR_LOCVOT = as.integer(as.character(COD_TRE)),
         longitude    = as.numeric(XCOORD),
         latitude     = as.numeric(YCOORD),
         TIPO         = "PROVA") %>% 
  select(NR_ZONA, NR_LOCVOT, longitude, latitude, TIPO)

merged_df <- data_df %>% 
  bind_rows(prova_df)

merged_df <- merged_df %>% 
  arrange(NR_ZONA, NR_LOCVOT)

merged_df %>% 
  count(NR_ZONA, NR_LOCVOT) %>% 
  filter(n != 2)

merged_df <- merged_df %>% 
  filter(!(NR_ZONA == 178 & NR_LOCVOT == 1392)) %>% 
  filter(!(NR_ZONA == 178 & NR_LOCVOT == 1686))

merged_df %>% 
  count(NR_ZONA, NR_LOCVOT) %>% 
  filter(n != 2)

merged_df$dist <- NA

for(i in (2:nrow(merged_df) - 1)){
  if(i %% 2 != 0){
    merged_df$dist[[i]] <- distm(c(merged_df$longitude[[i]], merged_df$latitude[[i]]), c(merged_df$longitude[[i + 1]], merged_df$latitude[[i + 1]]))
  }
}

merged_df$dist <- ifelse(is.na(merged_df$dist), lag(merged_df$dist), merged_df$dist)

merged_df %>% 
  select(NR_ZONA, NR_LOCVOT, latitude, longitude, TIPO, dist) %>% 
  filter(dist > 1000)

merged_df %>% 
  ggplot(mapping = aes(x = dist)) +
  geom_histogram()

merged_df %>% 
  ggplot(mapping = aes(x = "teste", y = dist, group = 1)) +
  geom_boxplot() +
  coord_flip()

summary(merged_df$dist)
sort(merged_df$dist)

merged_df <- merged_df %>% 
  mutate(colors = ifelse(TIPO == "ORIGINAL", "green", "red"))

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = merged_df$colors
)

merged_df %>% 
  leaflet() %>% 
  addTiles() %>% 
  addAwesomeMarkers(~longitude,
                    ~latitude,
                    icon = icons)
