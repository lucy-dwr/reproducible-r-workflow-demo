summarize_by_species <- function(penguins) {
  dplyr::summarize(
    dplyr::group_by(penguins, species),
    n              = dplyr::n(),
    mean_body_mass = mean(body_mass_g),
    sd_body_mass   = sd(body_mass_g),
    .groups = "drop"
  )
}

summarize_by_island <- function(penguins) {
  dplyr::summarize(
    dplyr::group_by(penguins, island),
    n              = dplyr::n(),
    mean_body_mass = mean(body_mass_g),
    sd_body_mass   = sd(body_mass_g),
    .groups = "drop"
  )
}
