# Copy this script before editing it for a real project.
# Database exports may be subject to licence restrictions.

library(bibliometrix)

# Scopus BibTeX export
scopus_file <- "data-raw/scopus_export.bib"

M_scopus <- bibliometrix::convert2df(
  file = scopus_file,
  dbsource = "scopus",
  format = "bibtex",
  remove.duplicates = TRUE
)

# Web of Science plain-text export
wos_file <- "data-raw/savedrecs.txt"

M_wos <- bibliometrix::convert2df(
  file = wos_file,
  dbsource = "wos",
  format = "plaintext",
  remove.duplicates = TRUE
)

# Merge only when both sources are part of the protocol.
M_merged <- bibliometrix::mergeDbSources(
  M_scopus,
  M_wos,
  remove.duplicated = TRUE
)

saveRDS(M_merged, "data/real_bibliographic_data.rds")

