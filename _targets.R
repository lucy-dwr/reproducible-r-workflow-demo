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
  tar_quarto(report,          "reports/penguins_report.qmd"),

  # Export artifacts to outputs/ for version control and publishing
  tar_target(
    export_clean_penguins,
    { path <- "outputs/penguins_clean.rds"; saveRDS(clean_penguins, path); path },
    format = "file"
  ),
  tar_target(
    export_species_summary,
    { path <- "outputs/species_summary.csv"; write.csv(species_summary, path, row.names = FALSE); path },
    format = "file"
  ),
  tar_target(
    export_body_mass_plot,
    { path <- "outputs/body_mass_plot.png"; ggplot2::ggsave(path, body_mass_plot, width = 8, height = 6, dpi = 150); path },
    format = "file"
  ),
  tar_target(
    export_model_summary,
    { path <- "outputs/model_summary.rds"; saveRDS(model_summary, path); path },
    format = "file"
  ),
  tar_target(
    export_report,
    { force(report); path <- "outputs/report.html"; file.copy("reports/penguins_report.html", path, overwrite = TRUE); path },
    format = "file"
  )
)
