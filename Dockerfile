FROM rocker/rstudio:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -o quarto.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.550/quarto-1.4.550-linux-amd64.deb \
    && dpkg --install quarto.deb \
    && rm -f quarto.deb \
    && R -e 'install.packages(c( \
        "jsonlite", \
        "tidyverse", \
        "spelling", \
        "janitor", \
        "diffdf", \
        "admiral", \
        "patchwork", \
        "here", \
        "reactable", \
        "pharmaversesdtm", \
        "metacore", \
        "metatools", \
        "xportr", \
        "pharmaverseadam"))'
