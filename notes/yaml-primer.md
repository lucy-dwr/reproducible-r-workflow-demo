# YAML primer for GitHub Actions

GitHub Actions workflow files are written in [YAML (YAML Ain't Markup Language)](https://yaml.org).
YAML is a plain-text format for structured data. It is designed to be easy to read,
but the formatting rules can be new to some programmers. This primer covers just 
enough to read a workflow file confidently. To dig deeper, visit the links at 
the end of this document.

## The basics

**Key–value pairs.** Most lines are a key and a value separated by a colon and a space:

```yaml
name: Run targets workflow
runs-on: ubuntu-latest
```

**Indentation creates structure.** YAML uses spaces (not tabs) to show that something
belongs inside something else. Two or four spaces is conventional; consistency matters:

```yaml
jobs:
  run-targets:               # run-targets is inside jobs
    runs-on: ubuntu-latest   # runs-on is inside run-targets
```

**Lists use a dash.** Items in a list start with `- `:

```yaml
branches:
  - main
  - dev
```

**Comments start with `#`.** Everything after `#` on a line is ignored:

```yaml
run: Rscript -e 'targets::tar_make()'   # this is a comment
```

**Strings usually don't need quotes,** but quotes are required when a value contains
special characters like `:`, `#`, or `{`:

```yaml
r-version: '4.5.2'   # quoted because it looks like a number
```

## The structure of a GitHub Actions file

A workflow file has three main sections:

```yaml
name: ...     # the name shown in the GitHub Actions UI

on: ...       # what triggers the workflow (events like push, pull_request)

jobs: ...     # one or more jobs to run; each job gets a fresh virtual machine
```

### `on` — triggers

```yaml
on:
  push:
    branches: [main]     # run when code is pushed to main
  pull_request:
    branches: [main]     # run when a pull request targets main
```

Square brackets (`[main]`) are a compact way to write a one-item list.

### `jobs` — what to run

Each job has a name, a machine to run on, and a list of steps:

```yaml
jobs:
  run-targets:              # job name (you choose this)
    runs-on: ubuntu-latest  # the virtual machine to use

    steps:
      - name: Check out repository
        uses: actions/checkout@v4
```

### `steps` — the tasks within a job

Each step does one thing. A step either calls a pre-built action:

```yaml
- name: Set up R
  uses: r-lib/actions/setup-r@v2   # pre-built action from r-lib
  with:
    r-version: '4.5.2'             # options passed to the action
```

Or runs a shell command directly:

```yaml
- name: Run targets pipeline
  run: Rscript -e 'targets::tar_make()'
```

`with:` passes named options to the action. `run:` executes a shell command.

**Where do pre-built actions come from?** Each `uses:` value points to a GitHub
repository. The format is `owner/repo@version`, where `@version` is a git tag
that pins the action to a specific release. Some actions live in a subdirectory
of a repository, which adds a path segment: `owner/repo/subdirectory@version`.

For example:

| `uses:` value | GitHub repository |
|:---|:---|
| `actions/checkout@v4` | github.com/actions/checkout |
| `r-lib/actions/setup-r@v2` | github.com/r-lib/actions (subdirectory `setup-r`) |
| `r-lib/actions/setup-renv@v2` | github.com/r-lib/actions (subdirectory `setup-renv`) |
| `quarto-dev/quarto-actions/setup@v2` | github.com/quarto-dev/quarto-actions (subdirectory `setup`) |

Anyone can publish a GitHub Action by adding an `action.yml` file to a repository.
The [GitHub Actions Marketplace](https://github.com/marketplace?type=actions) is
a searchable index of published actions.

## Reading `run-targets.yaml`

With the above in mind, the full workflow in [`.github/workflows/run-targets.yaml`](../.github/workflows/run-targets.yaml)
reads as:

1. Trigger on any push or pull request to `main`.
2. Spin up a fresh Ubuntu machine.
3. Download the repository (`actions/checkout`).
4. Install R at the pinned version (`r-lib/actions/setup-r`).
5. Install pandoc and Quarto (needed to render the report).
6. Install a system library that igraph requires (`libglpk-dev`).
7. Restore the package environment from [`renv.lock`](../renv.lock) (`r-lib/actions/setup-renv`).
8. Run `targets::tar_make()`.

If every step passes, the workflow succeeds — confirming that the project can be
rebuilt on a clean machine.

## Further reading

- [All things YAML](https://yaml.org)
- [GitHub Actions quickstart](https://docs.github.com/en/actions/quickstart)
- [Workflow syntax reference](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions)
- [r-lib/actions](https://github.com/r-lib/actions) — pre-built actions for R projects
