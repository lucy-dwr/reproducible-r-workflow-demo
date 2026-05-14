# Demo script

This script guides a live walkthrough of the reproducible R workflow demo.

## Suggested sequence

1. **Open `_targets.R`.**
   Point out that each `tar_target()` call defines one analytical product.
   The list structure makes the full workflow visible in a single file.

2. **Run `targets::tar_visnetwork()`.**
   Show the dependency graph in the RStudio viewer.
   Explain that `targets` derived this graph automatically from the function arguments.

3. **Run `targets::tar_make()`.**
   Show that all targets build in dependency order.
   Point out the "built" messages — each target is hashed and cached.

4. **Run `targets::tar_make()` again immediately.**
   All targets are skipped: "All targets are already up to date."
   This is the skip-and-rebuild behavior.

5. **Modify one function** — for example, change the plot title in `R/visualize.R`
   from `"Body mass by species and island"` to `"Penguin body mass by species and island"`.

6. **Run `targets::tar_outdated()`.**
   Show that only `body_mass_plot` and `report` are listed as outdated.
   `species_summary` and `model_summary` are unaffected.

7. **Run `targets::tar_make()` again.**
   Only the two outdated targets rebuild. Everything else is skipped.

8. **Open the GitHub Actions tab** for this repository and show the most recent
   successful workflow run. Point out the steps: checkout, R setup, renv restore,
   `tar_make()`.

## Tips

- Do not rely on a live GitHub Action triggering during the talk.
  Have a completed successful run ready to show before the session.
- The skip-and-rebuild demonstration (steps 5–7) tends to land well with audiences.
  Budget enough time for it.
- If the audience includes `make` users, the analogy to Makefiles is useful:
  `targets` is essentially a modern, R-native make system.
