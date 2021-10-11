#' Run the Parcel Manifest app
#'
#' @inheritDotParams shiny::runApp
#' @export
runApp <- function(...) {
  appDir <- system.file("app", package = "ParcelManifest")
  shiny::runApp(appDir = appDir, ...)
}

#' Use Electron to start app
#'
#' @inheritDotParams  shiny::shinyApp
#' @export
run_app <- function(...) {
  shiny::shinyApp(ui = ui, server = server, ...)
}
