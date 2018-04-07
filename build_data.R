rm(list = ls())

library(tidyverse)

data <- read_csv("parcial.csv")

glimpse(data)

data <- data %>% 
  select(-NR_SECAO) %>% 
  distinct() %>% 
  mutate(Dados_Originais = str_c("Dados Originais:", NM_LOCALIDADE, ",", NM_LOCVOT, DS_ENDERECO, sep = " "),
         Dados_Obtidos   = str_c("Dados Obtidos:",locality, street_name, street_number, sep = " "))

write_rds(data, "parcial.rds")


