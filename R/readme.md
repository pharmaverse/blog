# Files in this folder

Some of these files help in creating/developing blog-posts, others are used by our CICD pipeline. 

- `create_blogpost.R`: use this script to create a new blogpost based on our blogpost template. 
- `CICD.R`: use this script to spellcheck and stylecheck your blogpost.

## development files
- `help_create_blogpost.R`: script containing the function(s) used by `create_blogpost.R`
- `switch.R`: Used by CICD spellcheck workflow. 

# Workflow: 

To create a new Blog Post, please open the `create_blogpost.R` file. 
Source the script `help_create_blogpost.R` using the `create_blogpost.R` file. 
We created a function that sets up a new blogpost using a template. 
You can use the `create_post` and fill in the information according to your requirements. 
Running that function will create a subfolder in the `posts/` folder. 
It should be named based on the supplied `post_date` and `post_name` information. 
Open the folder and start working within the `*.qmd` file. 

Please note that we do not currently allow users to specify their own categories (or `tags`), so you must chose (possibly several) from this list: `c("metadata", "submission", "qc", "ADaMs", "SDTMs", "community", "conferences", "admiral", "roak", "xportr", "metatools", "metacore")`.

After you have finished your Blog Post, open the `CICD.R` file in the `R/` folder. 
Run the script line by line to first check the spelling in your post and then to make sure your code is compatible with our code-style. 

When done, push to your branch, create a Pull Request, and review the Spirit of the Blog Post in the Pull Request Template.

Have fun! 



