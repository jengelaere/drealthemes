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
#' @param text.size main text size in pts.
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
                     heights, widths, text.size = 12,
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
        axis.text = element_text(colour = "black", size = text.size,
                                 margin = margin(t = 1, r = 50),
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

#' ggplot2 themes for Dreal
#'
#' These are a complete themes which control all non-data display. Use theme() if you just need to tweak the display of an existing theme
#'
#' @param legend.position position of the legend "bottom" or "right"
#' @param caption.position position of the caption "left" or "right"
#' @param flipped Logical. Whether \code{\link[ggplot2]{coord_flip}} has been added to the plot
#' @param text.size main text size in pts.
#' @param ... Other parameters of \code{\link[ggplot2]{theme}}
#'
#' @importFrom ggplot2 theme_minimal theme element_text element_rect element_blank element_line
#'
#' @rdname theme_dreal
#' @export

theme_dreal_dark <- function(legend.position = c("bottom", "right"),
                             caption.position = c("left", "right"),
                             flipped = FALSE,
                             text.size = 13,
                             ...) {

  legend.position <- match.arg(legend.position, c("bottom", "right"), several.ok = FALSE)
  caption.position <- match.arg(caption.position, c("left", "right"), several.ok = FALSE)
  if (caption.position == "left") {
    cap.hjust <- 0
  } else {
    cap.hjust <- 1
  }
  if (isTRUE(flipped)) {
    panel.grid.major.y <- element_blank()
  } else {
    panel.grid.major.y <- element_line(linetype = "dashed",
                                       colour = dreal_cols("info_light"))
  }

  theme_minimal() +
    theme(
      text = element_text(family = "Raleway", size = text.size),
      plot.title = element_text(margin = margin(t = 10, b = 15)),

      legend.position = legend.position,
      legend.justification = "left",

      legend.background = element_rect(fill = dreal_cols("primary_active"), colour = NA),
      plot.background = element_rect(fill = dreal_cols("primary_active")),
      panel.background = element_rect(fill = "white", colour = NA),
      strip.background = element_rect(fill = dreal_cols("primary"), colour = NA),

      title = element_text(colour = "white", face = "bold"),
      plot.caption = element_text(hjust = cap.hjust, colour = dreal_cols("info_light")),
      axis.text = element_text(colour = "white", hjust = 0),
      legend.title = element_text(colour = "white", face = "plain"),
      legend.text = element_text(colour = "white"),
      strip.text = element_text(colour = "white"),

      panel.grid.minor = element_blank(),
      panel.grid.major.y = panel.grid.major.y,
      panel.grid.major.x = element_line(colour = dreal_cols("info_light")),
      axis.ticks.y.left = element_line(colour = dreal_cols("info")),
      axis.line.y.left = element_line(colour = dreal_cols("info")),
      ...
    )

}

#' theme_dreal_light
#' @rdname theme_dreal
#' @export
theme_dreal_light <- function(legend.position = c("bottom", "right"),
                              caption.position = c("left", "right"),
                              flipped = FALSE,
                              text.size = 13,
                              ...) {

  legend.position <- match.arg(legend.position, c("bottom", "right"), several.ok = FALSE)
  caption.position <- match.arg(caption.position, c("left", "right"), several.ok = FALSE)
  if (caption.position == "left") {
    cap.hjust <- 0
  } else {
    cap.hjust <- 1
  }
  if (isTRUE(flipped)) {
    panel.grid.major.y <- element_blank()
  } else {
    panel.grid.major.y <- element_line(linetype = "dashed",
                                       colour = dreal_cols("info_light"))
  }

  theme_minimal() +
    theme(
      text = element_text(family = "Raleway", size = text.size),
      plot.title = element_text(margin = margin(t = 10, b = 15)),

      legend.position = legend.position,
      legend.justification = "left",

      legend.background = element_rect(fill = "white", colour = NA),
      plot.background = element_rect(fill = "white"),
      panel.background = element_rect(fill = "white", colour = NA),
      strip.background = element_rect(fill = dreal_cols("primary"), colour = NA),

      title = element_text(colour = dreal_cols("primary_active"), face = "bold"),
      plot.caption = element_text(hjust = cap.hjust, colour = dreal_cols("info_active")),
      axis.text = element_text(colour = dreal_cols("primary_active"), hjust = 0),
      legend.title = element_text(colour = dreal_cols("primary_active"), face = "plain"),
      legend.text = element_text(colour = dreal_cols("primary_active")),
      strip.text = element_text(colour = "white"),

      panel.grid.minor = element_blank(),
      panel.grid.major.y = panel.grid.major.y,
      panel.grid.major.x = element_line(colour = dreal_cols("info_light")),
      axis.ticks.y.left = element_line(colour = dreal_cols("info_light")),
      axis.line.y.left = element_line(colour = dreal_cols("info")),
      ...
    )

}


#' theme_dreal
#' @param type Choose theme type
#' @rdname theme_dreal
#' @export
theme_dreal <- function(type = c("light", "dark"),
                        legend.position = c("bottom", "right"),
                        caption.position = c("left", "right"),
                        flipped = FALSE, text.size = 13,
                        ...) {

  type <- match.arg(type, c("light", "dark"), several.ok = FALSE)
  if (type == "light") {
    theme_dreal_light(legend.position, caption.position, flipped, text.size, ...)
  } else if (type == "dark") {
    theme_dreal_dark(legend.position, caption.position, flipped, text.size, ...)
  }
}

#' Change geom defaults to the dreal colors
#'
#' @param default Choose which default to set "dreal", "ggplot2"
#'
#' @export
dreal_geom_defaults <- function(default = c("dreal", "ggplot2")) {

  default <- match.arg(default, c("dreal", "ggplot2"), several.ok = FALSE)

  if (default == "dreal") {
    ggplot2::update_geom_defaults("point", list(colour = dreal_cols("primary_active")))
    ggplot2::update_geom_defaults("line", list(colour = dreal_cols("primary_active")))
    ggplot2::update_geom_defaults("rect", list(colour = NA, fill= dreal_cols("warning")))
    ggplot2::update_geom_defaults("density", list(colour = dreal_cols("warning_light"), fill=NA))
    ggplot2::update_geom_defaults("ribbon", list(colour = NA, fill = dreal_cols("warning_light")))
    ggplot2::update_geom_defaults("area", list(colour = NA, fill=dreal_cols("warning_light")))
    ggplot2::update_geom_defaults("bar", list(colour = NA, fill=dreal_cols("warning")))
    ggplot2::update_geom_defaults("col", list(colour = NA, fill=dreal_cols("warning")))
    ggplot2::update_geom_defaults("text", list(colour = dreal_cols("primary_active")))
    ggplot2::update_geom_defaults("smooth", list(colour = dreal_cols("primary_active"), fill = dreal_cols("primary_light")))
    ggplot2::update_geom_defaults("violin", list(colour = dreal_cols("secondary_active"), fill = dreal_cols("secondary_light")))
    ggplot2::update_geom_defaults("boxplot", list(colour = dreal_cols("secondary_active"), fill = dreal_cols("secondary_light")))
  } else if (default == "ggplot2") {
    ggplot2::update_geom_defaults("point", list(colour = "black"))
    ggplot2::update_geom_defaults("line", list(colour = "black"))
    ggplot2::update_geom_defaults("rect", list(colour = NA, fill= "grey35"))
    ggplot2::update_geom_defaults("density", list(colour = "black", fill=NA))
    ggplot2::update_geom_defaults("ribbon", list(colour = NA, fill = "grey20"))
    ggplot2::update_geom_defaults("area", list(colour = NA, fill="grey20"))
    ggplot2::update_geom_defaults("bar", list(colour = NA, fill="grey35"))
    ggplot2::update_geom_defaults("col", list(colour = NA, fill="grey35"))
    ggplot2::update_geom_defaults("text", list(colour = "black"))
    ggplot2::update_geom_defaults("smooth", list(colour = "#3366FF", fill = "grey60"))
    ggplot2::update_geom_defaults("violin", list(colour = "grey20", fill = "white"))
    ggplot2::update_geom_defaults("boxplot", list(colour = "grey20", fill = "white"))
  }
}
