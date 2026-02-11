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
#' create_post(post_name = "this is my new example post", author = "Stefan Thoma", cover_image = "admiral", tags = "ADaM")
#' create_post(post_name = "My Blog Post... with special chars!", author = "Jules", cover_image = "admiral", tags = "Community")
#'
create_post <- function(post_name,
                        author = Sys.info()["user"],
                        post_date = format(Sys.time(), "%Y-%m-%d"),
                        description = "",
                        cover_image = available_images,
                        tags = c("Metadata", "SDTM", "ADaM", "TLG", "Shiny", "Community", "Conferences", "Submissions", "Technical")) {
  path_to_img <- "media"
  # Define available_images here so it's always accessible when 'cover_image' is evaluated
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

  # Helper function to sanitize names for file/folder creation
  clean_filename <- function(text) {
    text <- tolower(text)
    # Replace any character that is NOT a lowercase letter (a-z), digit (0-9), or hyphen (-) with a hyphen.
    text <- gsub("[^a-z0-9-]+", "-", text)
    # Replace sequences of multiple hyphens with a single hyphen.
    text <- gsub("-+", "-", text)
    # Remove any leading or trailing hyphens.
    text <- gsub("^-|-$", "", text)
    return(text)
  }

  # Sanitize the post_name for the .qmd file name (e.g., my-blog-post-with-special-chars)
  sanitized_post_name <- clean_filename(post_name)

  # For the .qmd filename, we only need the sanitized post_name part
  snake_name <- sanitized_post_name

  # For the folder name, combine the post_date with the sanitized post_name
  date_for_folder <- clean_filename(post_date)
  base_short_name_for_dir <- paste(date_for_folder, sanitized_post_name, sep = "-")

  # Handle truncation for the directory name, applying the original length limit
  final_short_name_for_dir <- base_short_name_for_dir
  if (nchar(base_short_name_for_dir) > 30) {
    message("For the folder creation:")
    # Truncate the name to 30 characters without adding an ellipsis.
    truncated_version <- stringr::str_trunc(base_short_name_for_dir, 30, side = "right", ellipsis = "")
    # Remove any trailing hyphen that might have resulted from truncation.
    final_short_name_for_dir <- gsub("-$", "", truncated_version)
    message(paste(base_short_name_for_dir, "has been shortened to", final_short_name_for_dir, sep = " ") %>% str_wrap())
  }

  # 'short_name' will be used for the directory name
  short_name <- final_short_name_for_dir

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

  # --- MODIFICATION: Calls to 'replace' are now calls to 'blogpost_replace' ---
  result <- lines_read %>%
    blogpost_replace(key = "TITLE", replacement = post_name) %>%
    blogpost_replace(key = "AUTHOR", replacement = author) %>%
    blogpost_replace(key = "DESCR", replacement = description) %>%
    blogpost_replace(key = "DATE", replacement = post_date) %>%
    blogpost_replace(key = "IMG", replacement = cover_image) %>%
    blogpost_replace(key = "TAG", replacement = tags) %>%
    blogpost_replace(key = "SLUG", replacement = short_name)


  # Write new .qmd file
  writeLines(result, con = paste(file.path(new_dir, snake_name), ".qmd", sep = ""))
  file.copy("inst/template/appendix.R", paste(file.path(new_dir, "appendix"), ".R", sep = ""))
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
# --- MODIFICATION: Renamed function from 'replace' to 'blogpost_replace' ---
blogpost_replace <- function(text, key = c("TITLE", "AUTHOR", "DESCR", "DATE", "TAG", "IMG", "SLUG"), replacement) {
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
      paste('"', replacement, '"', sep = "")
    )
  )


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
