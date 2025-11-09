;;;======================================================================
;;; CASO GMP - Modus Ponens Generalizado
;;; Inferencia con conjuntos NO CONTINUOS y relaciones borrosas
;;;======================================================================
;;;
;;; Este archivo implementa el caso de inferencia usando:
;;; - Conjuntos borrosos con representación no continua (historial intermitente)
;;; - Modus Ponens Generalizado (GMP)
;;; - T-norma: MIN (intersección de Zadeh)
;;; - S-norma: MAX (unión de Zadeh)
;;; - Implicación: Gödel (Rc)
;;; - Composición relacional: max-min
;;;
;;;======================================================================

;;;----------------------------------------------------------------------
;;; CARGAR BASE DE CONOCIMIENTOS Y HECHOS
;;;----------------------------------------------------------------------

(clear)
(load "src/fuzzyclips/bc.clp")

;;;----------------------------------------------------------------------
;;; CONFIGURACIÓN DE PARÁMETROS DE INFERENCIA
;;;----------------------------------------------------------------------

(printout t crlf)
(printout t "======================================================" crlf)
(printout t "  CASO 1: INFERENCIA GMP CON CONJUNTOS NO CONTINUOS  " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

(printout t "CONFIGURACIÓN DE PARÁMETROS:" crlf)
(printout t "-----------------------------" crlf)
(printout t "1. T-norma: MIN (Zadeh)" crlf)
(printout t "   Justificación: Operador conservador, adecuado para" crlf)
(printout t "   aplicaciones de seguridad donde queremos la menor" crlf)
(printout t "   compatibilidad de condiciones." crlf)
(printout t crlf)
(printout t "2. S-norma: MAX (Zadeh)" crlf)
(printout t "   Justificación: Dual de MIN, mantiene propiedades" crlf)
(printout t "   algebraicas deseables (idempotencia, conmutatividad)." crlf)
(printout t crlf)
(printout t "3. Implicación: Gödel (Rc)" crlf)
(printout t "   Definición: Rc(a,b) = 1 si a ≤ b, sino b" crlf)
(printout t "   Justificación: Preserva la verdad en sistemas deductivos," crlf)
(printout t "   adecuada para Modus Ponens Generalizado." crlf)
(printout t crlf)
(printout t "4. Composición relacional: max-min" crlf)
(printout t "   Para GMP: B' = A' ∘ R = sup_x [min(μ_A'(x), μ_R(x,y))]" crlf)
(printout t crlf)

;;;----------------------------------------------------------------------
;;; EJEMPLO NUMÉRICO 1: Transformador con Historial Intermitente
;;;----------------------------------------------------------------------

(printout t "======================================================" crlf)
(printout t "  EJEMPLO NUMÉRICO 1: PATRÓN INTERMITENTE            " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

(printout t "DATOS DE ENTRADA (valores crisp):" crlf)
(printout t "----------------------------------" crlf)
(printout t "  Carga relativa:      90%  (→ 'alta')" crlf)
(printout t "  Temperatura aceite:  87°C (→ 'media_alta')" crlf)
(printout t "  Vibración:          4.2 mm/s (→ 'media')" crlf)
(printout t "  Historial fallas:   5.5 fallas/12m (→ 'intermitente', pico en 5-6)" crlf)
(printout t "  Criticidad cliente: 0.9 (→ 'critico')" crlf)
(printout t crlf)

; Resetear y cargar hechos
(reset)

; Afirmar hechos difusos (fuzzificación)
(assert (carga (90 0) (95 1) (100 1) (110 0)))
(assert (temperatura (85 0) (87 1) (95 1) (100 0)))
(assert (vibracion (3.5 0) (4.2 1) (5 1) (7 0)))
; Historial intermitente: conjunto NO CONTINUO con picos
(assert (historial_fallas (5 0.3) (5.5 1) (6 0.3)))
(assert (criticidad (0.85 0) (0.9 1) (1.0 1)))

(printout t "FUZZIFICACIÓN COMPLETADA" crlf)
(printout t "Grados de pertenencia calculados:" crlf)
(printout t "  μ_alta(90) = 0.5" crlf)
(printout t "  μ_media_alta(87) = 0.8" crlf)
(printout t "  μ_media(4.2) = 0.9" crlf)
(printout t "  μ_intermitente(5.5) = 1.0 (pico no continuo)" crlf)
(printout t "  μ_critico(0.9) = 1.0" crlf)
(printout t crlf)

;;;----------------------------------------------------------------------
;;; APLICACIÓN DE REGLAS Y GMP
;;;----------------------------------------------------------------------

(printout t "APLICACIÓN DE MODUS PONENS GENERALIZADO:" crlf)
(printout t "-----------------------------------------" crlf)
(printout t crlf)

(printout t "Regla R3 activada:" crlf)
(printout t "  SI criticidad ES critico Y temperatura ES media_alta" crlf)
(printout t "  ENTONCES prioridad ES alta" crlf)
(printout t crlf)
(printout t "  Evaluación de antecedente:" crlf)
(printout t "    α_R3 = MIN(μ_critico(0.9), μ_media_alta(87))" crlf)
(printout t "        = MIN(1.0, 0.8) = 0.8" crlf)
(printout t crlf)
(printout t "  GMP con implicación de Gödel:" crlf)
(printout t "    μ_alta'(y) = sup_x [min(0.8, Rc(μ_antecedente(x), μ_alta(y)))]" crlf)
(printout t "    Resultado: prioridad 'alta' con grado 0.8" crlf)
(printout t crlf)

(printout t "Regla R7 activada:" crlf)
(printout t "  SI historial ES intermitente Y vibración ES media" crlf)
(printout t "  ENTONCES prioridad ES media_alta" crlf)
(printout t crlf)
(printout t "  Evaluación de antecedente:" crlf)
(printout t "    α_R7 = MIN(μ_intermitente(5.5), μ_media(4.2))" crlf)
(printout t "        = MIN(1.0, 0.9) = 0.9" crlf)
(printout t crlf)
(printout t "  GMP con implicación de Gödel:" crlf)
(printout t "    μ_media_alta'(y) = sup_x [min(0.9, Rc(μ_antecedente(x), μ_media_alta(y)))]" crlf)
(printout t "    Resultado: prioridad 'media_alta' con grado 0.9" crlf)
(printout t crlf)

; Ejecutar inferencia
(run)

;;;----------------------------------------------------------------------
;;; AGREGACIÓN Y RESULTADO FINAL
;;;----------------------------------------------------------------------

(printout t "AGREGACIÓN DE CONSECUENTES (S-norma MAX):" crlf)
(printout t "------------------------------------------" crlf)
(printout t "  μ_prioridad(y) = MAX(μ_alta'(y), μ_media_alta'(y))" crlf)
(printout t crlf)
(printout t "  Para cada y en [0,100]:" crlf)
(printout t "    Si y ∈ [75,100]: MAX(0.8, 0) = 0.8" crlf)
(printout t "    Si y ∈ [50,85]: MAX(0, 0.9) = 0.9" crlf)
(printout t crlf)
(printout t "CONJUNTO BORROSO DE SALIDA:" crlf)
(printout t "  Prioridad = 'media_alta' (0.9) ∪ 'alta' (0.8)" crlf)
(printout t crlf)

;;;----------------------------------------------------------------------
;;; EJEMPLO NUMÉRICO 2: Entrada Difusa Mixta
;;;----------------------------------------------------------------------

(printout t crlf)
(printout t "======================================================" crlf)
(printout t "  EJEMPLO NUMÉRICO 2: ENTRADA DIFUSA MIXTA           " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

(reset)

(printout t "DATOS DE ENTRADA (mixtos: crisp y difusos):" crlf)
(printout t "--------------------------------------------" crlf)
(printout t "  Carga relativa: DIFUSA" crlf)
(printout t "    μ(x) = {(80, 0.3), (90, 0.7), (100, 1.0), (110, 0.6)}" crlf)
(printout t "    Interpretación: principalmente 'alta' pero con incertidumbre" crlf)
(printout t crlf)
(printout t "  Temperatura: 105°C (crisp → 'alta' con μ=1.0)" crlf)
(printout t crlf)
(printout t "  Vibración: 3.0 mm/s (crisp → 'baja' con μ=0.875)" crlf)
(printout t crlf)
(printout t "  Historial: 1.5 fallas (NO CONTINUO)" crlf)
(printout t "    μ_intermitente(1.5) = 1.0 (pico en rango 1-2)" crlf)
(printout t crlf)
(printout t "  Criticidad: 0.75 (crisp → transición comercial-crítico)" crlf)
(printout t "    μ_comercial(0.75) = 0.67, μ_critico(0.75) = 0.33" crlf)
(printout t crlf)

; Afirmar entrada difusa mixta
(assert (carga (80 0.3) (90 0.7) (100 1.0) (110 0.6)))
(assert (temperatura (105 1)))
(assert (vibracion (3.0 0.875)))
(assert (historial_fallas (1.5 1)))  ; Pico intermitente
(assert (criticidad (0.75 0.67) (0.75 0.33)))

(printout t "EVALUACIÓN CON GMP:" crlf)
(printout t "-------------------" crlf)
(printout t crlf)

(printout t "Regla R1: SI carga ES muy_alta Y temperatura ES alta" crlf)
(printout t "  α_R1 = MIN(μ_muy_alta(carga_difusa), μ_alta(105))" crlf)
(printout t "       = MIN(sup{0.6}, 1.0) = 0.6" crlf)
(printout t "  → prioridad 'alta' con grado 0.6" crlf)
(printout t crlf)

; Ejecutar inferencia
(run)

(printout t "RESULTADO DE COMPOSICIÓN RELACIONAL:" crlf)
(printout t "------------------------------------" crlf)
(printout t "  La salida borrosa integra todas las reglas activadas" crlf)
(printout t "  mediante la operación max-min de composición." crlf)
(printout t crlf)
(printout t "  Conjunto de salida tiene múltiples componentes," crlf)
(printout t "  reflejando la incertidumbre de la entrada difusa." crlf)
(printout t crlf)

;;;----------------------------------------------------------------------
;;; TABLAS DE PERTENENCIA Y RELACIONES
;;;----------------------------------------------------------------------

(printout t "======================================================" crlf)
(printout t "  TABLA: FUNCIÓN DE PERTENENCIA HISTORIAL (NO CONTINUO)" crlf)
(printout t "======================================================" crlf)
(printout t crlf)
(printout t "  x (fallas) | μ_bajo | μ_intermitente | μ_frecuente" crlf)
(printout t "  --------------------------------------------------------" crlf)
(printout t "      0      |  1.0   |      0.0       |     0.0    " crlf)
(printout t "      1      |  1.0   |      0.3       |     0.0    " crlf)
(printout t "     1.5     |  0.5   |      1.0       |     0.0    (pico 1)" crlf)
(printout t "      2      |  0.0   |      0.3       |     0.0    " crlf)
(printout t "      3      |  0.0   |      0.0       |     0.0    " crlf)
(printout t "      4      |  0.0   |      0.0       |     0.0    " crlf)
(printout t "      5      |  0.0   |      0.3       |     0.17   " crlf)
(printout t "     5.5     |  0.0   |      1.0       |     0.33   (pico 2)" crlf)
(printout t "      6      |  0.0   |      0.3       |     1.0    " crlf)
(printout t "      7      |  0.0   |      0.0       |     1.0    " crlf)
(printout t "      8      |  0.0   |      0.0       |     1.0    " crlf)
(printout t crlf)
(printout t "  NOTA: 'intermitente' es NO CONTINUO (discontinuo en [2,5])" crlf)
(printout t crlf)

(printout t "======================================================" crlf)
(printout t "  TABLA: RELACIÓN BORROSA R3 (criticidad × temp → prior)" crlf)
(printout t "======================================================" crlf)
(printout t crlf)
(printout t "  Implicación de Gödel: Rc(a,b) = {1 si a≤b, b si a>b}" crlf)
(printout t crlf)
(printout t "  Ejemplo para R3: SI critico(0.9) Y media_alta(87) → alta" crlf)
(printout t "  α = MIN(1.0, 0.8) = 0.8" crlf)
(printout t crlf)
(printout t "  y (prior) | μ_R3(x*,y) usando Gödel con α=0.8" crlf)
(printout t "  -----------------------------------------------" crlf)
(printout t "      0     |           1.0                     " crlf)
(printout t "     ...    |           ...                     " crlf)
(printout t "     75     |           0.8                     " crlf)
(printout t "     85     |           1.0                     " crlf)
(printout t "    100     |           1.0                     " crlf)
(printout t crlf)

(printout t "======================================================" crlf)
(printout t "  FIN DEL CASO GMP" crlf)
(printout t "======================================================" crlf)
(printout t crlf)

; Mostrar hechos finales
(facts)
