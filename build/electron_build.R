options(timeout = 100)

if (!"electricShine" %in% installed.packages()) {
  if (!"remotes" %in% installed.packages()) {
    install.packages("remotes")
  }
  
  remotes::install_github("JoshuaQChurch/electricShine")
}

nodejs_version <- "v14.18.0"
app_name <- "ParcelManifest"
build_path <- normalizePath(file.path(".", "output"))
app_path <- normalizePath(file.path("..", "ParcelManifest"))

# Create Electron package 
electricShine::electrify(
  app_name = app_name,
  product_name = "Parcel Manifest",
  short_description = "Standalone application to automate day-to-day tasks.",
  semantic_version = "1.0.0",
  cran_like_url = "https://cran.r-project.org",
  local_package_path = app_path,
  build_path = build_path,
  function_name = "run_app",
  permission = TRUE,
  run_build = FALSE,
  nodejs_version = nodejs_version
)


# Move updated 'background.js' file.
file.copy(
  from = file.path(build_path, "..", "background.js"),
  to = file.path(build_path, app_name, "src"),
  overwrite = TRUE
)

# Build process
electricShine::run_build_release(
  app_path = file.path(build_path, app_name),
  nodejs_path = file.path(system.file(package = "electricShine"), "nodejs", paste0("node-", nodejs_version, "-win-x64")),
  nodejs_version = nodejs_version
)
