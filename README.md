# Reproducible R Workflow Demo

This repository demonstrates a reproducible R analysis workflow using:

- [`targets`](https://docs.ropensci.org/targets/) for pipeline orchestration
- [`renv`](https://rstudio.github.io/renv/) for environment management
- [GitHub Actions](https://github.com/features/actions) for continuous integration
- [Quarto](https://quarto.org) for reports and slides

## Analytical example

This project uses the [Palmer penguins](https://allisonhorst.github.io/palmerpenguins/) dataset
to examine body mass patterns by species and island.

## Repository structure

```text
reproducible-r-workflow-demo/
├── README.md
├── reproducible-r-workflow-demo.Rproj
├── _targets.R                         # pipeline definition
├── renv.lock                          # package version record
├── .Rprofile                          # activates renv on project open
├── .gitignore
│
├── R/
│   ├── data.R                         # load raw data
│   ├── clean.R                        # remove missing values
│   ├── summarize.R                    # summary tables
│   ├── visualize.R                    # figures
│   └── model.R                        # model fitting and extraction
│
├── reports/
│   └── penguins_report.qmd            # Quarto report (consumes pipeline outputs)
│
├── slides/
│   ├── reproducible_r_workflows.qmd   # Revealjs slide deck
│   └── images/
│
├── outputs/                           # derived analysis products
│
├── data/                              # raw data (loaded from palmerpenguins package)
│
├── notes/
│   └── demo-script.md                 # suggested live demo sequence
│
└── .github/
    └── workflows/
        └── run-targets.yaml           # CI workflow
```

## How to run this project

**1. Clone the repository and open the `.Rproj` file in RStudio, Positron, or your favorite IDE.**

**2. Restore the package environment so that you have the correct package versions for the repository.**

```r
renv::restore()
```

**3. Run the pipeline.**

```r
targets::tar_make()
```

**4. Inspect the pipeline graph.**

```r
targets::tar_visnetwork()
```

**5. Render the report (if not already rendered by the pipeline).**

```r
quarto::quarto_render("reports/penguins_report.qmd")
```

## What the pipeline does

| Target | Description |
|:-------|:------------|
| `raw_penguins` | Loads the penguins dataset from `palmerpenguins` |
| `clean_penguins` | Removes rows with missing body mass or sex |
| `species_summary` | Summarises body mass by species |
| `island_summary` | Summarises body mass by island |
| `body_mass_plot` | Creates a boxplot of body mass by species and island |
| `body_mass_model` | Fits `body_mass_g ~ species + island + sex` |
| `model_summary` | Extracts tidy model coefficients |
| `report` | Renders `reports/penguins_report.qmd` |

## Continuous integration

This repository uses GitHub Actions to run the `targets` pipeline on every push and pull request
to `main`. The workflow restores the `renv` environment from `renv.lock` before running
`targets::tar_make()`.

## First-time setup

If you are setting up the project from scratch (no `renv.lock` yet):

```r
renv::init()
# install packages, then:
renv::snapshot()
```

## Learning goals

After reviewing this repository, you should understand:

- how to structure a reproducible R project
- how `targets` tracks workflow dependencies and skips up-to-date work
- how `renv` records and restores package versions
- how GitHub Actions can verify that the project runs on a clean machine
