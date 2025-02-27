# Load required packages
library(spelling)
library(readr)
library(stringr)
library(dplyr)

#-------------------------- Spell-check Without Modifying Files --------------------------

# Function to read and clean text (remove URLs in-memory)
clean_text_for_spellcheck <- function(file) {
  text <- read_lines(file)
  text_clean <- str_replace_all(text, "https?://[^\\s)\"']+", "")  # Remove URLs
  return(text_clean)
}

# Get all .qmd files
qmd_files <- list.files(pattern = ".*\\.qmd$", recursive = TRUE)

# Run spell check per file and store results
spell_check_results <- lapply(qmd_files, function(file) {
  cleaned_text <- clean_text_for_spellcheck(file)
  words <- spelling::spell_check_text(cleaned_text, ignore = read_lines("inst/WORDLIST.txt"))

  if (nrow(words) > 0) {
    words$file <- file  # Add filename column
  }

  return(words)
})

# Combine results into a single dataframe
all_typos <- bind_rows(spell_check_results)

# Print results
if (nrow(all_typos) > 0) {
  print(all_typos %>% select(file, word, line))
} else {
  message("No spelling errors found!")
}

#-------------------------- Add Words to Wordlist (If Needed) --------------------------

# Uncomment if you want to manually add words to the wordlist
# write(all_typos$word, file = "inst/WORDLIST.txt", append = TRUE)
# sort_words <- sort(read_lines("inst/WORDLIST.txt"))
# write_lines(sort_words, "inst/WORDLIST.txt")

#-------------------------- Style-check ----------------------------------------

# This is what happens in CI/CD:
styler::style_dir(dry = "fail")

# Fix it locally:
styler::style_dir()

# Now it should pass:
styler::style_dir(dry = "fail")
