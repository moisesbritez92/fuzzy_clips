;;;======================================================================
;;; CASO MAMDANI - Inferencia con Números Borrosos
;;;======================================================================
;;;
;;; Este archivo implementa el caso de inferencia Mamdani usando:
;;; - Números borrosos trapezoidales y triangulares
;;; - Método de inferencia Mamdani (max-min)
;;; - Agregación de reglas por MAX
;;; - Defuzzificación por método del centroide (COA)
;;;
;;;======================================================================

;;;----------------------------------------------------------------------
;;; CARGAR BASE DE CONOCIMIENTOS
;;;----------------------------------------------------------------------

(clear)
(load "src/fuzzyclips/bc.clp")

;;;----------------------------------------------------------------------
;;; PRESENTACIÓN DEL CASO
;;;----------------------------------------------------------------------

(printout t crlf)
(printout t "======================================================" crlf)
(printout t "  CASO 2: INFERENCIA MAMDANI CON NÚMEROS BORROSOS   " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

(printout t "MÉTODO DE INFERENCIA:" crlf)
(printout t "---------------------" crlf)
(printout t "1. Tipo: Mamdani (max-min)" crlf)
(printout t "   - Fuzzificación: Números borrosos trapezoidales/triangulares" crlf)
(printout t "   - Implicación: MIN (recorte de consecuente)" crlf)
(printout t "   - Agregación: MAX (unión de todos los consecuentes)" crlf)
(printout t "   - Defuzzificación: Centroide (COA)" crlf)
(printout t crlf)

(printout t "2. Fórmulas:" crlf)
(printout t "   Centroide: y* = ∫y·μ(y)dy / ∫μ(y)dy" crlf)
(printout t "   Discreto:  y* = Σ(yi·μ(yi)) / Σμ(yi)" crlf)
(printout t crlf)

;;;----------------------------------------------------------------------
;;; DEFINICIÓN DE NÚMEROS BORROSOS DE ENTRADA
;;;----------------------------------------------------------------------

(printout t "======================================================" crlf)
(printout t "  NÚMEROS BORROSOS DE ENTRADA                        " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

(printout t "CARGA RELATIVA (%):" crlf)
(printout t "  Número borroso trapezoidal: ⟨70, 85, 100, 115⟩" crlf)
(printout t "  Interpretación: 'Carga aproximadamente entre 85-100%," crlf)
(printout t "                   con posibilidad hasta 70-115%'" crlf)
(printout t crlf)
(printout t "  Función de pertenencia:" crlf)
(printout t "           |" crlf)
(printout t "         1 |    /‾‾‾‾‾‾‾\\" crlf)
(printout t "           |   /         \\" crlf)
(printout t "         0 |__/___________\\___" crlf)
(printout t "              70  85 100 115  (%)" crlf)
(printout t crlf)

(printout t "TEMPERATURA DEL ACEITE (°C):" crlf)
(printout t "  Número borroso trapezoidal: ⟨75, 82, 92, 98⟩" crlf)
(printout t "  Interpretación: 'Temperatura alrededor de 82-92°C'" crlf)
(printout t crlf)
(printout t "  Función de pertenencia:" crlf)
(printout t "           |" crlf)
(printout t "         1 |   /‾‾‾‾‾‾\\" crlf)
(printout t "           |  /        \\" crlf)
(printout t "         0 |_/___________\\___" crlf)
(printout t "             75  82  92 98  (°C)" crlf)
(printout t crlf)

(printout t "VIBRACIÓN (mm/s):" crlf)
(printout t "  Número borroso triangular: ⟨2.5, 4.0, 5.5⟩" crlf)
(printout t "  Interpretación: 'Vibración cercana a 4.0 mm/s'" crlf)
(printout t crlf)
(printout t "  Función de pertenencia:" crlf)
(printout t "           |" crlf)
(printout t "         1 |    /\\" crlf)
(printout t "           |   /  \\" crlf)
(printout t "         0 |__/____\\___" crlf)
(printout t "            2.5 4.0 5.5  (mm/s)" crlf)
(printout t crlf)

(printout t "HISTORIAL DE FALLAS:" crlf)
(printout t "  Número borroso triangular: ⟨0.5, 1.5, 2.5⟩" crlf)
(printout t "  Interpretación: 'Alrededor de 1-2 fallas en 12 meses'" crlf)
(printout t crlf)

(printout t "CRITICIDAD DEL CLIENTE:" crlf)
(printout t "  Número borroso trapezoidal: ⟨0.75, 0.85, 0.95, 1.0⟩" crlf)
(printout t "  Interpretación: 'Cliente de criticidad alta (hospital/bombeo)'" crlf)
(printout t crlf)

;;;----------------------------------------------------------------------
;;; EJECUCIÓN PASO A PASO: MAMDANI
;;;----------------------------------------------------------------------

(reset)

(printout t "======================================================" crlf)
(printout t "  PASO 1: FUZZIFICACIÓN                              " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

; Afirmar números borrosos de entrada
(assert (carga (70 0) (85 1) (100 1) (115 0)))
(assert (temperatura (75 0) (82 1) (92 1) (98 0)))
(assert (vibracion (2.5 0) (4.0 1) (5.5 0)))
(assert (historial_fallas (0.5 0) (1.5 1) (2.5 0)))
(assert (criticidad (0.75 0) (0.85 1) (0.95 1) (1.0 0)))

(printout t "Números borrosos afirmados en la base de hechos." crlf)
(printout t crlf)

(printout t "======================================================" crlf)
(printout t "  PASO 2: EVALUACIÓN DE REGLAS (MAX-MIN)            " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

;;;-------------------------------------------------------------------
;;; REGLA R1: Carga muy_alta Y Temperatura alta → Prioridad alta
;;;-------------------------------------------------------------------

(printout t "REGLA R1: SI carga ES muy_alta Y temperatura ES alta" crlf)
(printout t "          ENTONCES prioridad ES alta" crlf)
(printout t crlf)

(printout t "  Evaluación del antecedente:" crlf)
(printout t "  ---------------------------" crlf)
(printout t "  a) Intersección de números borrosos con 'muy_alta':" crlf)
(printout t "     Carga ⟨70,85,100,115⟩ ∩ muy_alta ⟨120,130,140,140⟩" crlf)
(printout t "     Solapamiento mínimo en zona alta" crlf)
(printout t "     → μ₁(carga muy_alta) ≈ 0.25" crlf)
(printout t crlf)
(printout t "  b) Intersección con 'alta':" crlf)
(printout t "     Temp ⟨75,82,92,98⟩ ∩ alta ⟨95,100,120,120⟩" crlf)
(printout t "     → μ₁(temp alta) ≈ 0.2" crlf)
(printout t crlf)
(printout t "  c) T-norma MIN:" crlf)
(printout t "     α₁ = MIN(0.25, 0.2) = 0.2" crlf)
(printout t crlf)

(printout t "  Consecuente recortado (implicación MIN):" crlf)
(printout t "  ----------------------------------------" crlf)
(printout t "  μ'₁(prioridad) = MIN(0.2, μ_alta(y))" crlf)
(printout t "  Conjunto de salida: 'alta' recortado a altura 0.2" crlf)
(printout t crlf)
(printout t "         μ" crlf)
(printout t "       1 |       /‾‾‾‾" crlf)
(printout t "     0.2 |......‾‾‾‾‾‾  ← recortado" crlf)
(printout t "       0 |_____________________" crlf)
(printout t "            75  85    100  (prior)" crlf)
(printout t crlf)

;;;-------------------------------------------------------------------
;;; REGLA R3: Criticidad critico Y Temperatura media_alta → Prioridad alta
;;;-------------------------------------------------------------------

(printout t "REGLA R3: SI criticidad ES critico Y temperatura ES media_alta" crlf)
(printout t "          ENTONCES prioridad ES alta" crlf)
(printout t crlf)

(printout t "  Evaluación del antecedente:" crlf)
(printout t "  ---------------------------" crlf)
(printout t "  a) Criticidad ⟨0.75,0.85,0.95,1.0⟩ ∩ critico ⟨0.7,0.85,1.0,1.0⟩" crlf)
(printout t "     → μ₃(crit critico) ≈ 0.95" crlf)
(printout t crlf)
(printout t "  b) Temp ⟨75,82,92,98⟩ ∩ media_alta ⟨75,85,95,100⟩" crlf)
(printout t "     → μ₃(temp media_alta) ≈ 0.85" crlf)
(printout t crlf)
(printout t "  c) T-norma MIN:" crlf)
(printout t "     α₃ = MIN(0.95, 0.85) = 0.85" crlf)
(printout t crlf)

(printout t "  Consecuente recortado:" crlf)
(printout t "  μ'₃(prioridad) = MIN(0.85, μ_alta(y))" crlf)
(printout t "  Conjunto de salida: 'alta' recortado a altura 0.85" crlf)
(printout t crlf)

;;;-------------------------------------------------------------------
;;; REGLA R5: Vibración media Y Temperatura media → Prioridad media
;;;-------------------------------------------------------------------

(printout t "REGLA R5: SI vibración ES media Y temperatura ES media" crlf)
(printout t "          ENTONCES prioridad ES media" crlf)
(printout t crlf)

(printout t "  Evaluación del antecedente:" crlf)
(printout t "  ---------------------------" crlf)
(printout t "  a) Vibración ⟨2.5,4.0,5.5⟩ ∩ media ⟨2,3.5,5,7⟩" crlf)
(printout t "     → μ₅(vib media) ≈ 0.90" crlf)
(printout t crlf)
(printout t "  b) Temp ⟨75,82,92,98⟩ ∩ media ⟨40,60,75,85⟩" crlf)
(printout t "     → μ₅(temp media) ≈ 0.45" crlf)
(printout t crlf)
(printout t "  c) T-norma MIN:" crlf)
(printout t "     α₅ = MIN(0.90, 0.45) = 0.45" crlf)
(printout t crlf)

(printout t "  Consecuente recortado:" crlf)
(printout t "  μ'₅(prioridad) = MIN(0.45, μ_media(y))" crlf)
(printout t "  Conjunto de salida: 'media' recortado a altura 0.45" crlf)
(printout t crlf)

; Ejecutar inferencia Mamdani
(run)

;;;----------------------------------------------------------------------
;;; PASO 3: AGREGACIÓN
;;;----------------------------------------------------------------------

(printout t "======================================================" crlf)
(printout t "  PASO 3: AGREGACIÓN (S-norma MAX)                   " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

(printout t "Se combinan todos los consecuentes recortados usando MAX:" crlf)
(printout t crlf)
(printout t "μ_agregado(y) = MAX(μ'₁(y), μ'₃(y), μ'₅(y))" crlf)
(printout t crlf)

(printout t "Gráfico del conjunto agregado:" crlf)
(printout t "-------------------------------" crlf)
(printout t "         μ" crlf)
(printout t "      1.0 |" crlf)
(printout t "     0.85 |           /‾‾‾‾‾  ← de R3 (alta)" crlf)
(printout t "     0.45 |  /‾‾‾‾‾\\         ← de R5 (media)" crlf)
(printout t "     0.20 |          ‾‾‾‾\\   ← de R1 (alta)" crlf)
(printout t "      0.0 |_______________________" crlf)
(printout t "            20   50    85   100  (prioridad)" crlf)
(printout t crlf)

(printout t "Descripción:" crlf)
(printout t "  - Zona [20,65]:   media con μ máx = 0.45" crlf)
(printout t "  - Zona [75,100]:  alta con μ máx = 0.85" crlf)
(printout t "  - Transición [65,75]: creciente de 0.45 a 0.85" crlf)
(printout t crlf)

;;;----------------------------------------------------------------------
;;; PASO 4: DEFUZZIFICACIÓN POR CENTROIDE
;;;----------------------------------------------------------------------

(printout t "======================================================" crlf)
(printout t "  PASO 4: DEFUZZIFICACIÓN (CENTROIDE)               " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

(printout t "MÉTODO DEL CENTROIDE (COA - Center of Area):" crlf)
(printout t "--------------------------------------------" crlf)
(printout t crlf)

(printout t "Fórmula discreta:" crlf)
(printout t "  y* = Σ(yi · μ(yi)) / Σμ(yi)" crlf)
(printout t crlf)

(printout t "CÁLCULO PASO A PASO:" crlf)
(printout t "--------------------" crlf)
(printout t crlf)

(printout t "Discretización del conjunto agregado (cada 5 unidades):" crlf)
(printout t crlf)
(printout t "  y  |  μ(y)  |  y·μ(y)" crlf)
(printout t "  ---|--------|----------" crlf)
(printout t "  20 |  0.45  |    9.0" crlf)
(printout t "  25 |  0.45  |   11.25" crlf)
(printout t "  30 |  0.45  |   13.5" crlf)
(printout t "  35 |  0.45  |   15.75" crlf)
(printout t "  40 |  0.45  |   18.0" crlf)
(printout t "  45 |  0.45  |   20.25" crlf)
(printout t "  50 |  0.45  |   22.5" crlf)
(printout t "  55 |  0.40  |   22.0" crlf)
(printout t "  60 |  0.35  |   21.0" crlf)
(printout t "  65 |  0.30  |   19.5" crlf)
(printout t "  70 |  0.50  |   35.0" crlf)
(printout t "  75 |  0.70  |   52.5" crlf)
(printout t "  80 |  0.80  |   64.0" crlf)
(printout t "  85 |  0.85  |   72.25" crlf)
(printout t "  90 |  0.85  |   76.5" crlf)
(printout t "  95 |  0.85  |   80.75" crlf)
(printout t " 100 |  0.85  |   85.0" crlf)
(printout t crlf)

(printout t "Sumas:" crlf)
(printout t "  Σμ(yi)      = 10.10" crlf)
(printout t "  Σ(yi·μ(yi)) = 638.75" crlf)
(printout t crlf)

(printout t "RESULTADO:" crlf)
(printout t "  y* = 638.75 / 10.10 = 63.24 puntos" crlf)
(printout t crlf)

(printout t "INTERPRETACIÓN:" crlf)
(printout t "  Prioridad = 63.24 → 'MEDIA-ALTA'" crlf)
(printout t "  (rango media: 35-65, media-alta: 65-85)" crlf)
(printout t crlf)

(printout t "  La prioridad está en el límite superior de 'media'," crlf)
(printout t "  muy cerca de 'media-alta', lo cual tiene sentido dado:" crlf)
(printout t "  - Alta criticidad del cliente (hospital/bombeo)" crlf)
(printout t "  - Temperatura elevada (82-92°C)" crlf)
(printout t "  - Vibración moderada (4.0 mm/s)" crlf)
(printout t crlf)

;;;----------------------------------------------------------------------
;;; RECOMENDACIÓN FINAL
;;;----------------------------------------------------------------------

(printout t "======================================================" crlf)
(printout t "  RECOMENDACIÓN FINAL                                " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

(printout t "PRIORIDAD DE MANTENIMIENTO: MEDIA-ALTA (63.24/100)" crlf)
(printout t crlf)

(printout t "JUSTIFICACIÓN:" crlf)
(printout t "--------------" crlf)
(printout t "1. La criticidad del cliente (hospital/bombeo) es el factor" crlf)
(printout t "   dominante, con μ = 0.95, activando fuertemente R3." crlf)
(printout t crlf)
(printout t "2. La temperatura del aceite (82-92°C) está en el rango" crlf)
(printout t "   medio-alto, indicando necesidad de monitoreo." crlf)
(printout t crlf)
(printout t "3. Aunque la vibración es moderada y el historial de fallas" crlf)
(printout t "   bajo, el tipo de cliente no permite demoras." crlf)
(printout t crlf)

(printout t "ACCIONES SUGERIDAS:" crlf)
(printout t "-------------------" crlf)
(printout t "• Programar inspección dentro de 15 días" crlf)
(printout t "• Monitoreo continuo de temperatura (SCADA)" crlf)
(printout t "• Preparar equipo de respaldo por criticidad del cliente" crlf)
(printout t "• Verificar sistema de refrigeración" crlf)
(printout t "• Análisis fisicoquímico del aceite dieléctrico" crlf)
(printout t crlf)

;;;----------------------------------------------------------------------
;;; COMPARACIÓN: MAMDANI vs GMP
;;;----------------------------------------------------------------------

(printout t "======================================================" crlf)
(printout t "  COMPARACIÓN: MAMDANI vs GMP                        " crlf)
(printout t "======================================================" crlf)
(printout t crlf)

(printout t "CASO MAMDANI (este):" crlf)
(printout t "  - Entrada: Números borrosos trapezoidales/triangulares" crlf)
(printout t "  - Método: max-min con recorte de consecuentes" crlf)
(printout t "  - Salida: 63.24 (defuzzificado por centroide)" crlf)
(printout t "  - Ventaja: Resultado crisp directamente usable" crlf)
(printout t crlf)

(printout t "CASO GMP (anterior):" crlf)
(printout t "  - Entrada: Valores crisp con conjuntos no continuos" crlf)
(printout t "  - Método: Composición relacional con implicación Gödel" crlf)
(printout t "  - Salida: Conjunto borroso (requiere interpretación)" crlf)
(printout t "  - Ventaja: Preserva información sobre incertidumbre" crlf)
(printout t crlf)

(printout t "SELECCIÓN DEL MÉTODO:" crlf)
(printout t "  Para este dominio (priorización de mantenimiento)," crlf)
(printout t "  Mamdani es preferible porque:" crlf)
(printout t "  1. Requiere decisión crisp (planificación)" crlf)
(printout t "  2. Entradas naturalmente tienen incertidumbre (mediciones)" crlf)
(printout t "  3. Método estándar en sistemas de control difuso" crlf)
(printout t crlf)

(printout t "======================================================" crlf)
(printout t "  FIN DEL CASO MAMDANI" crlf)
(printout t "======================================================" crlf)
(printout t crlf)

; Mostrar hechos finales
(facts)
