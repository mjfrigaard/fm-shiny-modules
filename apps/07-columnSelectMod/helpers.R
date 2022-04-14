# ===================================================#
# File name: helpers.R
# This is code to create: columnSelectApp (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#


# packages ------------------------------------------
library(shiny)
library(tidyverse)
library(reactable)
library(Lahman)


# DESCRIPTION ----------------------------------------
# these two functions are used to create 1) a tibble of 
# dataset names, titles, and dimensions, and 2) a 
# large list of all the 'lazydata' loaded with a 
# package. 

# datasets -------------------------------------------
# this is a variation on the vcdExtra::datasets() function:
# https://github.com/friendly/vcdExtra/blob/master/R/datasets.R
datasets <- function(package, allClass = FALSE,
                     incPackage = length(package) > 1,
                     maxTitle = NULL) {
  # make sure requested packages are available and loaded
  for (i in seq_along(package)) {
    if (!isNamespaceLoaded(package[i])) {
      if (requireNamespace(package[i], quietly = TRUE)) {
        cat(paste("Loading package:", package[i], "\n"))
      } else {
        stop(paste("Package", package[i], "is not available"))
      }
    }
  }

  dsitems <- data(package = package)$results
  wanted <- c("Package", "Item", "Title")

  ds <- as.data.frame(dsitems[, wanted], stringsAsFactors = FALSE)

  getData <- function(x, pkg) {
    objname <- gsub(" .*", "", x)
    e <- loadNamespace(pkg)
    if (!exists(x, envir = e)) {
      dataname <- sub("^.*\\(", "", x)
      dataname <- sub("\\)$", "", dataname)
      e <- new.env()
      data(list = dataname, package = pkg, envir = e)
    }
    get(objname, envir = e)
  }

  getDim <- function(i) {
    data <- getData(ds$Item[i], ds$Package[i])
    if (is.null(dim(data))) length(data) else paste(dim(data), collapse = "x")
  }
  getClass <- function(i) {
    data <- getData(ds$Item[i], ds$Package[i])
    cl <- class(data)
    if (length(cl) > 1 && !allClass) cl[length(cl)] else cl
  }

  ds$dim <- unlist(lapply(seq_len(nrow(ds)), getDim))

  ds$class <- unlist(lapply(seq_len(nrow(ds)), getClass))
  if (!is.null(maxTitle)) ds$Title <- substr(ds$Title, 1, maxTitle)
  if (incPackage) {
    ds[c("Package", "Item", "class", "dim", "Title")]
  } else {
    ds[c("Item", "class", "dim", "Title")]
  }
  # named cols
  ds_cols <- select(.data = ds, 
                dataset = Item, 
                title = Title, 
                dimensions = dim)
  # observations and variables
  ds_obs_vars <- separate(data = ds_cols, 
                    col = dimensions, 
                    into = c("obs", "vars"), 
                    sep = "x", 
                    remove = FALSE)
  # title for app
  ds_out <- mutate(.data = ds_obs_vars, 
        display_title = 
            str_c(title, " (Rows = ", obs, " , Columns = ", vars, ")"))
    
  return(ds_out)

}

# pkg_data -----------------------------------------
pkg_data <- function(package) {
  pkg <- paste0("package:", package)
  if (!is.null(package)) {
    pkg_data_names <- function(package) {
      # create namespace (ns)
      ns <- asNamespace(package)
      # get namespace
      pkg_namespace <- get(".__NAMESPACE__.",
        inherits = FALSE,
        envir = asNamespace(package, base.OK = FALSE)
      )
      # get namespace information
      ns_info <- sapply(
        X = ls(pkg_namespace),
        FUN = function(x) getNamespaceInfo(ns, x)
      )
      # get all info on all items in env
      all_ns_items <- rapply(
        object = ns_info, f = ls, classes = "environment",
        how = "replace", all.names = TRUE
      )
      # extract only data
      ns_data <- all_ns_items[["lazydata"]]

      if (length(x = ns_data) < 1) {
        stop("this package has no data")
      } else {
        return_data <- ns_data[grep(".*", ns_data,
          perl = TRUE,
          ignore.case = TRUE
        )]
      }
      return(return_data)
    }
    # get names of lazydata objects from package
    names <- pkg_data_names(package = package)
    # get data from names
    data <- lapply(names, get, pkg)
    # set names to data
    named_data_list <- set_names(x = data, nm = names)
    return(named_data_list)
  } else {
    stop("please enter package name")
  }
}