#!/usr/bin/env python3
"""
🔥🛡️ AshWardDelAI - Launcher para Windows
Creado por 🐦‍🔥FenixDF™🛡️ - Purple Team CyberSecurity
"""

import os
import sys
import subprocess
import tempfile
import platform

def extraer_script():
    """Extrae el contenido del script PowerShell incrustado"""
    script_path = os.path.join(os.path.dirname(__file__), "AshWardDelAI.ps1")
    with open(script_path, "r", encoding="utf-8") as f:
        return f.read()

def ejecutar_windows():
    """Ejecuta el script en Windows"""
    print("🔥🛡️ AshWardDelAI - El guardián que elimina la IA")
    print("🟣 Purple Team CyberSecurity")
    print("------------------------------------------------")
    
    # Crear archivo temporal
    temp_dir = tempfile.mkdtemp(prefix="AshWard_")
    script_path = os.path.join(temp_dir, "AshWardDelAI.ps1")
    
    # Guardar script
    with open(script_path, "w", encoding="utf-8") as f:
        f.write(extraer_script())
    
    # Crear .bat lanzador
    bat_path = os.path.join(temp_dir, "RUN_ME.bat")
    with open(bat_path, "w") as f:
        f.write('''@echo off
title AshWardDelAI - by 🐦‍🔥FenixDF™🛡️
echo.
echo  🔥🛡️ AshWardDelAI - El guardián que elimina la IA
echo  🟣 Purple Team CyberSecurity
echo.
powershell.exe -ExecutionPolicy Bypass -File "%~dp0AshWardDelAI.ps1"
pause''')
    
    # Ejecutar
    try:
        subprocess.Popen([bat_path], shell=True)
        print(f"✅ Script lanzado desde: {temp_dir}")
        print("📌 La ventana de PowerShell se abrirá automáticamente")
    except Exception as e:
        print(f"❌ Error al ejecutar: {e}")
        sys.exit(1)

def ejecutar_linux():
    """Mensaje para Linux"""
    print("🐧 Desde Manjaro: Creando ejecutable para Windows...")
    print("   Usa 'make build' para generar el .exe")
    print("")
    print("📌 Para construir el ejecutable:")
    print("   1. pip3 install pyinstaller")
    print("   2. make build")
    print("   3. El .exe estará en: dist/AshWardDelAI.exe")

def main():
    """Función principal"""
    print("╔══════════════════════════════════════════════════════════════╗")
    print("║                                                              ║")
    print("║    🔥🛡️  ASHWARDDELAI  v1.0                                ║")
    print("║         by 🐦‍🔥FenixDF™🛡️                                  ║")
    print("║         Purple Team CyberSecurity                            ║")
    print("║                                                              ║")
    print("║    'El guardián que elimina la IA'                          ║")
    print("║                                                              ║")
    print("╚══════════════════════════════════════════════════════════════╝")
    print("")
    
    if platform.system() == "Windows":
        ejecutar_windows()
    else:
        ejecutar_linux()

if __name__ == "__main__":
    main()
