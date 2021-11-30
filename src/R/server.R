# shiny
# bs4Dash
# waiter
# readxl
# data.table
# shinyWidgets
# KeyboardSimulator

#' @param s Number of seconds to delay each
set_delay <- function(s = 0.0) {
  if (s > 0) { Sys.sleep(s) }
}

#' @description Read in a data file
#'
#' @param path System file path to the data file
#' @return data.table object
import_data <- function(path) {
  ext <- tools::file_ext(path)
  ext <- tolower(ext)

  if (ext == "csv") {
    dt <- data.table::fread(path)
  }
  else if (ext %in% c("xls", "xlsx")) {
    dt <- readxl::read_excel(path)
  }
  else {
    return(NULL)
  }

  dt <- data.table::as.data.table(dt)
  return(dt)
}


#' @description Reprint Macro Commands
command_reprint <- function(dt = NULL) {

  # Sort data by 'CDSTYL' column.
  cdstyl <- order(as.integer(dt$CDSTYL), decreasing = TRUE)
  dt <- dt[cdstyl, ]

  KeyboardSimulator::keybd.press("tab", hold = FALSE)

  for (i in 1:nrow(dt)) {

    if ( i %% 100 == 0 ) {
      set_delay(3)
    }

    entry <- toString(dt[i, "CHCASN"])

    KeyboardSimulator::keybd.type_string(entry)
    KeyboardSimulator::keybd.press("enter", hold = FALSE)
    KeyboardSimulator::keybd.press("9", hold = FALSE)
    KeyboardSimulator::keybd.press("enter", hold = FALSE)
    KeyboardSimulator::keybd.press("f12", hold = FALSE)
    set_delay(0.1)
  }
}

#' @description Carton Manifest Commands
command_carton_manifest <- function(dt = NULL) {

  KeyboardSimulator::keybd.press("tab", hold = FALSE)

  for (i in 1:nrow(dt)) {

    if ( i %% 100 == 0 ) {
      set_delay(3)
    }

    entry <- toString(dt[i, "CHCASN"])

    KeyboardSimulator::keybd.type_string(entry)
    KeyboardSimulator::keybd.press("enter", hold = FALSE)
    set_delay(0.1)
  }
}

#' @description Salesman Code Commands
command_salesman_code <- function(dt = NULL) {

  # Sort data by 'STYLE' column.
  # Sorted by the length of the characters, not their value.
  # Only works when going from smaller length chars to longer chars.
  style <- order(nchar(dt$STYLE), dt$STYLE, decreasing = FALSE)
  dt <- dt[style, ]

  for (i in 1:nrow(dt)) {

    if ( i %% 100 == 0 ) {
      set_delay(3)
    }

    KeyboardSimulator::keybd.press("f6", hold = FALSE)
    KeyboardSimulator::keybd.type_string(toString(dt[i, "CODE"]))
    KeyboardSimulator::keybd.type_string(toString(dt[i, "STYLE"]))
    KeyboardSimulator::keybd.press("tab", hold = FALSE)
    KeyboardSimulator::keybd.type_string(toString(dt[i, "CHCASN"]))
    KeyboardSimulator::keybd.press("enter", hold = FALSE)
    # F16 = Shift + F4
    KeyboardSimulator::keybd.press("shift+f4", hold = FALSE)
    set_delay(0.1)
  }
}


#' Create directional arrow buttons
#'
#' @description Wrapper method to make directional buttons
#'
#' @param direction one of c("up", "down", "left", "right")
#' @return button
create_mouse_btn <- function(direction) {
  direction <- tolower(direction)

  return(
    bs4Dash::actionButton(
      inputId = paste0("move_mouse_", direction),
      label = toupper(direction),
      icon = shiny::icon(paste0("arrow-", direction)),
      width = "100%",
      status = "primary",
      gradient = FALSE,
      size = "lg",
      flat = FALSE,
      outline = TRUE
    )
  )
}


#' Move the mouse and click
#'
#' @description Move mouse relative to "clicked" position
#'
#' @param direction one of c("left", "right", "up", "down")
move_mouse <- function(direction) {

  direction <- tolower(direction)

  pos <- KeyboardSimulator::mouse.get_cursor()
  x <- pos[1]
  y <- pos[2]

  # Dimensions Expected
  width <- 700
  width <- round( width / 2 )

  height <- 800
  height <- round( height / 2 )

  cursor_opts <- list(
    "left" = list(
      x = ( x - width + 75 ),
      y = y
    ),
    "right" = list(
      x = ( x + width - 75 ),
      y = y
    ),
    "up" = list(
      x = x,
      y = ( y - height - 100 )
    ),
    "down" = list(
      x = x,
      y = ( y + height + 100 )
    )
  )

  KeyboardSimulator::mouse.move(
    x = cursor_opts[[direction]]$x,
    y = cursor_opts[[direction]]$y,
    duration = 1.0,
    step_ratio = 0.01
  )

  KeyboardSimulator::mouse.click(
    button = "left",
    hold = FALSE
  )
}


#' @description Parcel Manifest server function
#'
#' @inheritParams shiny::input
#' @inheritParams shiny::output
#' @inheritParams shiny::session
server <- function(input, output, session) {

  rv <- shiny::reactiveValues(
    tools = list(
      selected = NULL,
      choices = list(
        reprint = list(
          title = "Reprint Macro",
          cols = list(
            "CDSTYL" = FALSE,
            "CHCASN" = FALSE
          )
        ),
        carton_manifest = list(
          title = "Carton Manifest",
          cols = list(
            "CHCASN" = FALSE
          )
        ),
        salesman_code = list(
          title = "Salesman Code",
          cols = list(
            "CODE" = FALSE,
            "STYLE" = FALSE,
            "CHCASN" = FALSE
          )
        )
      )
    ),
    path = NULL,
    dt = NULL
  )


  return_icon <- function(status) {
    if (status) {
      icon <- shiny::icon("check", style = "color: green;")
    }
    else {
      icon <- shiny::icon("times", style = "color: red;")
    }
    icon <- shiny::tags$div(icon, style = "width: 100%; height: 100%;")
    return(icon)
  }

  shiny::observeEvent(input$data_file, {
    dat <- input$data_file

    if (!is.null(dat)) {
      dt <- import_data(dat$datapath)

      # If the filetype is invalide, don't load the content.
      if (is.null(dt)) {
        modal_window(
          type = "error",
          title = "Error",
          text = paste0(
            "Unable to upload \"", dat$name, ".\" \n\n",
            "This tool only accepts \".csv\", \".xls\", or \".xlsx\" files."
          )
        )
      }

      else {
        rv$dt <- dt
        cols <- colnames(rv$dt)

        col_CDSTYL <- ("CDSTYL" %in% cols)
        col_CHCASN <- ("CHCASN" %in% cols)
        col_CODE <- ("CODE" %in% cols)
        col_STYLE <- ("STYLE" %in% cols)

        # Reprint
        rv$tools$choices$reprint$cols$CDSTYL <- col_CDSTYL
        rv$tools$choices$reprint$cols$CHCASN <- col_CHCASN

        # Carton Manifest
        rv$tools$choices$carton_manifest$cols$CHCASN <- col_CHCASN

        # Salesman Code
        rv$tools$choices$salesman_code$cols$CHCASN <- col_CHCASN
        rv$tools$choices$salesman_code$cols$CODE <- col_CODE
        rv$tools$choices$salesman_code$cols$STYLE <- col_STYLE
      }
    }
  })


  #' @description Modify the UI status (e.g., columns) when a user
  #'     uploads a new file.
  shiny::observeEvent(rv$tools, {

    # Reprint
    output$reprint_CDSTYL <- shiny::renderUI({
      return_icon(rv$tools$choices$reprint$cols$CDSTYL)
    })

    output$reprint_CHCASN <- shiny::renderUI({
      return_icon(rv$tools$choices$reprint$cols$CHCASN)
    })

    # Carton Manifest
    output$carton_manifest_CHCASN <- shiny::renderUI({
      return_icon(rv$tools$choices$carton_manifest$cols$CHCASN)
    })

    # Salesman Code
    output$salesman_code_CHCASN <- shiny::renderUI({
      return_icon(rv$tools$choices$salesman_code$cols$CHCASN)
    })

    output$salesman_code_CODE <- shiny::renderUI({
      return_icon(rv$tools$choices$salesman_code$cols$CODE)
    })

    output$salesman_code_STYLE <- shiny::renderUI({
      return_icon(rv$tools$choices$salesman_code$cols$STYLE)
    })
  })


  #' Show modal window
  modal_window <- function(type = "error",
                           title = "Error",
                           text = NULL) {

    shinyWidgets::sendSweetAlert(
      session = session,
      title = title,
      text = text,
      type = type,
      btn_labels = "Close",
      html = TRUE,
      showCloseButton = TRUE,
      width = "75%"
    )
  }

  mouse_options <- function() {
    shiny::showModal(
      shiny::modalDialog(
        title = NULL,
        size = "l",
        fade = TRUE,
        footer = shiny::modalButton(
          label = "Dismiss",
          icon = shiny::icon("times")
        ),

        # Use Bootstrap columns to make
        # grid system to emulate arrow keys.
        shiny::tags$div(
          style = "text-align: center;",

          shiny::tags$h1("Set Mouse Position"),
          shiny::tags$h3(
            "Align this tool next to the PKMS tool, and ",
            "click the appropriate direction."
          ),

          shiny::tags$div(

            shinyWidgets::prettyCheckbox(
              inputId = "test_mouse_move",
              label = "Test mouse movement?",
              value = FALSE,
              status= "default",
              shape = "round",
              outline = FALSE,
              fill = FALSE,
              thick = TRUE,
              width = "100%",
              bigger = TRUE
            )
          ),

          shiny::tags$hr(),

          shiny::fluidRow(
            style = "padding-top: 100px;",

            shiny::column(
              width = 4
            ),
            shiny::column(
              width = 4,
              create_mouse_btn("up")
            ),
            shiny::column(
              width = 4
            )
          ),

          shiny::fluidRow(
            shiny::column(
              width = 4,
              create_mouse_btn("left")
            ),
            shiny::column(
              width = 4
            ),
            shiny::column(
              width = 4,
              create_mouse_btn("right")
            )
          ),

          shiny::fluidRow(
            shiny::column(
              width = 4
            ),
            shiny::column(
              width = 4,
              create_mouse_btn("down")
            ),
            shiny::column(
              width = 4
            )
          )
        )
      )
    )
  }

  #' Display loading window
  #'
  #' @description Show loading overlay while executing
  #'     the user-selected tool macro.
  #'
  #' @param title Title of the currently-running macro
  #'
  #' @return waiter::Waiter$new object
  loading_window <- function(title) {
    return(
      waiter::Waiter$new(
        html = shiny::tags$div(
          shiny::tags$h1("Executing ", title),
          shiny::tags$h2("Do NOT touch your mouse or keyboard at this time."),
          shiny::tags$hr(),
          waiter::spin_solar(), #spin_pong(), spin_ball()
        ),
        fadeout = TRUE
      )
    )
  }


  #' Dynamically create observable arrow commands
  #'
  #' @description Create a list of observable events for the
  #' 'up', 'down', 'left', and 'right' directions for
  #' each tool.
  lapply(c("up", "down", "left", "right"), function(d) {
    shiny::observeEvent(input[[paste0("move_mouse_", d)]], {

      selected <- rv$tools$selected
      params <- rv$tools$choices[[selected]]
      title <- params$title

      w <- loading_window(title)
      w$show()

      move_mouse(d)

      if (input$test_mouse_move) {
        w$hide()

        modal_window(
          type = "info",
          title = "Test Complete",
          text = "Mouse movement test complete."
        )
      }

      else {

        shiny::removeModal()

        # "Cheeky" way to call command programmatically.
        # Macro commands follow the format: command_<tool>.
        fun <- paste0("command_", selected)

        out <- tryCatch(
          expr = { do.call(what = fun, args = list(dt = rv$dt)) },
          error = function(e) { return(e) }
        )

        w$hide()

        if (inherits(out, c("simpleError", "try-error"))) {
          modal_window(
            type = "error",
            title = "Error",
            text = out$message
          )
        }

        else {
          modal_window(
            type = "success",
            title = "Complete",
            text = paste(title, "has finished.")
          )
        }
      }
    })
  })

  #' Dynamically create observable events for each tool.
  #'
  #' @description Dynamically create observeableEvent for
  #' 'reprint', 'carton_manifest', and 'salesman_code'.
  lapply(c("reprint", "carton_manifest", "salesman_code"), function(i) {
    shiny::observeEvent(input[[paste0("launch_", i)]], {
      if (all(as.logical(rv$tools$choices[[i]]$cols))) {
        rv$tools$selected <- i
        mouse_options()
      }

      else {
        modal_window(
          text = paste(
            "Upload a data file that contains the neccessary",
            "columns to proceed."
          )
        )
      }
    })
  })

  electron <- TRUE
  if (!electron) {

    # Throws an error with Electron.
    session$onSessionEnded(function() {
      shiny::stopApp()
      base::q("no")
    })
  }

}



