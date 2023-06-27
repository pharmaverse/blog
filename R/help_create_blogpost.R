library(stringr)
library(dplyr)
library(checkmate)
library(admiraldev)
library(rlang)


#' Function to create a new post skeleton
#'
#' @param post_name string
#' @param author string (can be vector for more authors)
#' @param post_date atomic character date in the format "%Y-%m-%d", e.g. "2023-06-15", defaults to today
#' @param description blog post description, can be left empty and filled later
#' @param image one of a set of options for default images
#' @param tags character vector, some of a set of options
#'
#' @return just a message when it worked. Side effect: creates skeleton of blogpost
#' @export
#'
#' @examples
#' create_post(post_name = "this is my new example post", author = "Stefan Thoma", cover_image = "admiral", tags = "admiral")
#'
create_post <- function(post_name,
                        author = Sys.info()["user"],
                        post_date = format(Sys.time(), "%Y-%m-%d"),
                        description = "",
                        cover_image = available_images,
                        tags = c(
                          "metadata",
                          "submission",
                          "qc",
                          "ADaMs",
                          "SDTMs",
                          "community",
                          "conferences",
                          "admiral",
                          "roak",
                          "xportr",
                          "metatools",
                          "metacore"
                        )) {


  path_to_img <- "media"
  available_images <- list.files(path_to_img) %>% tools::file_path_sans_ext()

  # Assert inputs
  admiraldev::assert_character_scalar(description)
  admiraldev::assert_character_scalar(cover_image)
  admiraldev::assert_character_scalar(post_name)
  admiraldev::assert_character_scalar(post_date)
  admiraldev::assert_character_vector(author)
  rlang::arg_match(multiple = FALSE, cover_image, values = available_images)
  rlang::arg_match(multiple = TRUE, tags)

  # check if date is correctly formatted
  if (is.na(as.Date(post_date, format = "%Y-%m-%d"))) {
    stop('`post_date` has to be in the format "%Y-%m-%d", e.g. "2023-06-15"')
  }

  # Prepare values
  snake_name <- gsub(" ", "_", tolower(gsub("(.)([A-Z])", "\\1 \\2", post_name)))
  short_name <- paste(post_date, snake_name, sep = "_")

  if (short_name != short_name %>% stringr::str_trunc(30)) {
    message("For the folder creation:")
    message(paste(short_name, "has been shortened to", short_name %>% stringr::str_trunc(30), sep = " ") %>% str_wrap())
    short_name <- paste(short_name %>% stringr::str_trunc(30), sep = " ")
  }


  # Create dir for blogpost
  new_dir <- paste("posts", short_name, sep = "/")
  if (dir.exists(new_dir)) {
    stop(paste(
      "a directory called:",
      new_dir,
      "already exists. Please work within that directory or chose a different `post_name` argument"
    ) %>%
      str_wrap())
  }
  dir.create(new_dir)

  # Read template
  lines_read <- readLines("inst/template/template.txt")

  result <- lines_read %>%
    replace(key = "TITLE", replacement = post_name) %>%
    replace(key = "AUTHOR", replacement = author) %>%
    replace(key = "DESCR", replacement = description) %>%
    replace(key = "DATE", replacement = post_date) %>%
    replace(key = "IMG", replacement = cover_image) %>%
    replace(key = "TAG", replacement = tags) %>%
    replace(key = "SLUG", replacement = short_name)


  # Write new .qmd file
  writeLines(result, con = paste(file.path(new_dir, snake_name), ".qmd", sep = ""))
  file.create(paste(file.path(new_dir, "appendix"), ".R", sep = ""))
  image_name <- paste(cover_image, ".png", sep = "")
  file.copy(from = file.path(path_to_img, image_name), to = file.path(new_dir, image_name))


  message("Congrats, you just created a new Blog Post skeleton. Find it here: ")
  message(new_dir)
}


#' Replace key with replacement
#' This is a helping function for `create_post()`
#'
#' @param text lines of template
#' @param key key to replace, one of predefined few
#' @param replacement what to replace it with, mostly user input forwarded, slightly formatted
#'
#' @return modified text
replace <- function(text, key = c("TITLE", "AUTHOR", "DESCR", "DATE", "TAG", "IMG", "SLUG"), replacement) {
  rlang::arg_match(key)

  if (key == "IMG") {
    replacement <- paste(replacement, ".png", sep = "")
  }

  # Switch to what key actually looks like
  key_with <- paste("[", key, "]", sep = "")

  # Decorate replacement
  replacement <- ifelse(
    key == "AUTHOR", paste("  - name: ", replacement, sep = ""),
    ifelse(key == "TAG", paste(replacement, collapse = ", "),
           paste('"', replacement, '"', sep = "")))


  if (key == "AUTHOR") {
    where <- str_which(
      string = text,
      pattern = fixed(key_with)
    )
    text <- append(text, values = replacement, after = where)
    text <- text[-where]
  } else {
    text <- stringr::str_replace(
      string = text,
      pattern = fixed(key_with),
      replacement = replacement
    )
  }
  return(text)
}
