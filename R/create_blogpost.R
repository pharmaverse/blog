# you can easily create a new blog post skeleton using the create_post() function.
# first, we load the helping function:

source("R/help_create_blogpost.R")

# Fill in the info, e.g.:

create_post(
  post_name = "lbla",
  post_date = "2023-06-15",
  description = "",
  author = "Stefan Thoma",
  cover_image = "admiral",
  tags = "admiral"
)


# remove that post:
unlink("posts/2023-06-15_lbla", recursive = TRUE)
