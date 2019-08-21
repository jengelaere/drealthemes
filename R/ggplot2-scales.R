#' Continuous color scale constructor for dreal colors
#'
#' @param palette Character name of palette in dreal_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to \code{ggplot2::\link[ggplot2]{scale_fill_gradientn}}
#'
#' @importFrom ggplot2 scale_color_gradientn
#' @export
scale_color_dreal_c <- function(..., palette = "continuous", reverse = FALSE) {
  pal <- dreal_pal(palette = palette, reverse = reverse)
  scale_color_gradientn(..., colours = pal(256))
}

#' @export
#' @rdname scale_color_dreal_c
#' @usage NULL
scale_colour_dreal_c <- scale_color_dreal_c

#' Discrete color scale constructor for dreal colors
#'
#' @param palette Character name of palette in dreal_palettes or "explore" for high number of levels
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to \code{ggplot2::\link[ggplot2]{discrete_scale}}
#'
#' @importFrom ggplot2 scale_colour_manual discrete_scale
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
#'    geom_point(size = 4) +
#'    scale_color_dreal_d()
#' # Long scales in exploration phase
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, color = as.factor(1:nrow(iris)))) +
#'   geom_point(size = 4) +
#'   scale_color_dreal_d(palette = "explore", guide = FALSE)
scale_color_dreal_d <- function(..., palette = "discrete_long", reverse = FALSE) {
  if (palette == "explore") {
    colours <- unname(dreal_palettes[["discrete_long"]])
    if (reverse) colours <- rev(colours)
    pal <- grDevices::colorRampPalette(colours)
    discrete_scale("colour", "explore",
                            pal,
                            ...)
  } else {
    pal <- unname(dreal_palettes[[palette]])
    if (reverse) pal <- rev(pal)
    # discrete_scale("colour", paste0("dreal_", palette), palette = pal, ...)
    scale_colour_manual(..., values = pal)
  }
}

#' @export
#' @rdname scale_color_dreal_d
#' @usage NULL
scale_colour_dreal_d <- scale_color_dreal_d


#' Continuous fill scale constructor for dreal colors
#'
#' @param palette Character name of palette in dreal_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to \code{ggplot2::\link[ggplot2]{scale_fill_gradientn}}
#'
#' @importFrom ggplot2 scale_fill_gradientn
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Sepal.Length)) +
#'    geom_point(size = 4) +
#'    scale_color_dreal_c()
scale_fill_dreal_c <- function(..., palette = "continuous", reverse = FALSE) {
  pal <- dreal_pal(palette = palette, reverse = reverse)
  scale_fill_gradientn(..., colours = pal(256))
}

#' Discrete fill scale constructor for dreal colors
#'
#' @param palette Character name of palette in dreal_palettes or "explore" for high number of levels
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to \code{ggplot2::\link[ggplot2]{discrete_scale}}
#'
#' @importFrom ggplot2 scale_fill_manual discrete_scale
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Width, fill = Species)) +
#'   geom_histogram(size = 4, bins = 20) +
#'   scale_fill_dreal_d()
#' # Long scales in exploration phase
#' ggplot(iris, aes(Sepal.Width, fill = as.factor(1:nrow(iris)))) +
#'   geom_histogram(size = 4, bins = 20, colour = NA) +
#'   scale_fill_dreal_d(palette = "explore", guide = FALSE)
scale_fill_dreal_d <- function(..., palette = "discrete", reverse = FALSE) {
  if (palette == "explore") {
    colours <- unname(dreal_palettes[["discrete_long"]])
    if (reverse) colours <- rev(colours)
    pal <- grDevices::colorRampPalette(colours)
    discrete_scale("fill", "explore",
                   pal,
                   ...)
  } else {
    pal <- unname(dreal_palettes[[palette]])
    if (reverse) pal <- rev(pal)
    # discrete_scale("colour", paste0("dreal_", palette), palette = pal, ...)
    scale_fill_manual(..., values = pal)
  }
}

