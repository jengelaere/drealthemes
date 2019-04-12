primary <- c("primary_active" = "#00465a", "primary" = "#008ca0", "primary_light" = "#00bebe")
secondary <- c("secondary_active" = "#3c0064", "secondary" = "#5a1e82", "secondary_light" = "#8246aa")
info <- c("info_active" = "#a0a0a0", "info" = "#b4b4b4", "info_light" = "#d2d2d2")
success <- c("success_active" = "#a0c83c", "success" = "#b4dc50", "success_light" = "#c8f064")
warning <- c("warning_active" = "#f59600", "warning" = "#ffd200", "warning_light" = "#fff000")
danger <- c("danger_active" = "#b4003c", "danger" = "#eb3273", "danger_light" = "#ff6e9b")

dreal_colors <- c(secondary, primary, warning, danger, success, info)[
  c(seq(1, 3*6, 3), seq(2, 3*6, 3), seq(3, 3*6, 3))]

#' Show vector of main colors
#' @export
#' @examples
#' dreal_main_colors()
dreal_main_colors <- function() {dreal_colors}

#' Show palette of colors
#'
#' @param cols vector of colors. Can be named vector.
#' @param cols_names names of colors if cols not named vector
#' @param nrow number of rows of the graph output
#' @param ncol number of cols of the graph output
#' @param show_text Logical. Whether to show cols_names
#'
#' @export
#' @importFrom tibble tibble
#' @importFrom ggplot2 ggplot aes geom_tile geom_text scale_fill_manual guides theme_void
#' @importFrom stats setNames
#'
#' @examples
#' show_pal(cols = dreal_pal("continuous")(6), show_text = FALSE)
show_pal <- function(cols, cols_names, nrow = 1, ncol = length(cols), show_text = TRUE) {

  if (nrow*ncol != length(cols)) {stop("length(cols) should equals nrow*ncol")}
  if (missing(cols_names) & !is.null(names(cols))) {
    cols_names <- names(cols)
  } else if ((missing(cols_names) & is.null(names(cols)))) {
    cols_names <- as.character(1:length(cols))
  }


  tibble(
    x = rep(1:ncol, each = nrow),
    y = rep(1:nrow, times = ncol),
    names = cols_names,
    colors = cols) %>%
    ggplot() +
    aes(x, y, fill = names) +
    geom_tile() +
    {if (isTRUE(show_text)) {geom_text(aes(label = names))}} +
    scale_fill_manual(values = setNames(cols, cols_names)) +
    guides(fill = FALSE) +
    theme_void()
}

#' Function to extract dreal colors as hex codes
#'
#' @param ... Character names of dreal_colors
#'
#' @export
#'
#' @examples
#' dreal_cols("primary", "danger")
dreal_cols <- function(...) {
  cols <- c(...)

  if (is.null(cols))
    return(dreal_colors)

  dreal_colors[cols]
}

dreal_palettes <- list(
  # continuous
  primary = dreal_cols("primary_active", "primary", "primary_light"),
  secondary = dreal_cols("secondary_active", "secondary", "secondary_light"),
  info = dreal_cols("info_active", "info", "info_light"),
  success = dreal_cols("success_active", "success", "success_light"),
  warning = dreal_cols("warning_active", "warning", "warning_light"),
  danger = dreal_cols("danger_active", "danger", "danger_light"),
  continuous = dreal_cols(paste0("warning", c("_light", "", "_active")), paste0("danger", c("_light", "", "_active"))),
  # discrete
  active = dreal_cols(paste0(c("secondary", "primary", "warning", "danger", "success", "info"), "_active")),
  normal = dreal_cols(c("secondary", "primary", "warning", "danger", "success", "info")),
  light = dreal_cols(paste0(c("secondary", "primary", "warning", "danger", "success", "info"), "_light")),
  discrete = dreal_cols("secondary_light", "primary_light", "warning", "danger_light", "success", "info"),
  discrete2 = dreal_cols("secondary_light", "primary_light", "warning", "success", "danger_light", "info"),
  discrete_long = c(dreal_cols(paste0(c("secondary", "primary", "warning", "danger", "success", "info"), "_active")),
                    dreal_cols(c("secondary", "primary", "warning", "danger", "success", "info")),
                    dreal_cols(paste0(c("secondary", "primary", "warning", "danger", "success", "info"), "_light"))
  )
)

#' List dreal palettes available with recommended type
#'
#' @export
#' @examples
#' list_dreal_pals()
list_dreal_pals <- function() {
  data.frame(type = c(rep("continuous", 7), rep("discrete", 6)),
             palette = names(dreal_palettes),
             length = unlist(lapply(dreal_palettes, length)))
}

#' Return function to interpolate a dreal color palette
#'
#' @param palette Character name of palette in dreal_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments to pass to colorRampPalette()
#'
#' @export
#' @importFrom grDevices colorRampPalette
#'
#' @examples
#' dreal_pal("continuous")(6)
dreal_pal <- function(palette = "continuous", reverse = FALSE, ...) {
  pal <- dreal_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  colorRampPalette(pal, ...)
}
