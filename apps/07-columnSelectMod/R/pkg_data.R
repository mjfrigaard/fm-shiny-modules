# ===================================================#
# File name: pkg_data.R
# This is code to create: columnSelectApp (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-08
# MIT License
# Version: 0.1.0
# ===================================================#

# packages ------------------------------------------
library(shiny)
library(tidyverse)
library(reactable)
library(Lahman)

# pkg_data ----------------------------------------------------------------
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

# test -------------------------------------
# lahman_data <- pkg_data("Lahman")
# str(lahman_data)

# pkg_data("glue")

# test -------------------------------------
# ggplot2_data <- pkg_data("ggplot2")
# str(ggplot2_data)
