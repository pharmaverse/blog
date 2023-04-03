#-------------------------- spell-check ----------------------------------------

# create empty wordlist:
# write("", file =   "../../inst/WORDLIST_EXAMPLE.txt")
# check spelling:
spelling::spell_check_files(list.files(pattern = ".*.qmd$", recursive = TRUE),
  ignore = readr::read_lines("inst/WORDLIST_EXAMPLE.txt")
)

# now check those words and whether or not they are really mistakes.
# once you fixed all mistaked you can:
words <- spelling::spell_check_files(list.files(pattern = ".*.qmd$", recursive = TRUE),
  ignore = readr::read_lines("inst/WORDLIST_EXAMPLE.txt")
)
# now you can add words to the wordlist
#-- uncomment the following line
# write(words[[1]], file =   "inst/WORDLIST_EXAMPLE.txt", append = TRUE)

spelling::spell_check_files(list.files(pattern = ".*.qmd$", recursive = TRUE),
  ignore = readr::read_lines("inst/WORDLIST_EXAMPLE.txt")
)
