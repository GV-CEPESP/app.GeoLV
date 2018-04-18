### filtering casos errados

casos <- data %>% 
  filter(  locality=="Manaus"|
             locality=="Rio Branco"|
             locality=="Formigueiro"|
             locality=="Novo Hamburgo"|
             locality=="Pinhão"|
             locality=="São Paulo"|
             locality=="Itaquaquecetuba"|
             locality=="Queimados"|
             locality=="Nova Iguaçu")

write.csv(casos,"casos.csv")
             