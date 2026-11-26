required <- c(
  "bibliometrix",
  "bibliometrixData",
  "dplyr",
  "tidyr",
  "stringr",
  "purrr",
  "readr",
  "ggplot2",
  "tibble",
  "scales",
  "knitr",
  "rmarkdown",
  "renv"
)

installed <- rownames(installed.packages())
missing <- setdiff(required, installed)

if (length(missing) > 0) {
  install.packages(missing, repos = "https://cloud.r-project.org")
}

if (
  requireNamespace("bibliometrix", quietly = TRUE) &&
    utils::compareVersion(as.character(packageVersion("bibliometrix")), "5.5.0") < 0
) {
  install.packages("bibliometrix", repos = "https://cloud.r-project.org")
}

message("Required R packages are available.")
message("Run quarto preview from the project root.")

