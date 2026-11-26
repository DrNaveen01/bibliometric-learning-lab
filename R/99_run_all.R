source(here::here("R", "00_setup.R"))

M <- load_demo_data(regenerate = TRUE)
M <- M |>
  mutate(
    DI = na_if(tolower(trimws(DI)), ""),
    TI = str_squish(TI),
    AU = str_to_upper(str_squish(AU))
  )
M <- M[!duplicated(M$DI) | is.na(M$DI), , drop = FALSE]
title_year <- paste(tolower(trimws(M$TI)), M$PY)
M <- tibble::as_tibble(M[!duplicated(title_year), , drop = FALSE])

# Standardise keyword case before merging
M <- M |>
  dplyr::mutate(
    DE = stringr::str_to_upper(stringr::str_squish(DE)),
    ID = stringr::str_to_upper(stringr::str_squish(ID))
  )

# This now removes duplicates such as efficacy/EFFICACY
M <- bibliometrix::mergeKeywords(M, force = TRUE)

fields <- intersect(
  c("AU", "TI", "SO", "DE", "ID", "AB", "CR", "PY", "DI"),
  names(M)
)
metadata_table <- M |>
  summarise(
    across(
      all_of(fields),
      ~ sum(!is.na(.x) & nzchar(trimws(as.character(.x))))
    )
  ) |>
  pivot_longer(everything(), names_to = "field", values_to = "available") |>
  mutate(
    total = nrow(M),
    percent_available = round(100 * available / total, 1)
  )

readr::write_csv(metadata_table, "outputs/tables/metadata_profile.csv")

performance <- bibliometrix::biblioAnalysis(M, sep = ";")
capture.output(
  summary(performance, k = 20, pause = FALSE),
  file = "outputs/tables/performance_summary.txt"
)

thematic <- bibliometrix::thematicMap(
  M = M,
  field = "KW_Merged",
  n = 100,
  minfreq = 5,
  ngrams = 1,
  stemming = FALSE,
  size = 0.7,
  n.labels = 3,
  community.repulsion = 0,
  repel = TRUE,
  remove.terms = fcm_remove_terms,
  synonyms = fcm_synonyms,
  cluster = "louvain",
  subgraphs = TRUE,
  alpha = 0.5,
  seed = 20261126
)

ggplot2::ggsave(
  "outputs/figures/thematic_map.png",
  thematic$map,
  width = 9,
  height = 7,
  dpi = 300
)
readr::write_csv(thematic$clusters, "outputs/tables/thematic_clusters.csv")

thematic_top_terms <- thematic$words |>
  arrange(Cluster, desc(Cluster_PageRank), desc(Occurrences)) |>
  group_by(Cluster, Cluster_Label) |>
  slice_head(n = 10) |>
  ungroup()

readr::write_csv(thematic_top_terms, "outputs/tables/thematic_top_terms.csv")
readr::write_csv(
  thematic$documentToClusters,
  "outputs/tables/document_theme_membership.csv"
)

theme_columns <- intersect(
  thematic$clusters$name,
  names(thematic$documentToClusters)
)
membership_long <- thematic$documentToClusters |>
  select(SR, all_of(theme_columns)) |>
  pivot_longer(
    cols = all_of(theme_columns),
    names_to = "theme",
    values_to = "membership"
  )

theme_by_indication <- membership_long |>
  left_join(M |> select(SR, INDICATION), by = "SR") |>
  filter(!is.na(INDICATION)) |>
  group_by(theme, INDICATION) |>
  summarise(weighted_documents = sum(membership, na.rm = TRUE), .groups = "drop") |>
  group_by(theme) |>
  mutate(percent_within_theme = 100 * weighted_documents / sum(weighted_documents)) |>
  ungroup()

readr::write_csv(
  theme_by_indication,
  "outputs/tables/theme_by_indication.csv"
)

theme_by_funding <- membership_long |>
  left_join(M |> select(SR, FUNDING_TYPE), by = "SR") |>
  filter(!is.na(FUNDING_TYPE)) |>
  group_by(theme, FUNDING_TYPE) |>
  summarise(weighted_documents = sum(membership, na.rm = TRUE), .groups = "drop") |>
  group_by(theme) |>
  mutate(percent_within_theme = 100 * weighted_documents / sum(weighted_documents)) |>
  ungroup()

# sjPlot::plot_frq(M$FUNDING_TYPE)

readr::write_csv(
  theme_by_funding,
  "outputs/tables/theme_by_funding.csv"
)

capture.output(sessionInfo(), file = "outputs/session-info.txt")

message("Core analysis completed. Render the book for the guided workflow.")

