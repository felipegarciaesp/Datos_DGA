# =====================================================================
# Codigo para estraer datos de estaciones DGA / Felipe Garcia
# =====================================================================

## Limpiar ambiente
#-------------------
rm(list=ls())
graphics.off()
cat("\014")

## Directorio de trabajo
#-------------------
setwd("C:/Codigos/Datos_DGA")
dir_inputs  <- file.path(getwd(), "Inputs")
dir_outputs <- file.path(getwd(), "Outputs")

## Carpeta de salida (se recrea en cada ejecucion)
#-------------------
if (dir.exists(dir_outputs)) unlink(dir_outputs, recursive = TRUE)  # borra resultados anteriores
dir.create(dir_outputs, recursive = TRUE)

## Lista de estaciones (Estaciones.xlsx: A1 = "Estaciones", nombres desde A2)
#-------------------
Estaciones <- openxlsx::read.xlsx(file.path(dir_inputs, "Estaciones.xlsx"),
                                  sheet = 1, colNames = TRUE)
nombres_estaciones <- trimws(as.character(Estaciones[[1]]))
nombres_estaciones <- nombres_estaciones[!is.na(nombres_estaciones) & nombres_estaciones != ""]

df_estaciones <- data.frame(Pestana    = paste("Estacion", seq_along(nombres_estaciones)),
                            Estacion   = nombres_estaciones,
                            stringsAsFactors = FALSE)

## Variables a extraer: palabra clave del .txt -> nombre del Excel de salida
#-------------------
variables <- c(
  caudal_medio = "caudal_medio_mensual",
  tmin         = "tmin_diarias",
  tmax         = "tmax_diarias",
  prep         = "pp_diarias"
)

## Procesamiento
#-------------------
archivos_txt <- list.files(dir_inputs, pattern = "\\.txt$", full.names = TRUE)

for (clave_variable in names(variables)) {
  coincidencias <- archivos_txt[
    grepl(clave_variable, basename(archivos_txt), ignore.case = TRUE)
  ]

  if (length(coincidencias) == 0) {
    message("No se encontro un archivo .txt con '", clave_variable, "' en el nombre.")
    next
  }

  if (length(coincidencias) > 1) {
    stop("Se encontro mas de un archivo .txt con '", clave_variable,
         "' en el nombre: ", paste(basename(coincidencias), collapse = ", "))
  }

  file_txt <- coincidencias[1]
  archivo  <- basename(file_txt)
  salida   <- variables[[clave_variable]]

  df <- read.csv(file_txt, sep = ",", header = TRUE, encoding = "UTF-8",
                 colClasses = c(CODIGO.ESTACION = "character"))
  df$NOMBRE.ESTACION <- trimws(df$NOMBRE.ESTACION)

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "Estaciones")
  openxlsx::writeData(wb, "Estaciones", df_estaciones)

  for (i in seq_along(nombres_estaciones)) {

    df_estacion <- df[df$NOMBRE.ESTACION == nombres_estaciones[i], ]

    if (nrow(df_estacion) == 0) {
      message("Estacion ", nombres_estaciones[i],
              " no fue encontrada en el archivo ", archivo)
      next
    }

    # Convertir FECHA a Date (el archivo de caudal no la trae)
    if ("FECHA" %in% names(df_estacion) && !all(df_estacion$FECHA %in% c("", NA))) {
      df_estacion$FECHA <- as.Date(df_estacion$FECHA, format = "%d/%m/%Y")
    }

    hoja <- df_estaciones$Pestana[i]
    openxlsx::addWorksheet(wb, hoja)
    openxlsx::writeData(wb, hoja, df_estacion)
  }

  openxlsx::saveWorkbook(wb, file.path(dir_outputs, paste0(salida, ".xlsx")), overwrite = TRUE)
  message("Archivo generado: ", salida, ".xlsx")
}

message("El codigo ha terminado.")
