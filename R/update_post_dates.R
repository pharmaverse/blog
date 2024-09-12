# Get list of post folders where date has to be edited ----
post_folders <- list.files("posts", recursive = FALSE, pattern = "new_post")

# Prepare date to replace in a blog post and folder ----
formatted_date <- format(Sys.Date(), "%Y-%m-%d")

for (folder in post_folders){

  # Update date in quarto document ----

  ##  Find qmd file with blog post ----
  blog_post <- list.files(file.path("posts", folder), recursive = FALSE, pattern = "*.qmd")
  blog_post_path <- file.path("posts", folder, blog_post)

  ## Read the quarto file ----
  lines <- readLines(blog_post_path)

  ## Identify the YAML front matter boundaries ----
  yaml_start <- which(lines == "---")[1]
  yaml_end <- which(lines == "---")[2]

  ## Check file is formatted correctly ----
  if (is.na(yaml_start) || is.na(yaml_end) || yaml_start >= yaml_end) {
    cli::cli_abort("YAML front matter not found or improperly formatted.")
  }

  ## Extract and parse the existing YAML front matter ----
  yaml_content <- paste(lines[(yaml_start + 1):(yaml_end - 1)], collapse = "\n")
  yaml_list <- yaml::yaml.load(yaml_content)

  ## Modify the post date ----
  yaml_list$date <- formatted_date

  cli::cli_inform(paste("Date updated on post:", yaml_list$title))

  ## Convert the modified YAML back to a string ----
  new_yaml_content <- yaml::as.yaml(yaml_list)

  ## Reassemble the RMarkdown file with the new YAML front matter ----
  new_lines <- c(
    lines[1 : yaml_start],
    strsplit(new_yaml_content, "\n")[[1]],
    lines[yaml_end : length(lines)]
  )

  ## Write the modified RMarkdown file back to disk ----
  writeLines(new_lines, blog_post_path)

  # Update date in folder ----
  new_folder_name <- stringr::str_replace(folder, "new_post", formatted_date)
  file.rename(file.path("posts", folder),file.path("posts", new_folder_name))

  cli::cli_inform(paste("Folder renamed for post:", yaml_list$title))

}
