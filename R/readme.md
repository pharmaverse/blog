# Files in this folder

Some of these files help in creating/developing blog-posts, others are used by our CICD pipeline. 

- `create_blogpost.R`: use this script to create a new blogpost based on our blogpost template. 
- `CICD.R`: use this script to spellcheck and stylecheck your blogpost.
- `allowed_tags.R`: contains vector of allowed blog post tags 

## development files
- `help_create_blogpost.R`: script containing the function(s) used by `create_blogpost.R`
- `switch.R`: Used by CICD spellcheck workflow. 
- `check_post_tags.R`: Used by Check-Post-Tags CICD workflow
