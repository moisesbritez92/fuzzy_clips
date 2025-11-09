# Paso a Paso: Caso GMP con Conjuntos No Continuos

## Introducción
Este documento presenta la ejecución detallada del **Caso 1: Inferencia GMP** del sistema de priorización de mantenimiento de transformadores.

## Prerequisitos
- FUZZY CLIPS instalado
- Archivos bc.clp y case_gmp.clp en src/fuzzyclips/

## Ejecución

### 1. Iniciar FUZZY CLIPS
```bash
$ fuzzy-clips
FuzzyCLIPS 6.x
CLIPS>
```

### 2. Cargar el Caso GMP
```clips
CLIPS> (load "src/fuzzyclips/case_gmp.clp")
```

### 3. Salida Esperada

#### Sección 1: Configuración de Parámetros
```
======================================================
  CASO 1: INFERENCIA GMP CON CONJUNTOS NO CONTINUOS  
======================================================

CONFIGURACIÓN DE PARÁMETROS:
-----------------------------
1. T-norma: MIN (Zadeh)
   Justificación: Operador conservador, adecuado para
   aplicaciones de seguridad donde queremos la menor
   compatibilidad de condiciones.

2. S-norma: MAX (Zadeh)
   Justificación: Dual de MIN, mantiene propiedades
   algebraicas deseables (idempotencia, conmutatividad).

3. Implicación: Gödel (Rc)
   Definición: Rc(a,b) = 1 si a ≤ b, sino b
   Justificación: Preserva la verdad en sistemas deductivos,
   adecuada para Modus Ponens Generalizado.

4. Composición relacional: max-min
   Para GMP: B' = A' ∘ R = sup_x [min(μ_A'(x), μ_R(x,y))]
```

#### Sección 2: Ejemplo Numérico 1 - Patrón Intermitente
```
======================================================
  EJEMPLO NUMÉRICO 1: PATRÓN INTERMITENTE            
======================================================

DATOS DE ENTRADA (valores crisp):
----------------------------------
  Carga relativa:      90%  (→ 'alta')
  Temperatura aceite:  87°C (→ 'media_alta')
  Vibración:          4.2 mm/s (→ 'media')
  Historial fallas:   5.5 fallas/12m (→ 'intermitente', pico en 5-6)
  Criticidad cliente: 0.9 (→ 'critico')

FUZZIFICACIÓN COMPLETADA
Grados de pertenencia calculados:
  μ_alta(90) = 0.5
  μ_media_alta(87) = 0.8
  μ_media(4.2) = 0.9
  μ_intermitente(5.5) = 1.0 (pico no continuo)
  μ_critico(0.9) = 1.0
```

**Análisis del conjunto NO CONTINUO**:
El historial intermitente tiene dos picos:
- Pico 1 en x=1.5 (fallas esporádicas tempranas)
- Pico 2 en x=5.5 (fallas recurrentes)
- Valle en [2,5] (periodo sin patrón claro)

Gráfico:
```
    μ
  1 |  *       *     ← picos en 1.5 y 5.5
    | / \     / \
0.3 |/   \___/   \
  0 |____________
    0 1 2 3 4 5 6 7 8  (fallas)
```

#### Sección 3: Aplicación de GMP
```
APLICACIÓN DE MODUS PONENS GENERALIZADO:
-----------------------------------------

Regla R3 activada:
  SI criticidad ES critico Y temperatura ES media_alta
  ENTONCES prioridad ES alta

  Evaluación de antecedente:
    α_R3 = MIN(μ_critico(0.9), μ_media_alta(87))
        = MIN(1.0, 0.8) = 0.8

  GMP con implicación de Gödel:
    μ_alta'(y) = sup_x [min(0.8, Rc(μ_antecedente(x), μ_alta(y)))]
    Resultado: prioridad 'alta' con grado 0.8

Regla R7 activada:
  SI historial ES intermitente Y vibración ES media
  ENTONCES prioridad ES media_alta

  Evaluación de antecedente:
    α_R7 = MIN(μ_intermitente(5.5), μ_media(4.2))
        = MIN(1.0, 0.9) = 0.9

  GMP con implicación de Gödel:
    μ_media_alta'(y) = sup_x [min(0.9, Rc(μ_antecedente(x), μ_media_alta(y)))]
    Resultado: prioridad 'media_alta' con grado 0.9
```

**Detalle de la composición relacional**:

Para R3 con α=0.8:
```
y (prior) | μ_alta(y) | Rc(0.8, μ_alta) | min(0.8, Rc)
----------|-----------|-----------------|-------------
   75     |    0.0    |      1.0        |     0.8
   80     |    0.33   |      1.0        |     0.8
   85     |    1.0    |      1.0        |     0.8
   90     |    1.0    |      1.0        |     0.8
  100     |    1.0    |      1.0        |     0.8
```

Como α=0.8 > μ_alta en la zona baja, Gödel devuelve 1.0, y el min da 0.8.
En la zona alta donde μ_alta=1.0 ≥ 0.8, Gödel sigue dando 1.0.

#### Sección 4: Agregación
```
AGREGACIÓN DE CONSECUENTES (S-norma MAX):
------------------------------------------
  μ_prioridad(y) = MAX(μ_alta'(y), μ_media_alta'(y))

  Para cada y en [0,100]:
    Si y ∈ [75,100]: MAX(0.8, 0) = 0.8
    Si y ∈ [50,85]: MAX(0, 0.9) = 0.9

CONJUNTO BORROSO DE SALIDA:
  Prioridad = 'media_alta' (0.9) ∪ 'alta' (0.8)
```

Gráfico del conjunto agregado:
```
    μ
  1 |
0.9 |     /‾‾‾‾‾\         ← media_alta
0.8 |             /‾‾‾‾   ← alta
  0 |____________/________
    0   50  65  75  100  (prioridad)
```

#### Sección 5: Tabla de Pertenencia No Continua
```
======================================================
  TABLA: FUNCIÓN DE PERTENENCIA HISTORIAL (NO CONTINUO)
======================================================

  x (fallas) | μ_bajo | μ_intermitente | μ_frecuente
  --------------------------------------------------------
      0      |  1.0   |      0.0       |     0.0    
      1      |  1.0   |      0.3       |     0.0    
     1.5     |  0.5   |      1.0       |     0.0    (pico 1)
      2      |  0.0   |      0.3       |     0.0    
      3      |  0.0   |      0.0       |     0.0    
      4      |  0.0   |      0.0       |     0.0    
      5      |  0.0   |      0.3       |     0.17   
     5.5     |  0.0   |      1.0       |     0.33   (pico 2)
      6      |  0.0   |      0.3       |     1.0    
      7      |  0.0   |      0.0       |     1.0    
      8      |  0.0   |      0.0       |     1.0    

  NOTA: 'intermitente' es NO CONTINUO (discontinuo en [2,5])
```

#### Sección 6: Ejemplo Numérico 2 - Entrada Difusa Mixta
```
======================================================
  EJEMPLO NUMÉRICO 2: ENTRADA DIFUSA MIXTA           
======================================================

DATOS DE ENTRADA (mixtos: crisp y difusos):
--------------------------------------------
  Carga relativa: DIFUSA
    μ(x) = {(80, 0.3), (90, 0.7), (100, 1.0), (110, 0.6)}
    Interpretación: principalmente 'alta' pero con incertidumbre

  Temperatura: 105°C (crisp → 'alta' con μ=1.0)

  Vibración: 3.0 mm/s (crisp → 'baja' con μ=0.875)

  Historial: 1.5 fallas (NO CONTINUO)
    μ_intermitente(1.5) = 1.0 (pico en rango 1-2)

  Criticidad: 0.75 (crisp → transición comercial-crítico)
    μ_comercial(0.75) = 0.67, μ_critico(0.75) = 0.33

EVALUACIÓN CON GMP:
-------------------

Regla R1: SI carga ES muy_alta Y temperatura ES alta
  α_R1 = MIN(μ_muy_alta(carga_difusa), μ_alta(105))
       = MIN(sup{0.6}, 1.0) = 0.6
  → prioridad 'alta' con grado 0.6

RESULTADO DE COMPOSICIÓN RELACIONAL:
------------------------------------
  La salida borrosa integra todas las reglas activadas
  mediante la operación max-min de composición.

  Conjunto de salida tiene múltiples componentes,
  reflejando la incertidumbre de la entrada difusa.
```

### 4. Visualización de Relaciones Borrosas

**Tabla de Relación R3** (criticidad × temperatura → prioridad):
```
       Temperatura
         media_alta  alta
Crit  ┌─────────────────┐
crít  │  alta(0.9)  alta│
comer │  media      med │
resid │  baja       baja│
      └─────────────────┘
```

Con entrada (critico=0.9, temp_media_alta=0.8):
- α = min(1.0, 0.8) = 0.8
- Consecuente: alta recortado a 0.8

### 5. Interpretación de Resultados

**Caso 1** (Patrón Intermitente):
- **Entrada**: Transformador con historial NO CONTINUO de fallas
- **Salida**: Prioridad media_alta(0.9) ∪ alta(0.8)
- **Interpretación**: La regla R7 domina (0.9) por el patrón intermitente claro

**Caso 2** (Entrada Difusa):
- **Entrada**: Valores con incertidumbre (números borrosos)
- **Salida**: Distribución borrosa compleja
- **Interpretación**: Mayor incertidumbre en entrada produce mayor distribución en salida

### 6. Verificación Manual

Para verificar R3 manualmente:
```python
# Entrada
mu_critico = 1.0
mu_media_alta = 0.8

# Antecedente (T-norma MIN)
alpha = min(mu_critico, mu_media_alta)  # = 0.8

# Consecuente con Gödel
# Para y donde mu_alta(y) = 1.0:
#   Rc(0.8, 1.0) = 1 (porque 0.8 ≤ 1.0)
#   min(0.8, 1) = 0.8

# Resultado: conjunto 'alta' con altura máxima 0.8
```

### 7. Capturas de Pantalla

Al ejecutar en FUZZY CLIPS, verás:

**Pantalla 1**: Carga de módulos
```
CLIPS> (load "src/fuzzyclips/case_gmp.clp")
Defining deftemplate: carga
Defining deftemplate: temperatura
...
TRUE
```

**Pantalla 2**: Ejecución de reglas
```
CLIPS> (run)
FIRE 1 R3-cliente-critico: f-1,f-2
FIRE 2 R7-patron-intermitente: f-3,f-4
```

**Pantalla 3**: Hechos finales
```
CLIPS> (facts)
f-0   (initial-fact)
f-1   (carga (90 0) (95 1) (100 1) (110 0))
f-2   (temperatura (85 0) (87 1) (95 1) (100 0))
f-3   (vibracion (3.5 0) (4.2 1) (5 1) (7 0))
f-4   (historial_fallas (5 0.3) (5.5 1) (6 0.3))
f-5   (criticidad (0.85 0) (0.9 1) (1.0 1))
f-6   (prioridad (50 0) (65 0.9) (75 0.9) (85 0.8) (100 0.8))
```

### 8. Análisis de Diferencias: Continuo vs No Continuo

**Conjunto Continuo** (ej. temperatura):
```
μ(x) es continua en todo el dominio
Toda transición es suave
```

**Conjunto No Continuo** (historial intermitente):
```
μ(x) tiene discontinuidades
Representa fenómenos con picos aislados
Más expresivo para patrones reales
```

**Ejemplo**: Un transformador puede tener:
- 1-2 fallas en puesta en marcha (pico 1)
- Operación estable (valle)
- 5-6 fallas por deterioro tardío (pico 2)

El conjunto NO CONTINUO captura este patrón mejor que uno continuo.

### 9. Conclusiones del Caso GMP

1. **GMP preserva información**: La salida es un conjunto borroso completo
2. **Conjuntos no continuos**: Modelan patrones reales complejos
3. **Implicación de Gödel**: Apropiada para razonamiento deductivo
4. **Composición max-min**: Método estándar de Zadeh robusto

### 10. Ejercicio Propuesto

Modificar case_gmp.clp para probar:
```clips
; Caso extremo: Todo crítico
(assert (carga muy_alta))
(assert (temperatura alta))
(assert (vibracion alta))
(assert (historial_fallas frecuente))
(assert (criticidad critico))
```

**Pregunta**: ¿Cuántas reglas se activan? ¿Cuál es la prioridad resultante?

**Respuesta esperada**: Múltiples reglas (R1, R2, R3, R6), salida debería ser 'alta' con α cercano a 1.0.
