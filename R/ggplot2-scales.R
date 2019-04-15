#' Continuous color scale constructor for dreal colors
#'
#' @param palette Character name of palette in dreal_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to scale_color_gradientn()
#'
#' @importFrom ggplot2 scale_color_gradientn
#' @export
scale_color_dreal_c <- function(..., palette = "continuous", reverse = FALSE) {
  pal <- dreal_pal(palette = palette, reverse = reverse)
  scale_color_gradientn(..., colours = pal(256))
}

#' Discrete color scale constructor for dreal colors
#'
#' @param palette Character name of palette in dreal_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to scale_color_manual()
#'
#' @importFrom ggplot2 scale_color_manual
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
#'    geom_point(size = 4) +
#'    scale_color_dreal_d()
scale_color_dreal_d <- function(..., palette = "discrete", reverse = FALSE) {
  pal <- unname(dreal_palettes[[palette]])
  if (reverse) pal <- rev(pal)
  # discrete_scale("colour", paste0("dreal_", palette), palette = pal, ...)
  scale_color_manual(..., values = pal)
}

#' Continuous fill scale constructor for dreal colors
#'
#' @param palette Character name of palette in dreal_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to scale_fill_gradientn()
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
#' @param palette Character name of palette in dreal_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to scale_fill_manual()
#'
#' @importFrom ggplot2 scale_fill_manual
#' @export
#'
#' @examples
#' ggplot(iris, aes(Sepal.Width, fill = Species)) +
#'   geom_histogram(size = 4, bins = 20) +
#'   scale_fill_dreal_d()
scale_fill_dreal_d <- function(..., palette = "discrete", reverse = FALSE) {
  pal <- unname(dreal_palettes[[palette]])
  if (reverse) pal <- rev(pal)
  # discrete_scale("colour", paste0("dreal_", palette), palette = pal, ...)
  scale_fill_manual(..., values = pal)
}

