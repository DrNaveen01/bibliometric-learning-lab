metadata_profile <- function(M, fields = c("AU", "TI", "SO", "DE", "ID", "AB", "CR", "PY", "DI")) {
  fields <- intersect(fields, names(M))

  tibble::tibble(
    field = fields,
    available = vapply(
      fields,
      function(field) sum(!is.na(M[[field]]) & nzchar(trimws(as.character(M[[field]])))),
      integer(1)
    )
  ) |>
    dplyr::mutate(
      total = nrow(M),
      percent_available = round(100 * available / total, 1)
    )
}

age_normalised_citations <- function(M, end_year = 2025) {
  stopifnot(all(c("TC", "PY") %in% names(M)))

  M |>
    dplyr::mutate(
      citation_window = pmax(1, end_year - PY + 1),
      citations_per_year = TC / citation_window
    ) |>
    dplyr::group_by(PY) |>
    dplyr::mutate(
      year_mean_tc = mean(TC, na.rm = TRUE),
      mean_normalised_tc = dplyr::if_else(year_mean_tc > 0, TC / year_mean_tc, NA_real_)
    ) |>
    dplyr::ungroup()
}

run_thematic_map <- function(
  M,
  field = "KW_Merged",
  n = 100,
  minfreq = 5,
  cluster = "louvain",
  seed = 20261126
) {
  bibliometrix::thematicMap(
    M = M,
    field = field,
    n = n,
    minfreq = minfreq,
    ngrams = 1,
    stemming = FALSE,
    size = 0.7,
    n.labels = 3,
    community.repulsion = 0,
    repel = TRUE,
    remove.terms = fcm_remove_terms,
    synonyms = fcm_synonyms,
    cluster = cluster,
    subgraphs = TRUE,
    alpha = 0.5,
    seed = seed
  )
}

top_cluster_terms <- function(thematic_result, n_terms = 10) {
  thematic_result$words |>
    dplyr::arrange(Cluster, dplyr::desc(Cluster_PageRank), dplyr::desc(Occurrences)) |>
    dplyr::group_by(Cluster, Cluster_Label) |>
    dplyr::slice_head(n = n_terms) |>
    dplyr::ungroup()
}

theme_membership_long <- function(thematic_result) {
  membership <- thematic_result$documentToClusters
  theme_columns <- intersect(thematic_result$clusters$name, names(membership))

  if (!"SR" %in% names(membership)) {
    stop("The document-to-cluster table does not contain SR.", call. = FALSE)
  }

  membership |>
    dplyr::select(SR, dplyr::all_of(theme_columns)) |>
    tidyr::pivot_longer(
      cols = dplyr::all_of(theme_columns),
      names_to = "theme",
      values_to = "membership"
    )
}

weighted_theme_overlay <- function(thematic_result, M, variable) {
  stopifnot(variable %in% names(M))

  theme_membership_long(thematic_result) |>
    dplyr::left_join(M |> dplyr::select(SR, value = dplyr::all_of(variable)), by = "SR") |>
    dplyr::filter(!is.na(value)) |>
    dplyr::group_by(theme, value) |>
    dplyr::summarise(weighted_documents = sum(membership, na.rm = TRUE), .groups = "drop") |>
    dplyr::group_by(theme) |>
    dplyr::mutate(percent_within_theme = 100 * weighted_documents / sum(weighted_documents)) |>
    dplyr::ungroup()
}

run_network <- function(M, analysis, network, n_nodes = 40, title = NULL, seed = 20261126) {
  matrix <- bibliometrix::biblioNetwork(
    M,
    analysis = analysis,
    network = network,
    sep = ";"
  )

  plot <- bibliometrix::networkPlot(
    matrix,
    normalize = "association",
    weighted = TRUE,
    n = min(n_nodes, nrow(matrix)),
    Title = title,
    type = "fruchterman",
    size = TRUE,
    remove.multiple = FALSE,
    labelsize = 0.7,
    seed = seed
  )

  list(matrix = matrix, plot = plot, statistics = bibliometrix::networkStat(matrix))
}

