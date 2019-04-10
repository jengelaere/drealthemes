## code to prepare `DATASET` dataset goes here
primary <- c("primary_active" = "#00465a", "primary" = "#008ca0", "primary_light" = "#00bebe")
secondary <- c("secondary_active" = "#3c0064", "secondary" = "#5a1e82", "secondary_light" = "#8246aa")
info <- c("info_active" = "#a0a0a0", "info" = "#b4b4b4", "info_light" = "#d2d2d2")
success <- c("success_active" = "#a0c83c", "success" = "#b4dc50", "success_light" = "#c8f064")
warning <- c("warning_active" = "#f59600", "warning" = "#ffd200", "warning_light" = "#fff000")
danger <- c("danger_active" = "#b4003c", "danger" = "#eb3273", "danger_light" = "#ff6e9b")

dreal_colors <- c(secondary, primary, warning, danger, success, info)[
  c(seq(1, 3*6, 3), seq(2, 3*6, 3), seq(3, 3*6, 3))]

usethis::use_data(dreal_colors)

cat("dreal_colors", file = "data/datalist")
