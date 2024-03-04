# You can easily create a new blog post skeleton using the create_post() function.
# First, we load the helping function:

source("R/help_create_blogpost.R")


## The available images are at the moment:
list.files("media") %>% tools::file_path_sans_ext()
## Please choose (possibly multiple) from this tags list:
c(
  "metadata", "submission", "qc", "ADaMs", "SDTMs", "community",
  "conferences", "admiral", "roak", "xportr", "metatools", "metacore",
  "displays", "falcon"
)

# Fill in the info, e.g.:
create_post(
  post_name = "Inside the Pharmaverse", # needs to be character vector (length 1)
  post_date = "2024-03-04", # needs to be character vector (length 1)
  description = "A short blog to help the Pharmaverse community understand how Pharmaverse is governed", # you can fill the description in later as well
  author = c("Michael Rimler", "Ross Farrugia", "Mike Stackhouse", "Sumesh Kalappurakal", "Ari Siggaard Knoph"), # one or more authors are permitted
  cover_image = "pharmaverse", # chose one of the above (see line 8)
  tags = c("community") # chose (multiple) from line 10
)


# Remove that post:
# unlink("posts/2023-06-15_lbla", recursive = TRUE)

# Note that the folder and file created do not correspond directly to the `post_name` argument.
# This allows for a longer `post_name` without having super long file-names.
