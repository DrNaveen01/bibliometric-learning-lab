# Bibliometric Analysis Learning Lab

A reproducible Quarto book, R workflow, teaching deck, exercises, and capstone project for bibliometric analysis and science mapping.

## Included

- Thirteen step-by-step chapters.
- Deterministic FCM-like demonstration data.
- Import templates for Scopus and Web of Science.
- Performance, thematic, coupling, co-citation, collaboration, and historiographic analyses.
- Clinical and funding overlays using graded theme membership.
- Workshop slides, learner worksheet, solutions, and instructor guide.
- GitHub Actions workflow for automatic rendering.
- Package-native teaching code: core analyses call `bibliometrix`, `dplyr`,
  `tidyr`, and `ggplot2` functions directly rather than project wrappers.

## Requirements

- R 4.3 or later.
- Quarto 1.5 or later.
- `bibliometrix` 5.5.0 or later.
- TinyTeX or another LaTeX distribution only when PDF output is required.
- Internet access for the first package installation.

## Start

```bash
Rscript install_packages.R
quarto preview
```

Render the full book:

```bash
quarto render
```

To render HTML only when LaTeX is unavailable:

```bash
quarto render --to html
```

Render the teaching slides:

```bash
quarto render slides/workshop.qmd
```

## Use real data

Place licensed exports in `data-raw/`. Do not commit or redistribute them unless the database licence permits it. Copy `R/02_import_real_data.R`, set the filenames and database sources, then run it.

## Reproducibility

The demonstration corpus is generated from a fixed seed. Analytical outputs are written to `outputs/figures/` and `outputs/tables/`. Run `renv::snapshot()` after confirming package installation to lock the local package versions.

The only custom code creates and loads the synthetic teaching corpus. It does
not alter any bibliometric method. All analytical steps remain visible in the
chapters.

## Licence

Code is released under the MIT Licence. Teaching text is released under CC BY 4.0. Bibliographic database exports retain their original licence restrictions.

