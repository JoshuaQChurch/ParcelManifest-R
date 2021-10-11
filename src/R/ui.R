#' @description License agreement for tool
#'
#' @return License agreement HTML file
view_license <- function() {
  return(
    shiny::HTML(
      "MIT No Attribution",
      "<br><br>",

      "Copyright (c)", format(Sys.Date(), "%Y"), "Joshua Church",
      "<br><br>",

      "Permission is hereby granted, free of charge, to any person obtaining a copy of this",
      "software and associated documentation files (the \"Software\"), to deal in the Software",
      "without restriction, including without limitation the rights to use, copy, modify,",
      "merge, publish, distribute, sublicense, and/or sell copies of the Software, and to",
      "permit persons to whom the Software is furnished to do so.",
      "<br><br>",

      "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,",
      "INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A",
      "PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT",
      "HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION",
      "OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE",
      "SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
    )
  )
}

#' @description Create header for tool options
#'
#' @param h Header (str)
create_header <- function(h) {
  return(
    shiny::fluidRow(
      style = paste(
        "text-align: center;",
        "font-style: italic;"
      ),
      shiny::column(width = 1),
      shiny::column(
        width = 10,
        shiny::tags$hr(),
        shiny::tags$h2(shiny::tags$b(h)),
        shiny::tags$hr()
      ),
      shiny::column(width = 1)
    )
  )
}

#' @description Create "launch" buttons for each macro.
#'
#' @param tool (string) name of the macro
launch_button <- function(tool) {
  return(
    shiny::tags$div(
      shiny::fluidRow(
        shiny::column(
          width = 1
        ),
        shiny::column(
          width = 10,

          bs4Dash::actionButton(
            inputId = paste0("launch_", tool),
            label = "Launch",
            icon = shiny::icon(name = "rocket", lib = "font-awesome"),
            width = "100%",
            status = "success",
            gradient = FALSE,
            size = "lg",
            flat = FALSE,
            outline = TRUE
          )
        ),
        shiny::column(
          width = 1
        )
      )
    )
  )
}


#' @description Create UI output for column status
#'
#' @param tool Tool name
#' @param column Column name
get_column_status <- function(tool, column) {
  return(
    shiny::tags$h4(
      shiny::fluidRow(
        shiny::column(
          width = 1,
          shiny::tags$div(
            style = "align: center;",
            shiny::uiOutput(
              paste0(tool, "_", column)
            )
          )
        ),
        shiny::column(
          width = 5,
          column
        )
      )
    )
  )
}


#' @description Parcel Manifest UI
ui <- bs4Dash::bs4DashPage(

  # Navigation Bar
  header = bs4Dash::bs4DashNavbar(
    skin = "dark",
    status = "primary",
    border = TRUE,
    sidebarIcon = shiny::icon("bars"),
    compact = TRUE,
    controlbarIcon = shiny::icon("th"),
    fixed = FALSE,
    title = bs4Dash::dashboardBrand(
      title = shiny::tags$h2("Parcel Manifest", style = "text-align: center;"),
      color = NULL,
      href = "https://joshua.church/",
      image = NULL
    )
  ),

  # Sidebar
  sidebar = bs4Dash::bs4DashSidebar(
    title = "Parcel Manifest",
    skin = "dark",
    status = "primary",
    brandColor = "primary",
    url = "https://joshua.church",
    elevation = 5,
    opacity = 0.75,
    expand_on_hover = TRUE,
    fixed = TRUE,
    minified = TRUE,
    collapsed = TRUE,
    expandOnHover = FALSE,

    # Sidebar Menu
    bs4Dash::bs4SidebarMenu(

      # Sidebar Menu Items
      bs4Dash::bs4SidebarMenuItem(
        text = "Main",
        tabName = "tab_main",
        icon = shiny::icon(
          name = "home",
          lib = "font-awesome"
        ),
        selected = TRUE
      ),

      bs4Dash::bs4SidebarMenuItem(
        text = "Upload",
        tabName = "tab_upload",
        icon = shiny::icon(
          name = "upload",
          lib = "font-awesome"
        )
      ),

      bs4Dash::bs4SidebarMenuItem(
        startExpanded = FALSE,
        text = "Tools",
        tabName = "tab_tools",
        icon = shiny::icon(
          name = "tools",
          lib = "font-awesome"
        ),

        bs4Dash::bs4SidebarMenuSubItem(
          text = "Reprint",
          tabName = "tab_reprint",
          icon = shiny::icon(
            name = "print",
            lib = "font-awesome"
          )
        ),

        bs4Dash::bs4SidebarMenuSubItem(
          text = "Carton Manifest",
          tabName = "tab_carton_manifest",
          icon = shiny::icon(
            name = "box-open",
            lib = "font-awesome"
          )
        ),

        bs4Dash::bs4SidebarMenuSubItem(
          text = "Salesman Code",
          tabName = "tab_salesman_code",
          icon = shiny::icon(
            name = "piggy-bank",
            lib = "font-awesome"
          )
        )
      ),

      bs4Dash::bs4SidebarMenuItem(
        text = "Benefits",
        tabName = "tab_benefits",
        icon = shiny::icon(
          name = "star",
          lib = "font-awesome"
        )
      ),

      bs4Dash::bs4SidebarMenuItem(
        text = "License",
        tabName = "tab_license",
        icon = shiny::icon(
          name = "certificate",
          lib = "font-awesome"
        )
      )
    )
  ),

  # Body
  body = bs4Dash::bs4DashBody(

    waiter::useWaiter(),

    shiny::tags$head(

      shiny::tags$script(
        shiny::HTML(
          '
            // Fix for bs4Dash v2.0.3 to collapse sidebar on start.
            // This should get fixed with the 2.0.4 update. - JChurch

            $(document).ready(function(){
            var sidebarCollapsed = $(".main-sidebar").attr("data-collapsed");
              if (sidebarCollapsed === "true") {
                // This triggers binding geValue
                $("[data-widget=\'pushmenu\']").PushMenu("collapse");
              }
            });
          '
        )
      ),

      shiny::tags$style(
        type = 'text/css',
        '
        // Method for making the modal window full screen.
        // Required to deal with different size windows.

        .modal {
          padding: 0 !important;
        }

        .modal .modal-dialog {
          width: 100%;
          max-width: none;
          height: 100%;
          margin: 0;
        }

        .modal .modal-content {
          height: 100%;
          border: 0;
          border-radius: 0;
        }

        .modal .modal-body {
          overflow-y: auto;
        }'
      )
    ),

    bs4Dash::bs4TabItems(

      bs4Dash::bs4TabItem(
        tabName = "tab_main",

        bs4Dash::bs4Jumbotron(
          title = shiny::tags$strong("Parcel Manifest Macro"),
          lead = shiny::tags$i("Your one-stop shop to automating day-to-day tasks."),

          shiny::tags$h3("Instructions"),

          shiny::tags$ol(
            shiny::tags$li(
              "Upload a data file (.xls, .xlsx, or .csv)."
            ),
            shiny::tags$li(
              "Select an option from the available tools on the left."
            ),
            shiny::tags$li(
              "Launch the tool."
            ),
            shiny::tags$li(
              "Align this window (Parcel Manifest) directly next to the PKMS program."
            ),
            shiny::tags$li(
              "Click the direction where the mouse cursor should click the PKMS program."
            ),
            shiny::tags$li(
              "Wait until the program finishes the macro."
            ),
            shiny::tags$li(
              "Sit back and relax. Take a coffee break."
            )
          ),

          status = "primary",
          href = NULL,
          btnName = NULL
        )
      ),

      bs4Dash::bs4TabItem(
        tabName = "tab_upload",
        create_header("Upload File"),

        shiny::fluidRow(
          bs4Dash::box(
            title = "Upload File",
            footer = NULL,
            status = "primary",
            icon = shiny::icon("upload"),
            width = 12,

            bs4Dash::bs4Ribbon(
              text = "Required",
              color = "primary"
            ),

            shiny::fileInput(
              inputId = "data_file",
              label = "Browse for a data file or drag and drop the file directly.",
              accept = c(
                # .csv
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv",

                # .xls
                "application/vnd.ms-excel", # MIME type
                ".xls",

                # .xlsx
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", # MIME type
                ".xlsx"
              ),
              multiple = FALSE,
              width = "100%"
            )
          )
        )
      ),

      bs4Dash::bs4TabItem(
        tabName = "tab_reprint",
        create_header("Reprint Macro"),

        shiny::tags$div(
          style = paste0(
            "padding-top: 20px;",
            "padding-bottom: 20px;"
          ),

          launch_button("reprint"),

          shiny::tags$hr(),

          shiny::fluidRow(
            shiny::column(
              width = 6,
              shiny::tags$h3("Macro Commands:"),
              shiny::tags$ol(
                shiny::tags$li("Enter CHCASN row value."),
                shiny::tags$li("Press \"Enter\" key."),
                shiny::tags$li("Press \"9\" key."),
                shiny::tags$li("Press \"Enter\" key."),
                shiny::tags$li("Press \"F12\" key."),
                shiny::tags$li("Repeat until complete.")
              )
            ),
            shiny::column(
              width = 6,
              shiny::tags$h3("Required Columns"),

              get_column_status(
                tool = "reprint",
                column = "CDSTYL"
              ),

              get_column_status(
                tool = "reprint",
                column = "CHCASN"
              )
            )
          )
        )
      ),

      bs4Dash::bs4TabItem(
        tabName = "tab_carton_manifest",
        create_header("Carton Manifest"),

        shiny::tags$div(
          style = paste0(
            "padding-top: 20px;",
            "padding-bottom: 20px;"
          ),

          launch_button("carton_manifest"),

          shiny::tags$hr(),

          shiny::fluidRow(
            shiny::column(
              width = 6,
              shiny::tags$h3("Macro Commands:"),
              shiny::tags$ol(
                shiny::tags$li("Enter CHCASN row value."),
                shiny::tags$li("Press \"Enter\" key."),
                shiny::tags$li("Repeat until complete.")
              )
            ),
            shiny::column(
              width = 6,
              shiny::tags$h3("Required Columns"),

              get_column_status(
                tool = "carton_manifest",
                column = "CHCASN"
              )
            )
          )
        )
      ),

      bs4Dash::bs4TabItem(
        tabName = "tab_salesman_code",
        create_header("Salesman Code"),

        shiny::tags$div(
          style = paste0(
            "padding-top: 20px;",
            "padding-bottom: 20px;"
          ),

          launch_button("salesman_code"),

          shiny::tags$hr(),

          shiny::fluidRow(
            shiny::column(
              width = 6,
              shiny::tags$h3("Macro Commands:"),
              shiny::tags$ol(
                shiny::tags$li("Press \"F6\" key."),
                shiny::tags$li("Enter CODE row value."),
                shiny::tags$li("Enter STYLE row value."),
                shiny::tags$li("Press \"tab\" key."),
                shiny::tags$li("Enter CHCASN row value."),
                shiny::tags$li("Press \"Enter\" key."),
                shiny::tags$li("Press \"F16\" key."),
                shiny::tags$li("Repeat until complete.")
              )
            ),
            shiny::column(
              width = 6,
              shiny::tags$h3("Required Columns"),

              get_column_status(
                tool = "salesman_code",
                column = "CODE"
              ),

              get_column_status(
                tool = "salesman_code",
                column = "STYLE"
              ),

              get_column_status(
                tool = "salesman_code",
                column = "CHCASN"
              )
            )
          )
        )
      ),

      bs4Dash::bs4TabItem(
        tabName = "tab_benefits",
        create_header("Benefits"),

        shiny::fluidRow(
          bs4Dash::box(
            title = "Benefits",
            footer = NULL,
            status = "success",
            icon = shiny::icon("award"),
            width = 12,

            bs4Dash::bs4Ribbon(
              text = "Benefits",
              color = "success"
            ),

            shiny::fluidRow(
              bs4Dash::bs4InfoBox(
                "Time = Money",
                value = "Countless Hours Saved",
                subtitle = NULL,
                icon = shiny::icon("clock"),
                color = "indigo",
                width = 12,
                href = NULL,
                fill = FALSE,
                gradient = FALSE,
                elevation = 5,
                iconElevation = 5,
                tabName = NULL
              ),

              bs4Dash::bs4InfoBox(
                "Automation = Less Errors",
                value = "Reduce Chance of Errors",
                subtitle = NULL,
                icon = shiny::icon("robot"),
                color = "primary",
                width = 12,
                href = NULL,
                fill = FALSE,
                gradient = FALSE,
                elevation = 5,
                iconElevation = 5,
                tabName = NULL
              ),

              bs4Dash::bs4InfoBox(
                "It's Free!",
                value = "Open Source and Free to Use",
                subtitle = NULL,
                icon = shiny::icon("dollar-sign"),
                color = "success",
                width = 12,
                href = NULL,
                fill = FALSE,
                gradient = FALSE,
                elevation = 5,
                iconElevation = 5,
                tabName = NULL
              )
            )
          )
        )
      ),

      bs4Dash::bs4TabItem(
        tabName = "tab_license",
        create_header("License"),
        shiny::tags$p(view_license())
      )
    )
  ),
  controlbar = NULL,
  footer = bs4Dash::bs4DashFooter(
    left = "MIT License",
    right = "Created by: Joshua Church"
  ),
  title = "Parcel Manifest",
  skin = "dark",
  freshTheme = NULL,
  preloader = NULL,
  options = NULL,
  fullscreen = FALSE,
  help = FALSE,
  dark = TRUE,
  scrollToTop = TRUE
)




