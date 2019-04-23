#' Create empty ggplot on which to add legend
#'
#' @param ... other parameters of \code{ggplot2::\link[ggplot2]{theme}}
#' @inheritParams cowplot::ggdraw
#'
#' @importFrom cowplot draw_plot theme_nothing
#' @importFrom ggplot2 ggplot aes_string scale_x_continuous scale_y_continuous theme labs
ggempty <- function(plot = NULL, xlim = c(0, 1), ylim = c(0, 1), ...)
{
  d <- data.frame(x = 0:1, y = 0:1)
  p <- ggplot(d, aes_string(x = "x", y = "y")) +
    scale_x_continuous(limits = xlim, expand = c(0, 0)) +
    scale_y_continuous(limits = ylim, expand = c(0, 0)) +
    theme_nothing() +
    theme(...) +
    labs(x = NULL, y = NULL)
  if (!is.null(plot)) {
    p <- p + draw_plot(plot)
  }
  p
}

#' transform a ggplot with the DREAL theme
#'
#' @param g a ggplot
#' @param legend.position position of the legend "bottom" or "right"
#' @param title title of the graph
#' @param caption cpation of the graph
#' @param heights heights of the different parts of the plot.
#' Default to c(1, 9, 1, 0.5) for legend.position = "bottom".
#' Default to c(1, 9, 0.5) for legend.position = "left".
#' @param widths widths of the two columns of plot with legend.position = "left".
#' Default to c(4, 1).
#' @param ... other parameters of \code{ggplot2::\link[ggplot2]{theme}}
#'
#' @importFrom ggplot2 theme_minimal theme margin
#' @importFrom ggplot2 element_text element_rect element_blank element_line
#' @importFrom cowplot draw_grob get_legend
#' @importFrom grid grobTree rectGrob textGrob gpar
#' @importFrom gridExtra grid.arrange
#'
#'
#' @examples
#' library(ggplot2)
#' g <- ggplot(mtcars, aes(hp, mpg, colour = as.character(gear))) +
#' geom_point(
#' size = 4, alpha = .8) +
#' scale_color_dreal_d()
#'
#' g2 <- drealize(g,
#' title = "Plot created with drealize()",
#' caption = "Source: DREAL",
#' legend.position = "bottom")
#'
#' @export
drealize <- function(g, legend.position = "bottom", title = "Title of the graph", caption = "Source : DREAL",
                     heights, widths,
                     ...) {

  if (!legend.position %in% c("bottom", "right")) {
   stop("legend.position should be bottom or right.")
  }

  if (legend.position == "bottom" & missing(heights)) {
    heights <- c(1, 9, 1, 0.5)
  } else if (legend.position == "right") {
    if (missing(heights)) {
      heights <- c(1, 9, 0.5)
    }
    if (missing(widths)) {
      widths <- c(4, 1)
    }
  }

  # legend.position == "bottom"
  theme_list <- list(
    theme_minimal() +
      theme(
        # title = element_text(colour = "white", face = "bold"),
        axis.text = element_text(colour = "black", margin = margin(t = 1, r = 50),
                                 hjust = 0),
        legend.position = "none",
        plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = "white"),
        strip.background = element_rect(fill = dreal_cols("primary")),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_line(linetype = "dashed",
                                          colour = dreal_cols("info_light")),
        panel.grid.major.x = element_line(colour = dreal_cols("info_light")),
        ...
      )
  )

  g_legend <- g +
    theme(
      legend.position = legend.position,
      legend.justification = ifelse(legend.position == "bottom", "left", "right"),
      legend.background = element_rect(fill = dreal_cols("primary_active"), colour = NA),
      legend.title = element_text(colour = "white", face = "plain"),
      legend.text = element_text(colour = "white")
    )

  my_legend <- ggempty(
    plot.background = element_rect(fill = dreal_cols("primary_active"))
  ) +
    draw_grob(grobTree(get_legend(g_legend)))

  g_with_theme <- g + theme_list

  my_title <- grobTree(rectGrob(gp = gpar(fill = dreal_cols("primary_active"))),
                       textGrob(title,
                                x = 0.01, just = "left", hjust = 0,
                                gp = gpar(col = "white", cex = 1.25)))
  my_caption <- grobTree(rectGrob(gp = gpar(fill = "grey")),
                         textGrob(caption,
                                  x = 0.99, hjust = 1, just = "right",
                                  gp = gpar(col = "white", cex = 1)))

  if (legend.position == "bottom") {
    grid.arrange(my_title, g_with_theme, my_legend, my_caption,
                 heights = heights)
  } else if (legend.position == "right") {
    grid.arrange(my_title, g_with_theme, my_legend, my_caption,
                 layout_matrix = cbind(c(1,2,4), c(1,3,4)),
                 widths = widths, heights = heights)
  }
}

#' ggplot2 theme for Dreal
#'
#' This is a complete theme which control all non-data display. Use theme() if you just need to tweak the display of an existing theme
#'
#' @param legend.position position of the legend "bottom" or "right"
#' @param ... Other parameters of \code{\link[ggplot2]{theme}}
#'
#' @importFrom ggplot2 theme_minimal theme element_text element_rect element_blank element_line
#'
#' @export

theme_dreal <- function(legend.position = "bottom", ...) {

  # legend.position == "bottom"
  theme_minimal() +
    theme(
      title = element_text(colour = "white", face = "bold"),
      axis.text = element_text(colour = "white", margin = margin(t = 1, r = 50),
                               hjust = 0),

      legend.position = legend.position,
      legend.justification = "left",
      legend.background = element_rect(fill = dreal_cols("primary_active"), colour = NA),
      legend.title = element_text(colour = "white", face = "plain"),
      legend.text = element_text(colour = "white"),
      plot.background = element_rect(fill = dreal_cols("primary_active")),
      panel.background = element_rect(fill = "white"),
      strip.background = element_rect(fill = dreal_cols("primary")),

      strip.text = element_text(colour = "white"),

      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(linetype = "dashed",
                                        colour = dreal_cols("info_light")),
      panel.grid.major.x = element_line(colour = dreal_cols("info_light")),
      ...
    )

}
