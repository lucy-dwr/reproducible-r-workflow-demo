clean_penguins_data <- function(penguins) {
  dplyr::filter(penguins, !is.na(body_mass_g), !is.na(sex))
}
