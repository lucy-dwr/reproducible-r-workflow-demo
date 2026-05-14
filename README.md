# Reproducible R Workflow Demo

This repository is a worked example of a reproducible R analysis workflow. It is
designed as a hands-on teaching resource — you can clone it, run it, and explore
how each piece fits together.

The workflow uses:

- [`targets`](https://docs.ropensci.org/targets/) for pipeline orchestration
- [`renv`](https://rstudio.github.io/renv/) for environment management
- [GitHub Actions](https://github.com/features/actions) for continuous integration
- [Quarto](https://quarto.org) for reports and slides

## What you will learn

After working through this repository, you should understand:

- how to structure a reproducible R project
- how `targets` tracks workflow dependencies and skips up-to-date work
- how `renv` records and restores package versions
- how GitHub Actions can verify that the project runs on a clean machine

## Analytical example

This project uses the [Palmer penguins](https://allisonhorst.github.io/palmerpenguins/)
dataset to examine body mass patterns by penguin species and island. The pipeline
produces a cleaned dataset, summary tables, a boxplot, and a simple linear
regression — all tied together in a rendered Quarto report.

The statistical model is intentionally simple. The focus of this repository is
workflow structure, not modelling sophistication.

## Slide deck

A Revealjs slide deck introducing these ideas is in `slides/`. It is published to
[GitHub Pages](https://lucy-dwr.github.io/reproducible-r-workflow-demo/) automatically whenever the `slides/` directory changes.

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
│   ├── demo-script.md                 # suggested live demo sequence
│   └── yaml-primer.md                 # short YAML introduction for newcomers
│
└── .github/
    └── workflows/
        ├── run-targets.yaml           # CI workflow
        └── publish-slides.yaml        # GitHub Pages deployment
```

## How to run this project

**1. Clone the repository and open the `.Rproj` file in RStudio, Positron, or your
favorite IDE.**

**2. Restore the package environment.**

This gives you the exact package versions the project was built with.

```r
renv::restore()
```

**3. Run the pipeline.**

```r
targets::tar_make()
```

`targets` will run each step in the correct order and skip anything already up to
date. The rendered report lands in `outputs/report.html`.

**4. Inspect the pipeline graph.**

```r
targets::tar_visnetwork()
```

This opens an interactive diagram showing the dependencies between targets.

**5. Try making a change.**

Edit a function in `R/` — for example, change a plot label in `visualize.R`. Then
run:

```r
targets::tar_outdated()   # see what needs to rerun
targets::tar_make()       # rebuild only the affected targets
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

This repository uses two GitHub Actions workflows:

- **`run-targets.yaml`** — runs the `targets` pipeline on every push and pull
  request to `main`. It restores the `renv` environment from `renv.lock` before
  running `targets::tar_make()`, so the pipeline is verified on a clean machine.
- **`publish-slides.yaml`** — renders the slide deck and publishes it to GitHub
  Pages whenever the `slides/` directory changes.

The [r-lib/actions](https://github.com/r-lib/actions) repository maintains a
collection of common R-focused GitHub Actions workflows (package checks, test
coverage, pkgdown sites, and more) that you can copy and adapt for your own
projects.

**Reading the workflow files.** Workflow files are written in YAML. The key
structural elements are:

- `on:` — what triggers the workflow (here: pushes and pull requests to `main`)
- `jobs:` — one or more tasks to run; each job gets a fresh virtual machine
- `steps:` — the sequence of actions within a job; each step calls a pre-built
  action (`uses:`) or runs a shell command (`run:`)

Pre-built actions are themselves GitHub repositories. The format
`uses: owner/repo@version` (e.g. `uses: actions/checkout@v4`) tells GitHub
Actions to fetch that repository at the given version tag and run it as a step.
`r-lib/actions/setup-r@v2`, for example, lives in the
[r-lib/actions](https://github.com/r-lib/actions) repository.

The files in `.github/workflows/` include inline comments explaining each step.
If YAML is new to you, `notes/yaml-primer.md` has a short introduction.

## Note for instructors

The `renv.lock` file is already committed, so learners who clone this repository
can jump straight to `renv::restore()`. If you are building a similar project from
scratch, the setup sequence is:

```r
renv::init()       # start project-specific dependency tracking
# install packages with `install.packages()`, then:
renv::snapshot()   # record current package versions to renv.lock
```
