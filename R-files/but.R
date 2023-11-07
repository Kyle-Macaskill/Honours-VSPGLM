# Fitting a SAM on the butterfly dataset
library("readxl")
but_y = read_excel("butterfly_y.xlsx")
but_x = read_excel("butterfly_x.xlsx")
library(devtools)
install_github("skiptoniam/ecomix")

library(mvabund)
but_df = as.data.frame(but_x)
but_df$y = as.matrix(as.data.frame(but_y))
but_df

but_form = y ~ Building + Urban.Vegetation + Habitat_Mixed + Habitat_Short + Habitat_Tall
ft_Mix = ecomix::species_mix(but_form, data=but_df, family="negative.binomial", nArchetypes=2, control=list(init_method='kmeans',ecm_refit=5, ecm_steps=2) )
coef(ft_Mix)$beta