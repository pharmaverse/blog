{
    library("mirai")
    library("dplyr", warn.conflicts = FALSE)
    log_file <- tempfile()
    mirai::daemons(4)
    mirai::everywhere({
        library("dplyr", warn.conflicts = FALSE)
        library("tidylog", warn.conflicts = FALSE)
        log_to_file <- function(txt) cat(txt, file = log_file, 
            sep = "\n", append = TRUE)
        options(tidylog.display = list(message, log_to_file))
    }, log_file = log_file)
    m <- mirai_map(letters[1:5], function(x) {
        mutate(tidyr::tibble(.rows = 1), `:=`("{x}", "foo"))
    })
    result <- dplyr::bind_cols(m[])
    mirai::daemons(0)
    print(list(logs = readLines(log_file), result = result))
}
