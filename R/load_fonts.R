#' Function to run onLoad

onload_function <- function() {
  # load fonts
  load_fonts()
  # test for fonts
  check_fonts_in_r(import = FALSE, browse = FALSE)
}

#' Load installed fonts
#' @export
#' @examples
#' load_fonts()

load_fonts <- function() {
  # load fonts
  # Run it once in every R session
  pdfFonts <- grDevices::pdfFonts
  # extrafont::loadfonts("pdf",quiet=T)
  extrafont::loadfonts(quiet = TRUE)
  # On windows only
  if (.Platform$OS.type == "windows") {
    windowsFonts <- grDevices::windowsFonts
    extrafont::loadfonts(device = "win")
  }
}

#' Tests if fonts are available on the system and import for extrafont
#'
#' @param fonts vector of fonts
#' @param import Logical. Whether to import ttf in R. (Otherwise just check)
#' @param verbose list fonts to install if needed
#' @param browse open directory with fonts to install, when verbose is TRUE
#'
#' @importFrom utils browseURL unzip
#'
#' @details
#' For fonts to be used, they need to be installed on the machine.
#'
#' @export
#' @examples
#' # Change browse to TRUE to open folder with fonts required
#' check_fonts_in_r(import = FALSE)
#'
#' # Test if working
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars) +
#'   geom_point(aes(cyl, mpg)) +
#'   labs(title = "Mon titre avec Roboto",
#'        x = "lab X avec Lato",
#'        y = "Lab Y avec Caveat") +
#'   theme(title = element_text(family = "Roboto"),
#'         axis.title.x = element_text(family = "Lato"),
#'         axis.title.y = element_text(family = "Caveat")
#'   )
#' }

check_fonts_in_r <- function(fonts = c("Raleway", "Roboto Slab", "Caveat", "Roboto", "Lato"),
                             import = TRUE,
                             verbose = TRUE, browse = FALSE) {

  # Import fonts
  if (isTRUE(import)) {
    fonts_no_space <- gsub(" ", "", fonts)
    res <- lapply(fonts_no_space, function(x) {
      res <- attempt::try_catch(
        extrafont::font_import(pattern = x, prompt = FALSE), .e = ~FALSE)
      if (is.null(res)) {res <- TRUE}
      res
    }) %>% unlist()
    names(res) <- fonts

    # load installed fonts
    load_fonts()
  }

  res <- lapply(fonts, function(x) {(extrafont::choose_font(x) != "")}) %>%
    unlist()
  names(res) <- fonts

  # If some are missing
  if (sum(!res) != 0 & isTRUE(verbose)) {
    warning("To use the complete theme, you need to install the following fonts on your computer: ",
            paste(names(res)[!res], collapse = ", "), ".",
            "\n1 - Run : check_fonts_in_r(browse = TRUE) to find fonts.",
            "\n  To install, see for instance: https://www.howtogeek.com/192980/how-to-install-remove-and-manage-fonts-on-windows-mac-and-linux/",
            "\n2 - Run check_fonts_in_r() after fonts installation."
    )
    if (isTRUE(browse)) {
      zip_fonts <- system.file("fonts.zip", package = "drealthemes")
      tmp_dir <- tempdir()
      invisible(unzip(zip_fonts, exdir = tmp_dir))
      browseURL(file.path(tmp_dir, "fonts"))
    }
  }
  res
}



# icones
# if (extrafont::choose_font("dreal") == "") {
#   dir_fonts <- system.file("fonts/dreal/font", package = "drealthemes")
#   extrafont::ttf_import(dir_fonts)
# }
# if (extrafont::choose_font("LineAwesome") == "") {
#   dir_fonts <- system.file("fonts/lineawesome/fonts", package = "drealthemes")
#   extrafont::ttf_import(dir_fonts)
# }
# https://www.howtogeek.com/192980/how-to-install-remove-and-manage-fonts-on-windows-mac-and-linux/
# if (extrafont::choose_font("Lato") == "") {
#   dir_fonts <- system.file("fonts/Lato", package = "drealthemes")
#   extrafont::ttf_import(dir_fonts)
# }
# if (extrafont::choose_font("Roboto Slab") == "") {
#   dir_fonts <- system.file("fonts/Roboto_Slab", package = "drealthemes")
#   extrafont::ttf_import(dir_fonts)
#   extrafont::font_import(dir_fonts)
# }
# (extrafont::choose_font("Caveat") == "")
# extrafont::fonts()
# ttf_import()

# Run it once
# try(extrafont::font_import(pattern = "Roboto Slab", prompt = FALSE))
# Run it once in every R session
# extrafont::loadfonts()
# On windows only
# if (.Platform$OS.type == "windows") {
#   extrafont::loadfonts(device = "win")
# }
# To output a pdf, you have to embed fonts
# embed_fonts("plot_cm.pdf", outfile = "plot_cm_embed.pdf")

## showtext
# library(showtext)
# font_paths()
# font_files()$family
#
# if (!"Roboto Slab" %in% sysfonts::font_families()) {
#   dir_fonts <- system.file("fonts/Roboto_Slab", package = "drealthemes")
#   sysfonts::font_paths(dir_fonts)
#   sysfonts::font_add("Roboto Slab",
#                      regular = "RobotoSlab-Regular.ttf",
#                      bold = "RobotoSlab-Bold.ttf")
# }
# if (!"Lato" %in% sysfonts::font_families()) {
#   dir_fonts <- system.file("fonts/Lato", package = "drealthemes")
#   sysfonts::font_paths(dir_fonts)
#   sysfonts::font_add("Lato",
#                      regular = "Lato-Regular.ttf",
#                      bold = "Lato-Bold.ttf",
#                      italic = "Lato-Italic.ttf",
#                      bolditalic = "Lato-BoldItalic.ttf")
# }
# showtext::showtext_auto()
#
# g <- ggplot(mtcars) +
#   geom_point(aes(cyl, mpg)) +
#   labs(title = "Mon titre avec font") +
#   # theme(title = element_text(family = "Lato", face = "bold"))
#   # theme(title = element_text(family = "Caveat"))
#   theme(title = element_text(family = "Roboto Slab"))
# g
# print(g)
# x11();g
# ggsave(g, filename = "g.png")
