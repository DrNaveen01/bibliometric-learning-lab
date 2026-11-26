# Bibliometric R Quick Reference

| Function | Prerequisite | Primary indication |
|---|---|---|
| `bibliometrix::convert2df()` | Scopus/WoS/PubMed export | Import bibliographic records |
| `bibliometrix::mergeDbSources()` | Two converted data frames | Merge databases and deduplicate |
| `bibliometrix::mergeKeywords()` | `DE` and/or `ID` | Create `KW_Merged` |
| `bibliometrix::metaTagExtraction()` | `C1` affiliations | Extract country or institution fields |
| `bibliometrix::biblioAnalysis()` | Clean bibliographic data frame | Descriptive performance analysis |
| `bibliometrix::KeywordGrowth()` | Keywords and `PY` | Topic-frequency trends |
| `bibliometrix::thematicMap()` | Clean terms and adequate frequency | Themes by centrality and density |
| `bibliometrix::thematicEvolution()` | Terms, `PY`, and stable periods | Continuation, emergence, split, and merge |
| `bibliometrix::conceptualStructure()` | Keywords, titles, or abstracts | CA/MCA/MDS conceptual map |
| `bibliometrix::biblioNetwork(..., "co-occurrences")` | Terms | Co-word network |
| `bibliometrix::biblioNetwork(..., "coupling")` | `CR` | Current research fronts |
| `bibliometrix::biblioNetwork(..., "co-citation")` | `CR` | Intellectual foundations |
| `bibliometrix::biblioNetwork(..., "collaboration")` | Authors/affiliations | Collaboration structure |
| `bibliometrix::networkPlot()` | Square network matrix | Network visualisation |
| `bibliometrix::networkStat()` | Network matrix | Structural and centrality statistics |
| `bibliometrix::histNetwork()` | `CR`, `PY`, document identifiers | Direct-citation history |
| `bibliometrix::histPlot()` | `bibliometrix::histNetwork()` result | Chronological citation map |
| `bibliometrix::citations()` | Standardised references | Local citation counts |
| `bibliometrix::timeslice()` | `PY` | Divide the corpus into periods |

## Interpretation rule

Always state the nodes, edges, normalisation, threshold, clustering algorithm, and analytical universe before interpreting a network.

