required_packages <- c(
  "bibliometrix", "dplyr", "tidyr", "stringr", "purrr",
  "readr", "ggplot2", "tibble", "scales"
)

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Install required packages first: ",
    paste(missing_packages, collapse = ", "),
    "\nRun: Rscript install_packages.R",
    call. = FALSE
  )
}

if (utils::compareVersion(as.character(packageVersion("bibliometrix")), "5.5.0") < 0) {
  stop(
    "bibliometrix 5.5.0 or later is required for graded document-theme membership.\n",
    "Run: Rscript install_packages.R",
    call. = FALSE
  )
}

suppressPackageStartupMessages({
  library(bibliometrix)
  library(dplyr)
  library(tidyr)
  library(stringr)
  library(purrr)
  library(readr)
  library(ggplot2)
  library(tibble)
  library(scales)
})

dir.create("data", showWarnings = FALSE, recursive = TRUE)
dir.create("outputs/figures", showWarnings = FALSE, recursive = TRUE)
dir.create("outputs/tables", showWarnings = FALSE, recursive = TRUE)

source(here::here("R", "01_generate_demo_data.R"))
source(here::here("R", "03_cleaning_dictionary.R"))

theme_set(theme_minimal(base_size = 12))

