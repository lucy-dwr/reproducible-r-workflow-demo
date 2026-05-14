fit_body_mass_model <- function(penguins) {
  lm(body_mass_g ~ species + island + sex, data = penguins)
}

extract_model_summary <- function(model) {
  broom::tidy(model, conf.int = TRUE)
}
