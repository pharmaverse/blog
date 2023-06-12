all_qmd <- list.files(full.names = FALSE, all.files = FALSE, pattern = ".qmd$", recursive = TRUE)
all_md <- gsub(".qmd$", ".md", all_qmd)

file.rename(all_qmd, all_md)
