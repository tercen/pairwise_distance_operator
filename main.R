library(tercen)
library(dplyr)
library(proxy)
library(tidyr)

do.rmsd <- function(df) {
  df <- df[, !colnames(df) %in% ".ci"]
  rmsd <- function(x, y) sqrt(mean((x + y)^2))
  
  dist.mat <- proxy::dist(df, method = rmsd)
  xy <- t(combn(1:ncol(dist.mat),2))
  
  out <- data.frame(
    .ri = xy[, 1],
    from = c(ctx$rselect()[[1]])[xy[, 1]],
    to = c(ctx$rselect()[[1]])[xy[, 2]],
    dist = c(dist.mat)
  )
  return(out)
}

(ctx = tercenCtx())  %>% 
  select(.y, .ri, .ci) %>% 
  spread(.ri, .y) %>%
  do(do.rmsd(.)) %>%
  ctx$addNamespace() %>%
  ctx$save()