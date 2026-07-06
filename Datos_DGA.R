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

## Filtrar por estacion
#-------------------
nombre_estacion <- "RIO ASTABURUAGA EN CONO"   # <-- modificar por el nombre deseado

df_estacion <- df[df$NOMBRE.ESTACION == nombre_estacion, ]

## Exportar a Excel
#-------------------
dir_outputs <- file.path(getwd(), "Outputs")
if (!dir.exists(dir_outputs)) dir.create(dir_outputs)

openxlsx::write.xlsx(df_estacion, 
                     file = file.path(dir_outputs, paste0(nombre_estacion, ".xlsx")),
                     rowNames = FALSE)