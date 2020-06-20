library(tercen)
library(dplyr)
library(proxy)
library(tidyr)

options("tercen.workflowId" = "a2ac2439e77ba78ceb8f9be37d016b99")
options("tercen.stepId"     = "cc19cb50-bb55-4986-8625-223e1f619dd8")

getOption("tercen.workflowId")
getOption("tercen.stepId")

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

