---
title: "Check Links"
author:
  - name: Stefan Thoma

description: "Just here to verify whether CICD runs properly"
date: "2024-05-16"
categories: [CICD]
image: "admiral.png"
link-function: true

---

<!--------------- my typical setup ----------------->



```{r setup, include=FALSE}
long_slug <- "2023-05-16_link"

# renv::use(lockfile = "renv.lock")
```


<!--------------- post begins here ----------------->

Lets write some links down: 

how about: `dplyr::select()`
does [this](www.google.com) work? It should.

what about [that](https://gobledigook.com/blablabla)? this link does not work.

Let's see what happens [with 404 errors](https://www.apple.com/iphony):




<!--------------- appendices go here ----------------->

```{r, echo=FALSE}
source("appendix.R")
insert_appendix(
  repo_spec = "StefanThoma/quarto-blog",
  name = long_slug
)
```


