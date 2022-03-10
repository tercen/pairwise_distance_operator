library(tercen)
library(dplyr)
library(proxy)
library(tidyr)

do.dist <- function(df, method) {
  
  df <- df[, !colnames(df) %in% ".ri"]
  if(method == "rmsd") method <- eval(parse(text = "rmsd"))
  dist.mat <- proxy::dist(df, method = method, diag = TRUE)
  
  mat <- as.data.frame(as.matrix(dist.mat))
  mat$.ri <- 1:nrow(mat) - 1L
  mat <- mat %>% gather(dist_to, dist, -.ri)
  mat$dist_to <- as.numeric(mat$dist_to) - 1 
  
  return(mat)
}

ctx <- tercenCtx()

rmsd <- function(x, y) sqrt(mean((x + y)^2))

#method <- "euclidean" #rmsd "euclidean" "maximum", "manhattan", "canberra", "binary" or "minkowski"
if(!is.null(ctx$op.value('method'))) method <- ctx$op.value('method')

df_out <- ctx %>% 
  select(.y, .ri, .ci) %>% 
  spread(.ci, .y) %>%
  do(do.dist(., method)) 

rnames <- ctx$rselect(ctx$rnames[[1]])[[1]]

df_out %>%
  mutate(dist_to = rnames[dist_to + 1]) %>%
  ctx$addNamespace() %>%
  ctx$save()