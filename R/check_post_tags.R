# Get list of blog posts ----
posts <- list.files("posts", recursive = TRUE, pattern = "*.qmd")

# Get vector of allowed tags ----
source("R/allowed_tags.R")

# Function to extract tags from a post and check them against the allowed list ----
check_post_tags <- function(post, allowed_post_tags = allowed_tags) {
  post_tags <- rmarkdown::yaml_front_matter(file.path("posts", post))$categories

  cross_check <- post_tags %in% allowed_post_tags

  problematic_tags <- post_tags[!cross_check]

  if (!all(cross_check)) {
    cli::format_message("The tag(s) {.val {problematic_tags}} in the post {.val {post}} are not from the allowable list of tags.")
  }
}

# Apply check_post_tags to all blog posts and find problem posts ----
check_results <- lapply(posts, check_post_tags)
error_messages <- unlist(Filter(Negate(is.null), check_results))

# Construct error message if one or more posts have problematic tags ----
if (length(error_messages) > 0) {
  error_messages <- c(error_messages, "Please select from the following tags: {.val {allowed_tags}}, or contact one of the maintainers.")
  names(error_messages) <- rep("x", length(error_messages) - 1)

  concatenated_error_messages <- cli::cli_bullets(error_messages)

  cli::cli_abort(concatenated_error_messages)
}
