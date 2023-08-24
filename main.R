library(tercen)
library(dplyr)
library(proxy)
library(tidyr)

do.dist <- function(df, method) {
  
  df <- df[, !colnames(df) %in% ".ri"]
  if(method %in% c("rmsd", "spearman", "pearson", "kendall")) {
    method <- switch(
      method,
      "rmsd" = rmsd,
      "spearman" = spearman,
      "pearson" = pearson,
      "kendall" = kendall
    )
  }
  dist.mat <- proxy::dist(df, method = method, diag = TRUE)
  
  mat <- as.data.frame(as.matrix(dist.mat))
  mat$.ri <- 1:nrow(mat) - 1L
  mat <- mat %>% gather(dist_to, dist, -.ri)
  mat$dist_to <- as.numeric(mat$dist_to) - 1 
  
  return(mat)
}

ctx <- tercenCtx()

rmsd <- function(x, y) sqrt(mean((x + y)^2))

missing_data_behaviour <- ctx$op.value('missing_data_behaviour', as.character, "na.or.complete")
pearson <- function(x, y) cor(x, y, method = "pearson", use = missing_data_behaviour)
kendall <- function(x, y) cor(x, y, method = "kendall", use = missing_data_behaviour)
spearman <- function(x, y) cor(x, y, method = "spearman", use = missing_data_behaviour)

method <- ctx$op.value('method', as.character, "pearson")

df_out <- ctx %>% 
  select(.y, .ri, .ci) %>% 
  spread(.ci, .y) %>%
  do(do.dist(., method)) 

rnames <- ctx$rselect(ctx$rnames[[1]])[[1]]

df_out %>%
  mutate(dist_to = rnames[dist_to + 1]) %>%
  ctx$addNamespace() %>%
  ctx$save()