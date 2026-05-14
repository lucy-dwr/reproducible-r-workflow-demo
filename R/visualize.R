plot_body_mass <- function(penguins) {
  ggplot2::ggplot(
    penguins,
    ggplot2::aes(x = species, y = body_mass_g, fill = species)
  ) +
    ggplot2::geom_boxplot(alpha = 0.7, outlier.shape = 16) +
    ggplot2::facet_wrap(~island) +
    ggplot2::scale_fill_manual(
      values = c(Adelie = "#FF8C00", Chinstrap = "#9932CC", Gentoo = "#008B8B")
    ) +
    ggplot2::labs(
      title = "Body mass by species and island",
      x     = "Species",
      y     = "Body mass (g)",
      fill  = "Species"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "none")
}
