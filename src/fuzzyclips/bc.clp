;;;======================================================================
;;; BASE DE CONOCIMIENTOS (BC)
;;; Sistema de Priorización de Mantenimiento de Transformadores
;;; Dominio: Media Tensión (23 kV) - ANDE
;;;======================================================================
;;;
;;; Este archivo contiene las definiciones de conjuntos borrosos,
;;; funciones de pertenencia, y reglas de inferencia para determinar
;;; la prioridad de mantenimiento de transformadores.
;;;
;;; Autor: Sistema Experto ANDE
;;; Fecha: 2025
;;;======================================================================

;;;----------------------------------------------------------------------
;;; DEFINICIONES DE UNIVERSOS Y CONJUNTOS BORROSOS
;;;----------------------------------------------------------------------

;;; Variable: Carga relativa (%)
;;; Universo: [0, 140]
;;; Descripción: Porcentaje de carga del transformador respecto a su capacidad nominal
(deftemplate carga
  0 140 %
  (
    (baja (0 1) (40 1) (60 0))
    (media (40 0) (60 1) (85 1) (100 0))
    (alta (85 0) (100 1) (120 1) (140 0))
    (muy_alta (120 0) (130 1) (140 1))
  )
)

;;; Variable: Temperatura del aceite (°C)
;;; Universo: [20, 120]
;;; Descripción: Temperatura del aceite dieléctrico del transformador
(deftemplate temperatura
  20 120 C
  (
    (normal (20 1) (40 1) (60 0))
    (media (40 0) (60 1) (75 1) (85 0))
    (media_alta (75 0) (85 1) (95 1) (100 0))
    (alta (95 0) (100 1) (120 1))
  )
)

;;; Variable: Vibración (mm/s)
;;; Universo: [0, 12]
;;; Descripción: Nivel de vibración detectado en el transformador
(deftemplate vibracion
  0 12 mm/s
  (
    (baja (0 1) (2 1) (3.5 0))
    (media (2 0) (3.5 1) (5 1) (7 0))
    (alta (5 0) (7 1) (12 1))
  )
)

;;; Variable: Historial de fallas (fallas/12m)
;;; Universo: [0, 8]
;;; Descripción: Número de fallas en los últimos 12 meses
;;; CONJUNTO NO CONTINUO: "intermitente" tiene picos en 1-2 y 5-6
(deftemplate historial_fallas
  0 8 fallas
  (
    (bajo (0 1) (1 1) (2 0))
    (intermitente (0 0) (1 0.3) (1.5 1) (2 0.3) (3 0) (5 0.3) (5.5 1) (6 0.3) (7 0))
    (frecuente (4 0) (6 1) (8 1))
  )
)

;;; Variable: Criticidad del cliente
;;; Universo: [0, 1] (representación continua no uniforme)
;;; Descripción: Importancia del servicio suministrado
;;; Modelo no uniforme: hospital/bombeo tienen mayor peso
(deftemplate criticidad
  0 1 nivel
  (
    (residencial (0 1) (0.3 1) (0.5 0))
    (comercial (0.3 0) (0.5 1) (0.7 1) (0.85 0))
    (critico (0.7 0) (0.85 1) (1.0 1))
  )
)

;;; Variable: Prioridad de mantenimiento (salida)
;;; Universo: [0, 100]
;;; Descripción: Nivel de prioridad recomendado para el mantenimiento
(deftemplate prioridad
  0 100 puntos
  (
    (baja (0 1) (20 1) (35 0))
    (media (20 0) (35 1) (50 1) (65 0))
    (media_alta (50 0) (65 1) (75 1) (85 0))
    (alta (75 0) (85 1) (100 1))
  )
)

;;;----------------------------------------------------------------------
;;; REGLAS DE INFERENCIA BORROSA
;;;----------------------------------------------------------------------

;;; R1: Carga muy alta + temperatura alta → prioridad alta
;;; Justificación: La combinación de alta carga y temperatura elevada
;;; indica riesgo inminente de falla por sobrecalentamiento
(defrule R1-carga-temp-criticas
  "Si la carga es muy alta Y la temperatura es alta, entonces la prioridad es alta"
  (carga muy_alta)
  (temperatura alta)
  =>
  (assert (prioridad alta))
)

;;; R2: Vibración alta O historial frecuente → prioridad media-alta
;;; Justificación: Ambos síntomas indican deterioro mecánico que requiere atención
(defrule R2-sintomas-deterioro
  "Si la vibración es alta O el historial de fallas es frecuente, entonces la prioridad es media-alta"
  (or
    (vibracion alta)
    (historial_fallas frecuente)
  )
  =>
  (assert (prioridad media_alta))
)

;;; R3: Cliente crítico + temperatura media-alta → prioridad alta
;;; Justificación: Clientes críticos (hospitales, bombeo) no pueden tolerar fallas
(defrule R3-cliente-critico
  "Si la criticidad del cliente es crítica Y la temperatura es media-alta, entonces la prioridad es alta"
  (criticidad critico)
  (temperatura media_alta)
  =>
  (assert (prioridad alta))
)

;;; R4: Carga baja + historial bajo → prioridad baja
;;; Justificación: Transformador operando en condiciones normales sin historial problemático
(defrule R4-operacion-normal
  "Si la carga es baja Y el historial de fallas es bajo, entonces la prioridad es baja"
  (carga baja)
  (historial_fallas bajo)
  =>
  (assert (prioridad baja))
)

;;; R5: Vibración media + temperatura media → prioridad media
;;; Justificación: Síntomas moderados requieren monitoreo pero no intervención urgente
(defrule R5-sintomas-moderados
  "Si la vibración es media Y la temperatura es media, entonces la prioridad es media"
  (vibracion media)
  (temperatura media)
  =>
  (assert (prioridad media))
)

;;; R6: Carga alta + cliente crítico → prioridad alta
;;; Justificación: Alta demanda en cliente crítico aumenta riesgo de falla con alto impacto
(defrule R6-alta-demanda-critica
  "Si la carga es alta Y el cliente es crítico, entonces la prioridad es alta"
  (carga alta)
  (criticidad critico)
  =>
  (assert (prioridad alta))
)

;;; R7: Historial intermitente + vibración media → prioridad media-alta
;;; Justificación: Patrón intermitente sugiere problema recurrente que requiere investigación
(defrule R7-patron-intermitente
  "Si el historial es intermitente Y la vibración es media, entonces la prioridad es media-alta"
  (historial_fallas intermitente)
  (vibracion media)
  =>
  (assert (prioridad media_alta))
)

;;;----------------------------------------------------------------------
;;; FUNCIONES AUXILIARES
;;;----------------------------------------------------------------------

;;; Función para mostrar resumen de entrada
(deffunction mostrar-entrada ()
  (printout t crlf)
  (printout t "========================================" crlf)
  (printout t "  DATOS DE ENTRADA DEL TRANSFORMADOR   " crlf)
  (printout t "========================================" crlf)
  (facts)
  (printout t crlf)
)

;;; Función para mostrar resultado de inferencia
(deffunction mostrar-resultado ()
  (printout t crlf)
  (printout t "========================================" crlf)
  (printout t "  RESULTADO DE INFERENCIA BORROSA      " crlf)
  (printout t "========================================" crlf)
  (printout t "Prioridad calculada:" crlf)
  (facts)
  (printout t crlf)
)

;;; Función para inicializar parámetros de inferencia
(deffunction configurar-inferencia ()
  ; Configuración de t-norma: MIN (Zadeh)
  ; Justificación: Conservadora, adecuada para aplicaciones de seguridad
  (set-fuzzy-intersection min)
  
  ; Configuración de s-norma: MAX (Zadeh)
  ; Justificación: Par estándar con MIN, mantiene propiedades duales
  (set-fuzzy-union max)
  
  ; Configuración de implicación: Gödel (Rc)
  ; Justificación: Preserva verdad en sistemas deductivos, adecuada para GMP
  (printout t "Configuración de inferencia:" crlf)
  (printout t "  - T-norma: MIN (Zadeh)" crlf)
  (printout t "  - S-norma: MAX (Zadeh)" crlf)
  (printout t "  - Implicación: Gödel" crlf)
  (printout t crlf)
)
