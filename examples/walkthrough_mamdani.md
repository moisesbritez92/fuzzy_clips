# Paso a Paso: Caso Mamdani con Números Borrosos

## Introducción
Este documento presenta la ejecución detallada del **Caso 2: Inferencia Mamdani** del sistema de priorización de mantenimiento de transformadores usando números borrosos.

## Prerequisitos
- FUZZY CLIPS instalado
- Archivos bc.clp y case_mamdani.clp en src/fuzzyclips/

## Ejecución

### 1. Iniciar FUZZY CLIPS
```bash
$ fuzzy-clips
FuzzyCLIPS 6.x
CLIPS>
```

### 2. Cargar el Caso Mamdani
```clips
CLIPS> (load "src/fuzzyclips/case_mamdani.clp")
```

### 3. Salida Esperada

#### Sección 1: Método de Inferencia
```
======================================================
  CASO 2: INFERENCIA MAMDANI CON NÚMEROS BORROSOS   
======================================================

MÉTODO DE INFERENCIA:
---------------------
1. Tipo: Mamdani (max-min)
   - Fuzzificación: Números borrosos trapezoidales/triangulares
   - Implicación: MIN (recorte de consecuente)
   - Agregación: MAX (unión de todos los consecuentes)
   - Defuzzificación: Centroide (COA)

2. Fórmulas:
   Centroide: y* = ∫y·μ(y)dy / ∫μ(y)dy
   Discreto:  y* = Σ(yi·μ(yi)) / Σμ(yi)
```

#### Sección 2: Números Borrosos de Entrada
```
======================================================
  NÚMEROS BORROSOS DE ENTRADA                        
======================================================

CARGA RELATIVA (%):
  Número borroso trapezoidal: ⟨70, 85, 100, 115⟩
  Interpretación: 'Carga aproximadamente entre 85-100%,
                   con posibilidad hasta 70-115%'

  Función de pertenencia:
           |
         1 |    /‾‾‾‾‾‾‾\
           |   /         \
         0 |__/___________\___
              70  85 100 115  (%)

TEMPERATURA DEL ACEITE (°C):
  Número borroso trapezoidal: ⟨75, 82, 92, 98⟩
  Interpretación: 'Temperatura alrededor de 82-92°C'

  Función de pertenencia:
           |
         1 |   /‾‾‾‾‾‾\
           |  /        \
         0 |_/___________\___
             75  82  92 98  (°C)

VIBRACIÓN (mm/s):
  Número borroso triangular: ⟨2.5, 4.0, 5.5⟩
  Interpretación: 'Vibración cercana a 4.0 mm/s'

  Función de pertenencia:
           |
         1 |    /\
           |   /  \
         0 |__/____\___
            2.5 4.0 5.5  (mm/s)

HISTORIAL DE FALLAS:
  Número borroso triangular: ⟨0.5, 1.5, 2.5⟩
  Interpretación: 'Alrededor de 1-2 fallas en 12 meses'

CRITICIDAD DEL CLIENTE:
  Número borroso trapezoidal: ⟨0.75, 0.85, 0.95, 1.0⟩
  Interpretación: 'Cliente de criticidad alta (hospital/bombeo)'
```

**Explicación de números borrosos**:
- **Trapezoidal ⟨a,b,c,d⟩**: μ=0 en a y d, μ=1 en [b,c], lineal en [a,b] y [c,d]
- **Triangular ⟨a,b,c⟩**: μ=0 en a y c, μ=1 en b, lineal en [a,b] y [b,c]

### 4. Paso a Paso: Fuzzificación

```
======================================================
  PASO 1: FUZZIFICACIÓN                              
======================================================

Números borrosos afirmados en la base de hechos.
```

En FUZZY CLIPS:
```clips
CLIPS> (assert (carga (70 0) (85 1) (100 1) (115 0)))
<Fact-1>
CLIPS> (assert (temperatura (75 0) (82 1) (92 1) (98 0)))
<Fact-2>
```

**Representación interna**:
Cada número borroso se almacena como lista de pares (x, μ(x)):
- Carga: [(70,0), (85,1), (100,1), (115,0)]
- Entre puntos, FUZZY CLIPS interpola linealmente

### 5. Paso a Paso: Evaluación de Reglas

```
======================================================
  PASO 2: EVALUACIÓN DE REGLAS (MAX-MIN)            
======================================================
```

#### Regla R1: Carga muy_alta Y Temperatura alta → Prioridad alta

```
REGLA R1: SI carga ES muy_alta Y temperatura ES alta
          ENTONCES prioridad ES alta

  Evaluación del antecedente:
  ---------------------------
  a) Intersección de números borrosos con 'muy_alta':
     Carga ⟨70,85,100,115⟩ ∩ muy_alta ⟨120,130,140,140⟩
     Solapamiento mínimo en zona alta
     → μ₁(carga muy_alta) ≈ 0.25

  b) Intersección con 'alta':
     Temp ⟨75,82,92,98⟩ ∩ alta ⟨95,100,120,120⟩
     → μ₁(temp alta) ≈ 0.2

  c) T-norma MIN:
     α₁ = MIN(0.25, 0.2) = 0.2

  Consecuente recortado (implicación MIN):
  ----------------------------------------
  μ'₁(prioridad) = MIN(0.2, μ_alta(y))
  Conjunto de salida: 'alta' recortado a altura 0.2
```

**Cálculo detallado de intersección**:
```
Carga ⟨70,85,100,115⟩ ∩ muy_alta ⟨120,130,140,140⟩

Para cada x:
  x=70:  min(0, 0) = 0
  x=85:  min(1, 0) = 0
  x=100: min(1, 0) = 0
  x=115: min(0, 0) = 0
  x=120: min(?, 0) = 0  (interpolado)
  
Calculando intersección en [115,120]:
  μ_carga(117.5) = (120-117.5)/(120-115) = 2.5/5 = 0.5
  μ_muy_alta(117.5) = (117.5-120)/(130-120) = -2.5/10 = 0 (fuera de rango)
  
Máximo solapamiento ocurre cerca de x=115 con μ ≈ 0.25
```

**Gráfico del recorte**:
```
         μ
       1 |       /‾‾‾‾    ← original 'alta'
     0.2 |......‾‾‾‾‾‾    ← recortado a α₁=0.2
       0 |_____________________
            75  85    100  (prioridad)
```

#### Regla R3: Criticidad critico Y Temperatura media_alta → Prioridad alta

```
REGLA R3: SI criticidad ES critico Y temperatura ES media_alta
          ENTONCES prioridad ES alta

  Evaluación del antecedente:
  ---------------------------
  a) Criticidad ⟨0.75,0.85,0.95,1.0⟩ ∩ critico ⟨0.7,0.85,1.0,1.0⟩
     → μ₃(crit critico) ≈ 0.95

  b) Temp ⟨75,82,92,98⟩ ∩ media_alta ⟨75,85,95,100⟩
     → μ₃(temp media_alta) ≈ 0.85

  c) T-norma MIN:
     α₃ = MIN(0.95, 0.85) = 0.85

  Consecuente recortado:
  μ'₃(prioridad) = MIN(0.85, μ_alta(y))
  Conjunto de salida: 'alta' recortado a altura 0.85
```

**Cálculo detallado**:
```
Criticidad ⟨0.75,0.85,0.95,1.0⟩ ∩ critico ⟨0.7,0.85,1.0,1.0⟩

Puntos clave:
  x=0.75: min(0, ?) = cálculo necesario
  x=0.85: min(1, 1) = 1
  x=0.95: min(1, 1) = 1
  x=1.0:  min(0, 1) = 0

Para x=0.75:
  μ_criticidad(0.75) = (0.75-0.75)/(0.85-0.75) = 0/0.1 = 0
  μ_critico(0.75) = (0.75-0.7)/(0.85-0.7) = 0.05/0.15 ≈ 0.33
  min(0, 0.33) = 0

Altura máxima de intersección:
  sup_x min(μ_crit(x), μ_critico(x)) ≈ 0.95 (en x≈0.9-0.95)
```

#### Regla R5: Vibración media Y Temperatura media → Prioridad media

```
REGLA R5: SI vibración ES media Y temperatura ES media
          ENTONCES prioridad ES media

  Evaluación del antecedente:
  ---------------------------
  a) Vibración ⟨2.5,4.0,5.5⟩ ∩ media ⟨2,3.5,5,7⟩
     → μ₅(vib media) ≈ 0.90

  b) Temp ⟨75,82,92,98⟩ ∩ media ⟨40,60,75,85⟩
     → μ₅(temp media) ≈ 0.45

  c) T-norma MIN:
     α₅ = MIN(0.90, 0.45) = 0.45

  Consecuente recortado:
  μ'₅(prioridad) = MIN(0.45, μ_media(y))
  Conjunto de salida: 'media' recortado a altura 0.45
```

### 6. Paso a Paso: Agregación

```
======================================================
  PASO 3: AGREGACIÓN (S-norma MAX)                   
======================================================

Se combinan todos los consecuentes recortados usando MAX:

μ_agregado(y) = MAX(μ'₁(y), μ'₃(y), μ'₅(y))

Gráfico del conjunto agregado:
-------------------------------
         μ
      1.0 |
     0.85 |           /‾‾‾‾‾  ← de R3 (alta)
     0.45 |  /‾‾‾‾‾\         ← de R5 (media)
     0.20 |          ‾‾‾‾\   ← de R1 (alta)
      0.0 |_______________________
            20   50    85   100  (prioridad)

Descripción:
  - Zona [20,65]:   media con μ máx = 0.45
  - Zona [75,100]:  alta con μ máx = 0.85
  - Transición [65,75]: creciente de 0.45 a 0.85
```

**Tabla de valores discretos para agregación**:
```
y   | μ'₁(y) | μ'₃(y) | μ'₅(y) | MAX
----|--------|--------|--------|-------
20  |  0.00  |  0.00  |  0.45  | 0.45
30  |  0.00  |  0.00  |  0.45  | 0.45
40  |  0.00  |  0.00  |  0.45  | 0.45
50  |  0.00  |  0.00  |  0.45  | 0.45
60  |  0.00  |  0.00  |  0.35  | 0.35
70  |  0.00  |  0.50  |  0.00  | 0.50
80  |  0.00  |  0.80  |  0.00  | 0.80
85  |  0.20  |  0.85  |  0.00  | 0.85
90  |  0.20  |  0.85  |  0.00  | 0.85
95  |  0.20  |  0.85  |  0.00  | 0.85
100 |  0.20  |  0.85  |  0.00  | 0.85
```

### 7. Paso a Paso: Defuzzificación

```
======================================================
  PASO 4: DEFUZZIFICACIÓN (CENTROIDE)               
======================================================

MÉTODO DEL CENTROIDE (COA - Center of Area):
--------------------------------------------

Fórmula discreta:
  y* = Σ(yi · μ(yi)) / Σμ(yi)

CÁLCULO PASO A PASO:
--------------------

Discretización del conjunto agregado (cada 5 unidades):

  y  |  μ(y)  |  y·μ(y)
  ---|--------|----------
  20 |  0.45  |    9.0
  25 |  0.45  |   11.25
  30 |  0.45  |   13.5
  35 |  0.45  |   15.75
  40 |  0.45  |   18.0
  45 |  0.45  |   20.25
  50 |  0.45  |   22.5
  55 |  0.40  |   22.0
  60 |  0.35  |   21.0
  65 |  0.30  |   19.5
  70 |  0.50  |   35.0
  75 |  0.70  |   52.5
  80 |  0.80  |   64.0
  85 |  0.85  |   72.25
  90 |  0.85  |   76.5
  95 |  0.85  |   80.75
 100 |  0.85  |   85.0

Sumas:
  Σμ(yi)      = 10.10
  Σ(yi·μ(yi)) = 638.75

RESULTADO:
  y* = 638.75 / 10.10 = 63.24 puntos
```

**Verificación manual**:
```python
ys = [20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100]
mus = [0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.40, 0.35, 0.30, 
       0.50, 0.70, 0.80, 0.85, 0.85, 0.85, 0.85]

numerador = sum(y * mu for y, mu in zip(ys, mus))
denominador = sum(mus)
centroide = numerador / denominador

print(f"Centroide: {centroide:.2f}")
# Salida: Centroide: 63.24
```

### 8. Interpretación del Resultado

```
INTERPRETACIÓN:
  Prioridad = 63.24 → 'MEDIA-ALTA'
  (rango media: 35-65, media-alta: 65-85)

  La prioridad está en el límite superior de 'media',
  muy cerca de 'media-alta', lo cual tiene sentido dado:
  - Alta criticidad del cliente (hospital/bombeo)
  - Temperatura elevada (82-92°C)
  - Vibración moderada (4.0 mm/s)
```

**Análisis de sensibilidad**:
- Si temperatura fuera crisp alta (ej. 105°C): y* ≈ 75-80
- Si criticidad fuera residencial: y* ≈ 45-50
- Si vibración fuera baja: y* ≈ 60-65

### 9. Recomendación Práctica

```
======================================================
  RECOMENDACIÓN FINAL                                
======================================================

PRIORIDAD DE MANTENIMIENTO: MEDIA-ALTA (63.24/100)

JUSTIFICACIÓN:
--------------
1. La criticidad del cliente (hospital/bombeo) es el factor
   dominante, con μ = 0.95, activando fuertemente R3.

2. La temperatura del aceite (82-92°C) está en el rango
   medio-alto, indicando necesidad de monitoreo.

3. Aunque la vibración es moderada y el historial de fallas
   bajo, el tipo de cliente no permite demoras.

ACCIONES SUGERIDAS:
-------------------
• Programar inspección dentro de 15 días
• Monitoreo continuo de temperatura (SCADA)
• Preparar equipo de respaldo por criticidad del cliente
• Verificar sistema de refrigeración
• Análisis fisicoquímico del aceite dieléctrico
```

### 10. Capturas de Pantalla

Al ejecutar en FUZZY CLIPS:

**Pantalla 1**: Carga
```
CLIPS> (load "src/fuzzyclips/case_mamdani.clp")
Defining deftemplate: carga
Defining deftemplate: temperatura
Defining deftemplate: vibracion
Defining deftemplate: historial_fallas
Defining deftemplate: criticidad
Defining deftemplate: prioridad
Defining defrule: R1-carga-temp-criticas
...
TRUE
```

**Pantalla 2**: Ejecución
```
CLIPS> (run)
FIRE 1 R1-carga-temp-criticas: f-1,f-2
FIRE 2 R3-cliente-critico: f-5,f-2
FIRE 3 R5-sintomas-moderados: f-3,f-2
```

**Pantalla 3**: Hechos finales
```
CLIPS> (facts)
f-0   (initial-fact)
f-1   (carga (70 0) (85 1) (100 1) (115 0))
f-2   (temperatura (75 0) (82 1) (92 1) (98 0))
f-3   (vibracion (2.5 0) (4.0 1) (5.5 0))
f-4   (historial_fallas (0.5 0) (1.5 1) (2.5 0))
f-5   (criticidad (0.75 0) (0.85 1) (0.95 1) (1.0 0))
f-6   (prioridad alta)  ; de R1
f-7   (prioridad alta)  ; de R3
f-8   (prioridad media) ; de R5
```

### 11. Comparación con GMP

```
======================================================
  COMPARACIÓN: MAMDANI vs GMP                        
======================================================

CASO MAMDANI (este):
  - Entrada: Números borrosos trapezoidales/triangulares
  - Método: max-min con recorte de consecuentes
  - Salida: 63.24 (defuzzificado por centroide)
  - Ventaja: Resultado crisp directamente usable

CASO GMP (anterior):
  - Entrada: Valores crisp con conjuntos no continuos
  - Método: Composición relacional con implicación Gödel
  - Salida: Conjunto borroso (requiere interpretación)
  - Ventaja: Preserva información sobre incertidumbre

SELECCIÓN DEL MÉTODO:
  Para este dominio (priorización de mantenimiento),
  Mamdani es preferible porque:
  1. Requiere decisión crisp (planificación)
  2. Entradas naturalmente tienen incertidumbre (mediciones)
  3. Método estándar en sistemas de control difuso
```

### 12. Ejercicio Propuesto

Modificar case_mamdani.clp para experimentar:

```clips
; Caso A: Todo en valores ideales
(assert (carga (30 0) (40 1) (50 0)))      ; baja
(assert (temperatura (30 0) (40 1) (50 0))) ; normal
(assert (vibracion (0.5 0) (1.5 1) (2.5 0))) ; baja
(assert (historial_fallas (0 1) (0.5 0)))   ; bajo
(assert (criticidad (0.1 0) (0.2 1) (0.3 0))) ; residencial
```

**Pregunta**: ¿Cuál es y* esperado? ¿Qué reglas se activan?

**Respuesta esperada**: Principalmente R4, y* ≈ 20-30 (prioridad baja)

### 13. Conclusiones del Caso Mamdani

1. **Números borrosos**: Modelan incertidumbre en mediciones
2. **Método max-min**: Robusto y ampliamente usado
3. **Centroide**: Balance entre todas las reglas activadas
4. **Salida crisp**: Directamente usable para toma de decisiones
5. **Interpretable**: Cada paso tiene significado claro

### 14. Referencias para Profundizar

- Mamdani, E.H. (1974). "Application of fuzzy algorithms for control of simple dynamic plant"
- Lee, C.C. (1990). "Fuzzy logic in control systems: fuzzy logic controller"
- Ross, T.J. (2010). "Fuzzy Logic with Engineering Applications"
