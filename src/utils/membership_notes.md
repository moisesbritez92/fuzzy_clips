# Definiciones Formales de Lógica Borrosa

## 1. Funciones de Pertenencia (μ)

### 1.1 Definición General
Para un conjunto borroso A en un universo X:
```
μ_A: X → [0,1]
```
donde μ_A(x) representa el grado de pertenencia del elemento x al conjunto A.

### 1.2 Tipos de Funciones de Pertenencia Usadas

#### Trapezoidal
```
         μ(x)
          1|    /‾‾‾‾‾\
           |   /       \
          0|__/________\___
             a  b  c  d

μ_trap(x; a,b,c,d) = {
  0                 si x < a
  (x-a)/(b-a)      si a ≤ x < b
  1                 si b ≤ x ≤ c
  (d-x)/(d-c)      si c < x ≤ d
  0                 si x > d
}
```

#### Triangular
```
         μ(x)
          1|    /\
           |   /  \
          0|__/____\___
             a  b  c

μ_tri(x; a,b,c) = {
  0                 si x < a
  (x-a)/(b-a)      si a ≤ x < b
  (c-x)/(c-b)      si b ≤ x ≤ c
  0                 si x > c
}
```

#### No Continua (Intermitente)
```
         μ(x)
          1|  *       *
           | / \     / \
          0|/_\_____/_\_\___
            0 1 2 3 4 5 6

μ_inter(x) = {
  0.3 + 0.7·exp(-((x-1.5)²)/0.25)    si 0 ≤ x ≤ 3
  0                                   si 3 < x < 4.5
  0.3 + 0.7·exp(-((x-5.5)²)/0.25)    si 4.5 ≤ x ≤ 8
}
```

## 2. T-normas (Intersección Borrosa)

### 2.1 Definición
Una t-norma T es una función T: [0,1]² → [0,1] que satisface:
- Conmutatividad: T(a,b) = T(b,a)
- Asociatividad: T(a,T(b,c)) = T(T(a,b),c)
- Monotonía: si a ≤ c y b ≤ d, entonces T(a,b) ≤ T(c,d)
- Elemento neutro: T(a,1) = a

### 2.2 T-normas Principales

#### MIN (Zadeh) - **USADA EN EL PROYECTO**
```
T_min(a,b) = min(a,b)
```
**Justificación**: Es la t-norma más conservadora. En aplicaciones de seguridad
como el mantenimiento de transformadores, queremos la intersección más restrictiva
de las condiciones.

#### Producto
```
T_prod(a,b) = a · b
```

#### Łukasiewicz
```
T_Łuk(a,b) = max(0, a + b - 1)
```

## 3. S-normas (Unión Borrosa)

### 3.1 Definición
Una s-norma S es una función S: [0,1]² → [0,1] que satisface:
- Conmutatividad: S(a,b) = S(b,a)
- Asociatividad: S(a,S(b,c)) = S(S(a,b),c)
- Monotonía: si a ≤ c y b ≤ d, entonces S(a,b) ≤ S(c,d)
- Elemento neutro: S(a,0) = a

### 3.2 S-normas Principales

#### MAX (Zadeh) - **USADA EN EL PROYECTO**
```
S_max(a,b) = max(a,b)
```
**Justificación**: Dual de MIN. Mantiene propiedades algebraicas deseables:
- Idempotencia: max(a,a) = a
- Absorción con MIN: max(a, min(a,b)) = a

#### Suma Probabilística
```
S_sum(a,b) = a + b - a·b
```

#### Łukasiewicz
```
S_Łuk(a,b) = min(1, a + b)
```

## 4. Implicaciones Borrosas

### 4.1 Definición General
Una implicación borrosa I es una función I: [0,1]² → [0,1].

### 4.2 Implicaciones Principales

#### Gödel (Rc) - **USADA EN EL PROYECTO**
```
I_Gödel(a,b) = {
  1    si a ≤ b
  b    si a > b
}
```
**Justificación**: Preserva la verdad en sistemas deductivos.
Es adecuada para Modus Ponens Generalizado porque:
- Cuando a ≤ b (antecedente no supera consecuente), la implicación es totalmente verdadera
- Cuando a > b, el grado de verdad es exactamente b

**Ejemplo**: Si μ_antecedente = 0.8 y μ_consecuente = 0.6:
- I_Gödel(0.8, 0.6) = 0.6 (porque 0.8 > 0.6)

#### Mamdani (MIN)
```
I_Mamdani(a,b) = min(a,b)
```
**Uso**: En inferencia tipo Mamdani para recortar consecuentes.

#### Łukasiewicz
```
I_Łuk(a,b) = min(1, 1 - a + b)
```

#### Rescher-Gaines
```
I_RG(a,b) = {
  1    si a ≤ b
  0    si a > b
}
```

## 5. Composición Relacional

### 5.1 Max-Min (Zadeh) - **USADA EN GMP**
Para relaciones R: X×Y → [0,1] y conjuntos A' en X:
```
B'(y) = sup_{x∈X} [min(μ_A'(x), μ_R(x,y))]
```

**Interpretación**: Para cada y, tomamos el máximo sobre todos los x de
la intersección (MIN) entre la entrada difusa y la relación.

### 5.2 Ejemplo de Aplicación
Regla: SI temperatura ES alta ENTONCES prioridad ES alta
Entrada: temperatura = 87°C con μ_media_alta(87) = 0.8

1. Construir relación R usando implicación de Gödel
2. Componer: B'(y) = sup_x [min(μ_A'(x), R(x,y))]
3. Resultado: conjunto borroso B' en el universo de prioridad

## 6. Modus Ponens Generalizado (GMP)

### 6.1 Forma Clásica
```
Premisa mayor:  SI X es A ENTONCES Y es B
Premisa menor:  X es A'
Conclusión:     Y es B'
```

### 6.2 Implementación Borrosa
```
1. Construir relación R(x,y) = I(μ_A(x), μ_B(y))
2. Componer: μ_B'(y) = sup_x [T(μ_A'(x), R(x,y))]
```

donde:
- T = t-norma (MIN en nuestro caso)
- I = implicación (Gödel en nuestro caso)

### 6.3 Ejemplo Numérico Completo

**Regla**: SI carga ES muy_alta Y temperatura ES alta ENTONCES prioridad ES alta

**Entrada**:
- carga: μ_muy_alta = 0.6
- temperatura: μ_alta = 1.0

**Paso 1**: Evaluar antecedente compuesto
```
α = T_min(0.6, 1.0) = 0.6
```

**Paso 2**: Aplicar implicación de Gödel
Para cada y en el universo de prioridad:
```
R(y) = I_Gödel(α, μ_alta(y))
     = I_Gödel(0.6, μ_alta(y))

Si μ_alta(y) ≥ 0.6: R(y) = 1
Si μ_alta(y) < 0.6: R(y) = μ_alta(y)
```

**Paso 3**: Resultado
El conjunto de salida es 'alta' con todos los puntos donde μ_alta ≥ 0.6
manteniendo su pertenencia original, y los puntos con μ_alta < 0.6 también
mantienen su pertenencia (porque 0.6 > μ_alta implica I_Gödel = μ_alta).

## 7. Método de Mamdani

### 7.1 Pasos del Algoritmo
```
1. Fuzzificación:     x_crisp → μ_A(x)
2. Evaluación reglas: α_i = T(μ_A1(x1), μ_A2(x2), ...)
3. Implicación:       B'_i(y) = min(α_i, μ_Bi(y))  [recorte]
4. Agregación:        B'(y) = max_i(B'_i(y))
5. Defuzzificación:   y_crisp = COA(B')
```

### 7.2 Centroide (COA)

**Forma continua**:
```
y* = ∫ y · μ_B'(y) dy / ∫ μ_B'(y) dy
```

**Forma discreta**:
```
y* = Σ_i (y_i · μ_B'(y_i)) / Σ_i μ_B'(y_i)
```

**Ejemplo de cálculo**:
Si B' = {(20, 0.3), (30, 0.5), (40, 0.5), (50, 0.3)}:
```
Numerador:   20·0.3 + 30·0.5 + 40·0.5 + 50·0.3 = 6 + 15 + 20 + 15 = 56
Denominador: 0.3 + 0.5 + 0.5 + 0.3 = 1.6
y* = 56 / 1.6 = 35
```

## 8. Propiedades Importantes

### 8.1 Ley de De Morgan
Para t-norma T y s-norma S duales:
```
¬(a ∧ b) = ¬a ∨ ¬b
¬(a ∨ b) = ¬a ∧ ¬b
```

Con MIN/MAX:
```
1 - min(a,b) = max(1-a, 1-b)
1 - max(a,b) = min(1-a, 1-b)
```

### 8.2 Principio de Extensión
Para extender funciones f: X → Y a conjuntos borrosos:
```
μ_B(y) = sup_{x: f(x)=y} μ_A(x)
```

### 8.3 α-cortes
```
A_α = {x ∈ X | μ_A(x) ≥ α}
```

El α-corte permite trabajar con conjuntos clásicos a partir de borrosos.

## 9. Resumen de Elecciones para el Proyecto

| Componente | Elección | Justificación |
|------------|----------|---------------|
| T-norma | MIN (Zadeh) | Conservadora, segura para aplicaciones críticas |
| S-norma | MAX (Zadeh) | Dual de MIN, propiedades algebraicas estándar |
| Implicación GMP | Gödel (Rc) | Preserva verdad en deducción |
| Implicación Mamdani | MIN | Recorte de consecuentes, estándar en control |
| Composición | max-min | Método clásico de Zadeh |
| Defuzzificación | Centroide (COA) | Balance entre todas las reglas activadas |

## Referencias

1. Zadeh, L.A. (1965). "Fuzzy Sets". Information and Control, 8(3), 338-353.
2. Mamdani, E.H. (1974). "Application of fuzzy algorithms for control of simple dynamic plant".
3. Klir, G.J. & Yuan, B. (1995). "Fuzzy Sets and Fuzzy Logic: Theory and Applications".
4. Zimmermann, H.-J. (2001). "Fuzzy Set Theory and Its Applications".
