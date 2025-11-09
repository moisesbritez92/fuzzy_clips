;;;======================================================================
;;; BASE DE HECHOS (BH)
;;; Casos de prueba para el sistema de priorización
;;;======================================================================
;;;
;;; Este archivo contiene ejemplos de hechos iniciales para diferentes
;;; escenarios de transformadores a evaluar.
;;;
;;; Formato: (assert (variable valor))
;;; donde 'valor' puede ser un valor crisp o un conjunto borroso
;;;======================================================================

;;;----------------------------------------------------------------------
;;; CASO 1: Transformador en condiciones críticas
;;;----------------------------------------------------------------------
;;; Descripción: Hospital con alta carga y temperatura elevada
;;; Expectativa: Prioridad ALTA

(deffacts caso-critico
  "Transformador alimentando hospital con síntomas críticos"
  (carga muy_alta)           ; 125% de carga nominal
  (temperatura alta)         ; 105°C
  (vibracion media)          ; 4.5 mm/s
  (historial_fallas bajo)    ; 1 falla en 12 meses
  (criticidad critico)       ; Hospital
)

;;;----------------------------------------------------------------------
;;; CASO 2: Transformador en operación normal
;;;----------------------------------------------------------------------
;;; Descripción: Zona residencial con carga baja
;;; Expectativa: Prioridad BAJA

(deffacts caso-normal
  "Transformador residencial en operación normal"
  (carga baja)               ; 35% de carga nominal
  (temperatura normal)       ; 45°C
  (vibracion baja)           ; 1.8 mm/s
  (historial_fallas bajo)    ; 0 fallas en 12 meses
  (criticidad residencial)   ; Zona residencial
)

;;;----------------------------------------------------------------------
;;; CASO 3: Transformador con patrón intermitente
;;;----------------------------------------------------------------------
;;; Descripción: Comercio con historial intermitente de fallas
;;; Expectativa: Prioridad MEDIA-ALTA

(deffacts caso-intermitente
  "Transformador comercial con fallas intermitentes"
  (carga media)              ; 70% de carga nominal
  (temperatura media)        ; 68°C
  (vibracion media)          ; 4.0 mm/s
  (historial_fallas intermitente)  ; Patrón no continuo
  (criticidad comercial)     ; Centro comercial
)

;;;----------------------------------------------------------------------
;;; CASO 4: Transformador en bombeo con temperatura elevada
;;;----------------------------------------------------------------------
;;; Descripción: Estación de bombeo con temperatura media-alta
;;; Expectativa: Prioridad ALTA (por criticidad del cliente)

(deffacts caso-bombeo
  "Transformador en estación de bombeo de agua"
  (carga alta)               ; 95% de carga nominal
  (temperatura media_alta)   ; 88°C
  (vibracion baja)           ; 2.5 mm/s
  (historial_fallas bajo)    ; 1 falla en 12 meses
  (criticidad critico)       ; Bombeo de agua potable
)

;;;----------------------------------------------------------------------
;;; CASO 5: Transformador comercial moderado
;;;----------------------------------------------------------------------
;;; Descripción: Zona comercial con síntomas moderados
;;; Expectativa: Prioridad MEDIA

(deffacts caso-moderado
  "Transformador comercial con síntomas moderados"
  (carga media)              ; 75% de carga nominal
  (temperatura media)        ; 70°C
  (vibracion media)          ; 4.2 mm/s
  (historial_fallas bajo)    ; 2 fallas en 12 meses
  (criticidad comercial)     ; Zona comercial
)

;;;----------------------------------------------------------------------
;;; HECHOS POR DEFECTO (para pruebas iniciales)
;;;----------------------------------------------------------------------
;;; Se puede descomentar uno de los siguientes bloques para pruebas rápidas

; Prueba rápida - Caso crítico
; (deffacts prueba-inicial
;   (carga muy_alta)
;   (temperatura alta)
;   (vibracion media)
;   (historial_fallas bajo)
;   (criticidad critico)
; )
