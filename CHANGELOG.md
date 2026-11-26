# Changelog

## 0.2.0 — 2026-11-27

- Removed all custom analytical and data-cleaning wrapper functions.
- Replaced wrappers with direct calls to `bibliometrix`, `dplyr`, `tidyr`,
  and `ggplot2` throughout the book, slides, exercises, and complete script.
- Retained only the deterministic synthetic-data generator and loader.
- Kept `community.repulsion = 0` explicitly in `thematicMap()` and
  `networkPlot()` calls to avoid the current layout-stage error.

## 0.1.1 — 2026-11-27

- Fixed the `switchLayout()` length error encountered by `thematicMap()`.
- Set `community_repulsion = 0` as the stable default.
- Added input-field checks and an automatic layout-error fallback.

## 0.1.0 — 2026-11-26

- Added the complete Quarto learning book.
- Added a deterministic FCM-like teaching corpus generator.
- Added thematic mapping and evolution workflows.
- Added coupling, co-citation, collaboration, and historiography workflows.
- Added clinical and funding overlays.
- Added slides, exercises, solutions, capstone assessment, and instructor guide.

