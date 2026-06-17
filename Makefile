# 🐦‍🔥 AshWardDelAI - Makefile para construir desde Linux
# Creado por 🐦‍🔥FenixDF™🛡️ - Purple Team CyberSecurity

.PHONY: build clean help

# Colores para output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
CYAN := \033[0;36m
MAGENTA := \033[0;35m
RESET := \033[0m

help:
	@echo "$(MAGENTA)🐦‍🔥 AshWardDelAI - Comandos disponibles:$(RESET)"
	@echo "  $(GREEN)make build$(RESET)  - Construir el ejecutable .exe"
	@echo "  $(YELLOW)make clean$(RESET)  - Limpiar archivos de construcción"
	@echo "  $(CYAN)make help$(RESET)   - Mostrar esta ayuda"

build:
	@echo "$(MAGENTA)🐦‍🔥 Construyendo AshWardDelAI.exe...$(RESET)"
	@pyinstaller --onefile --noconsole \
		--name AshWardDelAI \
		--add-data "src/AshWardDelAI.ps1:." \
		src/launcher.py
	@echo "$(GREEN)✅ Ejecutable creado: dist/AshWardDelAI.exe$(RESET)"
	@ls -lh dist/AshWardDelAI.exe

clean:
	@echo "$(YELLOW)🧹 Limpiando archivos de construcción...$(RESET)"
	@rm -rf build/ dist/ *.spec
	@echo "$(GREEN)✅ Limpiado$(RESET)"
