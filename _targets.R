library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("palmerpenguins", "dplyr", "ggplot2", "broom", "quarto")
)

# Load all functions from R/
tar_source("R/")

list(
  tar_target(raw_penguins,    get_penguins()),
  tar_target(clean_penguins,  clean_penguins_data(raw_penguins)),
  tar_target(species_summary, summarize_by_species(clean_penguins)),
  tar_target(island_summary,  summarize_by_island(clean_penguins)),
  tar_target(body_mass_plot,  plot_body_mass(clean_penguins)),
  tar_target(body_mass_model, fit_body_mass_model(clean_penguins)),
  tar_target(model_summary,   extract_model_summary(body_mass_model)),
  tar_quarto(report,          "reports/penguins_report.qmd")
)
