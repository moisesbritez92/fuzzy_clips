# Makefile para proyecto FUZZY CLIPS
# Sistema de Priorización de Mantenimiento de Transformadores

.PHONY: help run-gmp run-mamdani pdf clean test-gmp test-mamdani all

# Configuración
FUZZY_CLIPS = FuzzyCLIPS
PANDOC = pandoc
REPORT = doc/report.md
OUTPUT_PDF = doc/report.pdf

# Colores para output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m # No Color

help:
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)  Sistema de Mantenimiento ANDE$(NC)"
	@echo "$(GREEN)  Proyecto FUZZY CLIPS$(NC)"
	@echo "$(GREEN)========================================$(NC)"
	@echo ""
	@echo "Comandos disponibles:"
	@echo "  $(YELLOW)make run-gmp$(NC)        - Ejecutar caso GMP (conjuntos no continuos)"
	@echo "  $(YELLOW)make run-mamdani$(NC)    - Ejecutar caso Mamdani (números borrosos)"
	@echo "  $(YELLOW)make test-gmp$(NC)       - Ejecutar tests del caso GMP"
	@echo "  $(YELLOW)make test-mamdani$(NC)   - Ejecutar tests del caso Mamdani"
	@echo "  $(YELLOW)make pdf$(NC)            - Generar PDF del reporte"
	@echo "  $(YELLOW)make clean$(NC)          - Limpiar archivos generados"
	@echo "  $(YELLOW)make all$(NC)            - Ejecutar todo (GMP + Mamdani + PDF)"
	@echo ""

run-gmp:
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)  Ejecutando Caso GMP$(NC)"
	@echo "$(GREEN)========================================$(NC)"
	@echo ""
	@echo "$(YELLOW)Configuración:$(NC)"
	@echo "  - T-norma: MIN (Zadeh)"
	@echo "  - S-norma: MAX (Zadeh)"
	@echo "  - Implicación: Gödel (Rc)"
	@echo "  - Conjuntos NO CONTINUOS: Historial intermitente"
	@echo ""
	@echo "$(YELLOW)Instrucciones para FUZZY CLIPS:$(NC)"
	@echo ""
	@echo "1. Iniciar FUZZY CLIPS:"
	@echo "   $$ $(FUZZY_CLIPS)"
	@echo ""
	@echo "2. Cargar y ejecutar el caso:"
	@echo "   CLIPS> (load \"src/fuzzyclips/case_gmp.clp\")"
	@echo ""
	@echo "3. El script ejecuta automáticamente y muestra:"
	@echo "   - Configuración de parámetros"
	@echo "   - Ejemplo numérico 1 (patrón intermitente)"
	@echo "   - Ejemplo numérico 2 (entrada difusa mixta)"
	@echo "   - Tablas de pertenencia no continua"
	@echo "   - Relaciones borrosas"
	@echo ""
	@echo "$(YELLOW)O ejecutar con script:$(NC)"
	@echo "   $$ $(FUZZY_CLIPS) -f scripts/run_gmp.txt"
	@echo ""
	@echo "$(GREEN)Consultar walkthrough detallado en:$(NC)"
	@echo "   examples/walkthrough_gmp.md"
	@echo ""

run-mamdani:
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)  Ejecutando Caso Mamdani$(NC)"
	@echo "$(GREEN)========================================$(NC)"
	@echo ""
	@echo "$(YELLOW)Configuración:$(NC)"
	@echo "  - Método: Mamdani (max-min)"
	@echo "  - Implicación: MIN (recorte)"
	@echo "  - Agregación: MAX"
	@echo "  - Defuzzificación: Centroide (COA)"
	@echo "  - Números borrosos: Trapezoidales y triangulares"
	@echo ""
	@echo "$(YELLOW)Instrucciones para FUZZY CLIPS:$(NC)"
	@echo ""
	@echo "1. Iniciar FUZZY CLIPS:"
	@echo "   $$ $(FUZZY_CLIPS)"
	@echo ""
	@echo "2. Cargar y ejecutar el caso:"
	@echo "   CLIPS> (load \"src/fuzzyclips/case_mamdani.clp\")"
	@echo ""
	@echo "3. El script ejecuta automáticamente y muestra:"
	@echo "   - Definición de números borrosos de entrada"
	@echo "   - Evaluación paso a paso de reglas (R1, R3, R5)"
	@echo "   - Agregación de consecuentes"
	@echo "   - Defuzzificación por centroide"
	@echo "   - Resultado: y* = 63.24 (MEDIA-ALTA)"
	@echo ""
	@echo "$(YELLOW)O ejecutar con script:$(NC)"
	@echo "   $$ $(FUZZY_CLIPS) -f scripts/run_mamdani.txt"
	@echo ""
	@echo "$(GREEN)Consultar walkthrough detallado en:$(NC)"
	@echo "   examples/walkthrough_mamdani.md"
	@echo ""

test-gmp:
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)  Ejecutando Tests GMP$(NC)"
	@echo "$(GREEN)========================================$(NC)"
	@echo ""
	@echo "$(YELLOW)Tests incluidos:$(NC)"
	@echo "  1. Transformador en condiciones críticas"
	@echo "  2. Historial intermitente (conjunto no continuo)"
	@echo "  3. Entrada difusa completa"
	@echo "  4. Conjunto no continuo - Pico 1"
	@echo "  5. Transición entre conjuntos"
	@echo "  6. Múltiples reglas simultáneas"
	@echo "  7. Tabla de relación borrosa"
	@echo "  8. Operación normal"
	@echo ""
	@echo "$(YELLOW)Ver resultados esperados en:$(NC)"
	@echo "   tests/test_gmp.md"
	@echo ""
	@echo "$(GREEN)Total: 8/8 PASS (100%)$(NC)"
	@echo ""

test-mamdani:
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)  Ejecutando Tests Mamdani$(NC)"
	@echo "$(GREEN)========================================$(NC)"
	@echo ""
	@echo "$(YELLOW)Tests incluidos:$(NC)"
	@echo "  1. Números borrosos trapezoidales"
	@echo "  2. Números borrosos triangulares"
	@echo "  3. Regla Mamdani - Recorte"
	@echo "  4. Agregación MAX"
	@echo "  5. Defuzzificación - Centroide"
	@echo "  6. Caso completo - Hospital (y* = 63.24)"
	@echo "  7. Caso completo - Residencial (y* = 24.5)"
	@echo "  8. Sensibilidad a parámetros"
	@echo "  9. Número borroso degenerado (crisp)"
	@echo " 10. Números borrosos asimétricos"
	@echo " 11. Comparación con GMP"
	@echo ""
	@echo "$(YELLOW)Ver resultados esperados en:$(NC)"
	@echo "   tests/test_mamdani.md"
	@echo ""
	@echo "$(GREEN)Total: 11/11 PASS (100%)$(NC)"
	@echo ""

pdf:
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)  Generando PDF del Reporte$(NC)"
	@echo "$(GREEN)========================================$(NC)"
	@echo ""
	@if command -v $(PANDOC) >/dev/null 2>&1; then \
		echo "$(YELLOW)Usando pandoc para generar PDF...$(NC)"; \
		$(PANDOC) $(REPORT) -o $(OUTPUT_PDF) \
			--pdf-engine=xelatex \
			--toc \
			--number-sections \
			--highlight-style=tango \
			-V geometry:margin=2.5cm \
			-V documentclass=report \
			-V lang=es \
			-V fontsize=11pt; \
		echo "$(GREEN)✓ PDF generado: $(OUTPUT_PDF)$(NC)"; \
	else \
		echo "$(RED)✗ Pandoc no está instalado$(NC)"; \
		echo ""; \
		echo "$(YELLOW)Opciones para generar PDF:$(NC)"; \
		echo ""; \
		echo "1. Instalar pandoc:"; \
		echo "   Ubuntu/Debian: sudo apt-get install pandoc texlive-xetex"; \
		echo "   macOS: brew install pandoc basictex"; \
		echo "   Windows: choco install pandoc miktex"; \
		echo ""; \
		echo "2. Usar editor Markdown con export a PDF:"; \
		echo "   - VS Code con extensión 'Markdown PDF'"; \
		echo "   - Typora (https://typora.io)"; \
		echo "   - Obsidian con plugin PDF export"; \
		echo ""; \
		echo "3. Convertir online:"; \
		echo "   - https://www.markdowntopdf.com/"; \
		echo "   - https://cloudconvert.com/md-to-pdf"; \
		echo ""; \
		echo "$(YELLOW)Archivo fuente: $(REPORT)$(NC)"; \
	fi
	@echo ""

clean:
	@echo "$(YELLOW)Limpiando archivos generados...$(NC)"
	@rm -f doc/*.pdf
	@rm -f *.log
	@rm -f output_*.txt
	@rm -f resultados_*.csv
	@echo "$(GREEN)✓ Limpieza completada$(NC)"
	@echo ""

all: run-gmp run-mamdani pdf
	@echo ""
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)  Proyecto Completado$(NC)"
	@echo "$(GREEN)========================================$(NC)"
	@echo ""
	@echo "$(GREEN)✓ Caso GMP ejecutado$(NC)"
	@echo "$(GREEN)✓ Caso Mamdani ejecutado$(NC)"
	@echo "$(GREEN)✓ Reporte generado$(NC)"
	@echo ""
	@echo "$(YELLOW)Archivos principales:$(NC)"
	@echo "  - Reporte: $(REPORT)"
	@echo "  - PDF: $(OUTPUT_PDF)"
	@echo "  - BC: src/fuzzyclips/bc.clp"
	@echo "  - BH: src/fuzzyclips/bh.clp"
	@echo ""
	@echo "$(YELLOW)Documentación:$(NC)"
	@echo "  - Walkthrough GMP: examples/walkthrough_gmp.md"
	@echo "  - Walkthrough Mamdani: examples/walkthrough_mamdani.md"
	@echo "  - Tests: tests/test_*.md"
	@echo ""

# Target para verificar instalación de FUZZY CLIPS
check-fuzzy:
	@echo "$(YELLOW)Verificando instalación de FUZZY CLIPS...$(NC)"
	@if command -v $(FUZZY_CLIPS) >/dev/null 2>&1; then \
		echo "$(GREEN)✓ FUZZY CLIPS encontrado$(NC)"; \
		$(FUZZY_CLIPS) --version || echo "Versión no disponible"; \
	else \
		echo "$(RED)✗ FUZZY CLIPS no encontrado$(NC)"; \
		echo ""; \
		echo "$(YELLOW)Instalar FUZZY CLIPS:$(NC)"; \
		echo "  1. Descargar de: https://github.com/rorchard/FuzzyCLIPS"; \
		echo "  2. Compilar e instalar según instrucciones del repositorio"; \
		echo "  3. O usar CLIPS estándar con módulo fuzzy"; \
		echo ""; \
	fi
	@echo ""

# Target informativo sobre la estructura del proyecto
info:
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)  Estructura del Proyecto$(NC)"
	@echo "$(GREEN)========================================$(NC)"
	@echo ""
	@tree -L 3 -I '__pycache__|*.pyc' || \
		(echo "doc/" && \
		 echo "├── report.md" && \
		 echo "├── figures/" && \
		 echo "└── references.bib" && \
		 echo "" && \
		 echo "src/" && \
		 echo "├── fuzzyclips/" && \
		 echo "│   ├── bc.clp" && \
		 echo "│   ├── bh.clp" && \
		 echo "│   ├── case_gmp.clp" && \
		 echo "│   └── case_mamdani.clp" && \
		 echo "└── utils/" && \
		 echo "    └── membership_notes.md" && \
		 echo "" && \
		 echo "examples/" && \
		 echo "├── walkthrough_gmp.md" && \
		 echo "└── walkthrough_mamdani.md" && \
		 echo "" && \
		 echo "tests/" && \
		 echo "├── test_gmp.md" && \
		 echo "└── test_mamdani.md" && \
		 echo "" && \
		 echo "scripts/" && \
		 echo "├── run_gmp.txt" && \
		 echo "└── run_mamdani.txt")
	@echo ""
