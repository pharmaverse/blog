FROM rocker/rstudio:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libxml2-dev \
        libcurl4-openssl-dev \
        zlib1g-dev \
        libfontconfig1-dev \
        libharfbuzz-dev libfribidi-dev \
        libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
        libmbedtls-dev cmake \
        libnng-dev xz-utils\
        libcairo2-dev \
        libgit2-dev \
        pkgconf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -o quarto.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.42/quarto-1.6.42-linux-arm64.deb \
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
        "pharmaverseadam", \
        "link", \
        "sessioninfo", \
        "rtables", \
        "teal", \
        "riskmetric", \
        "tidyCDISC", \
        "mirai", \
        "dverse", \
        "DT", \
        "xportr", \
        "sdtm.oak", \
        "teal", \
        "riskmetric", \
        "tidyCDISC", \
        "admiralonco", \
        "admiralophtha", \
        "admiralpeds", \
        "admiralvaccine", \
        "admiralmetabolic"))'
