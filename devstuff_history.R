# Hide this file from build
usethis::use_build_ignore("devstuff_history.R")
usethis::use_build_ignore("inst/dev")
usethis::use_build_ignore("rsconnect")
usethis::use_git_ignore("docs/")
usethis::use_git_ignore("rsconnect/")
# usethis::create_package(".")
usethis::use_git()
usethis::use_data_raw()
usethis::use_package_doc()
usethis::use_r("datasets")

# description ----
library(desc)
unlink("DESCRIPTION")
my_desc <- description$new("!new")
my_desc$set_version("0.0.0.9000")
my_desc$set(Package = "drealthemes")
my_desc$set(Title = "Themes for DREAL plots")
my_desc$set(Description = "Color palettes and ggplot2 themes.")
my_desc$set("Authors@R",
            'c(
  person("Sebastien", "Rochette", email = "sebastien@thinkr.fr", role = c("aut", "cre"), comment = c(ORCID = "0000-0002-1565-9313")),
  person("Colin", "Fay", email = "colin@thinkr.fr", role = c("aut"), comment = c(ORCID = "0000-0001-7343-1846")),
  person(given = "DREAL", role = "cph")
)')
my_desc$del("Maintainer")
my_desc$del("URL")
my_desc$del("BugReports")
my_desc$write(file = "DESCRIPTION")

# Licence ----
usethis::use_mit_license("DREAL")
# usethis::use_gpl3_license("ThinkR")

# Pipe ----
usethis::use_roxygen_md()
usethis::use_pipe()

# Package quality ----

# _Tests
usethis::use_testthat()
usethis::use_test("app")

# _CI
thinkridentity::use_gitlab_ci(image = "thinkr/runnerci", upgrade = "never")
# usethis::use_travis()
# usethis::use_appveyor()
# usethis::use_coverage()

# _rhub
# rhub::check_for_cran()


# Documentation ----
# _Readme
usethis::use_readme_rmd()
# _News
usethis::use_news_md()
# _Vignette
usethis::use_vignette("aa-colour-palettes")
usethis::use_vignette("ab-ggplot2-themes")
usethis::use_vignette("ac-ggiraph-plots")
devtools::build_vignettes()

# _Book
# thinkridentity::install_git_with_pwd(repo = "ThinkR/visualidentity", username, password, host = "git.thinkr.fr")
visualidentity::create_book("inst/report", clean = TRUE)
visualidentity::open_guide_function()
devtools::document()
visualidentity::build_book(clean_rmd = TRUE, clean = TRUE)
# pkg::open_guide()

# _Pkgdown
visualidentity::build_pkgdown(
  # lazy = TRUE,
  yml = system.file("pkgdown/_pkgdown.yml", package = "thinkridentity"),
  favicon = system.file("pkgdown/favicon.ico", package = "thinkridentity"),
  move = TRUE, clean_before = TRUE, clean_after = TRUE
)

visualidentity::open_pkgdown_function(path = "inst/docs")
# pkg::open_pkgdown()

## __ deploy on rsconnect
usethis::use_git_ignore("docs/rsconnect")
usethis::use_git_ignore("inst/docs/rsconnect")
usethis::use_git_ignore("rsconnect")

rsconnect::accounts()
account_name <- rstudioapi::showPrompt("Rsconnect account", "Please enter your username:", "name")
account_server <- rstudioapi::showPrompt("Rsconnect server", "Please enter your server name:", "1.1.1.1")
origwd <- setwd("inst/docs")
rsconnect::deployApp(
  ".",                       # the directory containing the content
  appFiles = list.files(".", recursive = TRUE), # the list of files to include as dependencies (all of them)
  appPrimaryDoc = "index.html",                 # the primary file
  appName = "drealthemes",                   # name of the endpoint (unique to your account on Connect)
  appTitle = "drealthemes",                  # display name for the content
  account = account_name,                # your Connect username
  server = account_server                    # the Connect server, see rsconnect::accounts()
)
setwd(origwd)


# Dependencies ----
# devtools::install_github("ThinkR-open/attachment")
attachment::att_to_description()
attachment::att_to_description(extra.suggests = c("bookdown", "pkgdown"))
# attachment::create_dependencies_file()

# Knit vignette with pagedown
temp_dir <- tempdir()
rmarkdown::render("vignettes/ab-ggplot2-themes.Rmd", output_dir = temp_dir)
pagedown::chrome_print(input = file.path(temp_dir, "ab-ggplot2-themes.html"))
browseURL(temp_dir)

# Utils for dev ----
devtools::install(upgrade = "never")
# devtools::load_all()
devtools::check(vignettes = TRUE)
# ascii
stringi::stri_trans_general("é", "hex")
