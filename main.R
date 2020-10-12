library(tercen)
library(dplyr)
library(proxy)
library(tidyr)

do.rmsd <- function(df) {
  df <- df[, !colnames(df) %in% ".ri"]
  rmsd <- function(x, y) sqrt(mean((x + y) ^ 2))
  dist.mat <- proxy::dist(df, method = rmsd)
  xy <- t(combn(1:ncol(dist.mat), 2))
  
  df_out <- data.frame(
    .ri = xy[, 1] - 1,
    dist_to = c(ctx$rselect()[[1]])[xy[, 2]],
    dist = c(dist.mat)
  )
  return(df_out)
}

(ctx = tercenCtx())  %>% 
  select(.y, .ri, .ci) %>% 
  spread(.ci, .y) %>%
  do(do.rmsd(.)) %>%
  ctx$addNamespace() %>%
  ctx$save()
