generate_fcm_demo <- function(n = 260, seed = 20261126) {
  set.seed(seed)

  year_values <- 2008:2025
  year_weights <- seq_along(year_values)^1.45
  years <- sort(sample(year_values, n, replace = TRUE, prob = year_weights))

  theme_definitions <- list(
    heart_failure = list(
      indication = "Heart failure",
      population = "Adults with heart failure and iron deficiency",
      keywords = c(
        "heart failure", "iron deficiency", "exercise capacity",
        "hospitalisation", "quality of life", "left ventricular ejection fraction",
        "six-minute walk test", "functional status"
      ),
      journals = c("European Heart Journal", "JACC Heart Failure", "Heart"),
      countries = c("Germany", "Poland", "United Kingdom", "United States", "Spain"),
      institutions = c("Berlin Heart Centre", "Warsaw Medical University", "London Cardiac Institute")
    ),
    pregnancy = list(
      indication = "Pregnancy and postpartum anaemia",
      population = "Pregnant or postpartum women with anaemia",
      keywords = c(
        "pregnancy", "maternal anaemia", "postpartum", "birth weight",
        "antenatal care", "haemoglobin", "second trimester", "maternal health"
      ),
      journals = c("The Lancet Global Health", "BJOG", "International Journal of Gynaecology and Obstetrics"),
      countries = c("India", "Malawi", "Australia", "United Kingdom", "Kenya"),
      institutions = c("Patna Institute of Medical Sciences", "Malawi Maternal Health Centre", "Melbourne Women's Hospital")
    ),
    chronic_kidney_disease = list(
      indication = "Chronic kidney disease",
      population = "Adults with chronic kidney disease or receiving dialysis",
      keywords = c(
        "chronic kidney disease", "renal anaemia", "haemodialysis",
        "erythropoietin", "estimated glomerular filtration rate", "dialysis",
        "renal replacement therapy", "haemoglobin response"
      ),
      journals = c("Kidney International", "Clinical Kidney Journal", "Nephrology Dialysis Transplantation"),
      countries = c("United States", "Japan", "Germany", "India", "Canada"),
      institutions = c("Boston Renal Institute", "Tokyo Kidney Centre", "Delhi Nephrology Institute")
    ),
    inflammatory_bowel_disease = list(
      indication = "Inflammatory bowel disease",
      population = "Adults with inflammatory bowel disease and iron-deficiency anaemia",
      keywords = c(
        "inflammatory bowel disease", "Crohn disease", "ulcerative colitis",
        "gastroenterology", "haemoglobin", "disease activity", "fatigue",
        "ferritin"
      ),
      journals = c("Gut", "Journal of Crohn's and Colitis", "Inflammatory Bowel Diseases"),
      countries = c("Austria", "Germany", "Spain", "United Kingdom", "Denmark"),
      institutions = c("Vienna Gastroenterology Centre", "Barcelona Digestive Institute", "Copenhagen IBD Centre")
    ),
    safety = list(
      indication = "Safety and phosphate metabolism",
      population = "Patients receiving intravenous iron",
      keywords = c(
        "hypophosphataemia", "fibroblast growth factor 23", "phosphate",
        "osteomalacia", "adverse events", "vitamin D", "bone metabolism",
        "renal phosphate wasting"
      ),
      journals = c("Bone", "Clinical Nutrition", "Drug Safety"),
      countries = c("Switzerland", "United States", "Austria", "Germany", "Netherlands"),
      institutions = c("Zurich Bone Research Centre", "Chicago Metabolic Institute", "Amsterdam Safety Unit")
    ),
    health_economics = list(
      indication = "Health economics and implementation",
      population = "Health-system populations eligible for intravenous iron",
      keywords = c(
        "cost effectiveness", "health economics", "resource use", "implementation",
        "quality-adjusted life year", "budget impact", "hospital stay", "health services"
      ),
      journals = c("Value in Health", "Pharmacoeconomics", "BMC Health Services Research"),
      countries = c("United Kingdom", "Canada", "Australia", "Germany", "India"),
      institutions = c("York Health Economics Centre", "Toronto Outcomes Institute", "Sydney Health Policy Unit")
    ),
    perioperative = list(
      indication = "Perioperative anaemia",
      population = "Adults undergoing major surgery",
      keywords = c(
        "perioperative anaemia", "patient blood management", "surgery",
        "transfusion", "preoperative optimisation", "postoperative recovery",
        "blood loss", "length of stay"
      ),
      journals = c("British Journal of Anaesthesia", "Anaesthesia", "Surgery"),
      countries = c("France", "United Kingdom", "Australia", "India", "Italy"),
      institutions = c("Paris Surgical Research Centre", "Oxford Anaesthesia Unit", "Rome Perioperative Institute")
    )
  )

  choose_theme <- function(year) {
    probabilities <- if (year <= 2012) {
      c(0.42, 0.05, 0.33, 0.12, 0.03, 0.01, 0.04)
    } else if (year <= 2017) {
      c(0.30, 0.15, 0.20, 0.15, 0.08, 0.04, 0.08)
    } else if (year <= 2021) {
      c(0.25, 0.17, 0.12, 0.13, 0.17, 0.07, 0.09)
    } else {
      c(0.24, 0.22, 0.08, 0.08, 0.20, 0.11, 0.07)
    }

    sample(names(theme_definitions), 1, prob = probabilities)
  }

  themes <- vapply(years, choose_theme, character(1))

  author_pool <- c(
    "PATEL A", "SHARMA N", "SINGH R", "MULLER K", "SCHMIDT L",
    "KOWALSKI M", "BROWN T", "WILSON P", "MARTIN C", "GARCIA J",
    "ROSSI F", "KIM H", "TANAKA Y", "O'NEILL D", "CHEN X",
    "KUMAR S", "ADEYEMI B", "PHIRI L", "JONES E", "ANDERSEN R"
  )

  design_values <- c(
    "Randomised controlled trial", "Prospective cohort", "Retrospective cohort",
    "Systematic review", "Economic evaluation", "Cross-sectional study"
  )

  common_keywords <- c(
    "ferric carboxymaltose", "intravenous iron", "iron-deficiency anaemia",
    "treatment", "efficacy", "safety"
  )

  external_references <- c(
    "FOUNDATION A, 2007, IRON THERAPY REV, V1, P1",
    "FOUNDATION B, 2009, CLIN HAEMATOL, V12, P101",
    "FOUNDATION C, 2011, INT J IRON RES, V4, P55"
  )

  rows <- vector("list", n)
  prior_sr <- character(0)
  prior_theme <- character(0)

  for (i in seq_len(n)) {
    year <- years[[i]]
    theme <- themes[[i]]
    definition <- theme_definitions[[theme]]

    number_authors <- sample(3:7, 1)
    authors <- sample(author_pool, number_authors, replace = FALSE)
    first_author <- sub(" .*", "", authors[[1]])

    number_countries <- sample(1:min(3, length(definition$countries)), 1, prob = c(0.62, 0.28, 0.10))
    countries <- sample(definition$countries, number_countries, replace = FALSE)
    institutions <- sample(definition$institutions, min(number_countries, length(definition$institutions)), replace = FALSE)

    journal <- sample(definition$journals, 1)
    journal_short <- toupper(gsub("[^A-Z]", "", substr(journal, 1, 18)))
    sr <- paste(first_author, year, journal_short, sprintf("V%03d", i), sep = ", ")

    design_probability <- if (theme == "health_economics") {
      c(0.05, 0.10, 0.15, 0.10, 0.55, 0.05)
    } else {
      c(0.34, 0.22, 0.15, 0.14, 0.06, 0.09)
    }
    design <- sample(design_values, 1, prob = design_probability)

    focus <- sample(c("Efficacy", "Safety", "Implementation", "Comparative effectiveness"), 1,
      prob = if (theme == "safety") c(0.08, 0.76, 0.08, 0.08) else c(0.48, 0.19, 0.13, 0.20)
    )

    theme_keywords <- sample(definition$keywords, 5, replace = FALSE)
    keywords <- unique(c("ferric carboxymaltose", theme_keywords, sample(common_keywords, 2)))
    index_keywords <- unique(c(theme_keywords[1:3], "iron deficiency", "parenteral therapy", focus))

    title_stem <- sample(c(
      "Effectiveness and safety of ferric carboxymaltose in",
      "Clinical outcomes after ferric carboxymaltose for",
      "A multicentre assessment of intravenous iron in",
      "Ferric carboxymaltose compared with standard care for",
      "Real-world use of ferric carboxymaltose in"
    ), 1)
    title <- paste(title_stem, tolower(definition$indication))

    same_theme_indices <- which(prior_theme == theme)
    local_refs <- if (length(same_theme_indices) > 0) {
      sample(prior_sr[same_theme_indices], min(3, length(same_theme_indices)), replace = FALSE)
    } else {
      character(0)
    }
    cross_refs <- if (length(prior_sr) > 4) sample(prior_sr, 2, replace = FALSE) else character(0)
    references <- unique(c(sample(external_references, 2), local_refs, cross_refs))

    funding_type <- sample(
      c("Industry", "Non-industry", "Mixed", "No external funding", "Unreported"),
      1,
      prob = c(0.37, 0.27, 0.13, 0.08, 0.15)
    )
    funder <- switch(
      funding_type,
      Industry = "Synthetic Pharma Research Fund",
      `Non-industry` = "National Health Research Council",
      Mixed = "Synthetic Pharma Research Fund;National Health Research Council",
      `No external funding` = "No external funding",
      Unreported = NA_character_
    )

    age <- 2026 - year
    expected_citations <- max(1, age * ifelse(design == "Randomised controlled trial", 3.0, 1.7))
    total_citations <- rpois(1, expected_citations)

    abstract <- paste(
      "This", tolower(design), "examined", tolower(definition$indication),
      "with emphasis on", paste(theme_keywords[1:3], collapse = ", "),
      "and", tolower(focus), "."
    )

    affiliation <- paste(
      paste(rep(institutions, length.out = number_countries), countries, sep = ", "),
      collapse = ";"
    )

    rows[[i]] <- tibble::tibble(
      AU = paste(authors, collapse = ";"),
      AF = paste(authors, collapse = ";"),
      TI = title,
      SO = journal,
      JI = journal_short,
      DT = ifelse(design == "Systematic review", "REVIEW", "ARTICLE"),
      DE = paste(keywords, collapse = ";"),
      ID = paste(index_keywords, collapse = ";"),
      AB = abstract,
      C1 = affiliation,
      AU_CO = paste(countries, collapse = ";"),
      AU_UN = paste(rep(institutions, length.out = number_countries), collapse = ";"),
      CR = paste(references, collapse = ";"),
      TC = total_citations,
      PY = year,
      DI = sprintf("10.9999/fcm.demo.%04d", i),
      UT = sprintf("DEMO:%04d", i),
      SR = sr,
      DB = "DEMO",
      LA = "English",
      FU = funder,
      INDICATION = definition$indication,
      POPULATION = definition$population,
      DESIGN = design,
      STUDY_FOCUS = focus,
      FUNDING_TYPE = funding_type,
      RECRUITMENT_COUNTRY = paste(countries, collapse = ";"),
      REFERENCE_THEME = theme
    )

    prior_sr <- c(prior_sr, sr)
    prior_theme <- c(prior_theme, theme)
  }

  dplyr::bind_rows(rows)
}

load_demo_data <- function(regenerate = FALSE, n = 260, seed = 20261126) {
  rds_path <- "data/fcm_demo.rds"
  csv_path <- "data/fcm_demo.csv"

  if (regenerate || !file.exists(rds_path)) {
    demo <- generate_fcm_demo(n = n, seed = seed)
    saveRDS(demo, rds_path)
    readr::write_csv(demo, csv_path, na = "")
  }

  readRDS(rds_path)
}

