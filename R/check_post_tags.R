# Get list of blog posts ----
posts <- list.files("posts", recursive = TRUE, pattern = "*.qmd")

# Function to extract tags from a post and check them against the allowed list ----
check_post_tags <- function(post) {
  allowable_tags <- c("Metadata", "SDTM", "ADaM", "TLG", "Shiny", "Community", "Conferences", "Submissions", "Technical")

  post_tags <- rmarkdown::yaml_front_matter(file.path("posts", post))$categories

  cross_check <- post_tags %in% allowable_tags

  if (!all(cross_check)) {
    stop(paste("The tags selected in:", post, "are not all from the allowed list of tags."))
  }
}

# Apply check_post_tags to all blog posts ----
invisible(lapply(posts, check_post_tags))
