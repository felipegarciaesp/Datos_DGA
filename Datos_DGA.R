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
dir_inputs <- file.path(getwd(), "Inputs")

## Carga de datos
#-------------------
file_txt <- list.files(dir_inputs, pattern = "\\.txt$", full.names = TRUE)[1]

df <- read.csv(file_txt, sep = ",", header = TRUE)

## Definicion de funciones
read_file_data <- function(file_path, sheet, use_rownames = TRUE) {
  df <- openxlsx::read.xlsx(file_path, sheet = sheet, colNames = TRUE)
  if (use_rownames) {
    rownames(df) <- as.character(df[,1])
    df <- df[,-1, drop = FALSE] # drop = FALSE evita que R convierta automáticamente el dataframe en un vector cuando el resultado tiene una sola columna.
    # es decir, df continuara siendo un dataframe incluso si tiene 1 columna.
  }
  df
}

## Filtrar por estacion
#-------------------
nombre_estacion <- "RIO ASTABURUAGA EN CONO"   # <-- modificar por el nombre deseado

Estaciones <- read_file_data(file.path(getwd(), "Inputs", "Estaciones.xlsx"))


df_estacion <- df[df$NOMBRE.ESTACION == nombre_estacion, ]

## Convertir columna de fecha a tipo Date
#-------------------
# Reemplaza "FECHA" por el nombre real de tu columna de fecha
df_estacion$FECHA <- as.Date(df_estacion$FECHA, format = "%d/%m/%Y")

## Exportar a Excel
#-------------------
dir_outputs <- file.path(getwd(), "Outputs")
if (!dir.exists(dir_outputs)) dir.create(dir_outputs)

openxlsx::write.xlsx(df_estacion, 
                     file = file.path(dir_outputs, paste0(nombre_estacion, ".xlsx")),
                     rowNames = FALSE)