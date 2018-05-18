rm(list = ls())

library(tidyverse)

data <- read_csv("banco_ssa.csv")

glimpse(data)

data <- data %>% 
  select(-NR_SECAO, -X1) %>% 
  distinct() 

data <- modify_if(data, is.character, str_replace_na)

casos <- data %>% 
  filter(is.na(latitude))

data <- data %>% 
  mutate(Dados_Originais = str_c("<strong>Dados Originais:</sstrong> ",
                                 "<em>", NM_LOCALIDADE, "</em>", ",",
                                 NM_LOCVOT, DS_ENDERECO, sep = " "),
         Dados_Originais = str_to_title(Dados_Originais),
         Dados_Obtidos   = str_c("<strong>Dados Obtidos:</strong> ", "<em>",
                                 locality, "</em>", street_name,
                                 street_number, sep = " "),
         Qualidade       = str_c("<strong>Dispersão:</strong> ", round(dispersion, 4), "<br/>",
                                 "<strong>Nº de Clusters:</strong> " ,clusters_count, "<br/>",
                                 "<strong>Nº de Provedores:</strong>", providers_count, "<br/>",
                                 "<strong>Provedor:</strong> ", provider),
         POP_UP           = str_c(Dados_Originais, "<br/>",
                                 Dados_Obtidos, "<br/>",
                                 Qualidade, "<br/>"),
         color           = case_when(provider == "arcgis_online" ~ "green",
                                     provider == "google_maps"   ~ "blue",
                                     provider == "here_geocoder" ~ "red"))


write_rds(data, "banco_ssa.rds")
write.csv(casos, "casos_ssa.csv")
