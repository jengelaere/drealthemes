.onAttach <- function(libname, pkgname) {
  # switch the default ggplot2 theme to theme_dreal
  # ggplot2::theme_set(theme_dreal())
  packageStartupMessage("\n\n*******************************************************")
  # packageStartupMessage("Note: drealthemes changes the default ggplot2 theme.")
  # packageStartupMessage("To recover the default ggplot2 theme, execute:\n  theme_set(theme_gray())")
  packageStartupMessage("theme_dreal() for ggplot2 is not set as default,\nto do so, execute:\n  theme_set(theme_dreal())")
  packageStartupMessage("*******************************************************\n")
}
.onLoad <- function(libname, pkgname) {
  onload_function()
}
