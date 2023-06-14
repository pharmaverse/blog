# you can easily create a new blog post skeleton using the create_post() function.
# first, we load the helping function:

source("R/help_create_blogpost.R")

# Fill in the info, e.g.:

create_post(
  post_name = "lbla",
  post_date = format(Sys.time(), "%Y-%m-%d"),
  description = "",
  author = "Stefan Thoma",
  cover_image = "admiral",
  tags = "admiral"
)
