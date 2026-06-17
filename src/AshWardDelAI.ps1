<#
.SYNOPSIS
    🔥🛡️ AshWardDelAI v1.0
    "El guardián que elimina la IA"
.DESCRIPTION
    Elimina TODOS los rastros de IA y telemetría en Windows 11.
    Creado por 🐦‍🔥FenixDF™🛡️ - Purple Team CyberSecurity
.NOTES
    Versión: 1.0
    Autor: 🐦‍🔥FenixDF™🛡️
    GitHub: https://github.com/FenixDF/AshWardDelAI
    Team: Purple Team - Defensa Activa y Ofensiva
#>

# ============================================
# 1. BANNER INICIAL (PÚRPURA)
# ============================================
Clear-Host
Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║    🔥🛡️  ASHWARDDELAI  v1.0                                ║
║         by 🐦‍🔥FenixDF™🛡️                                  ║
║         Purple Team CyberSecurity                            ║
║                                                              ║
║    "El guardián que elimina la IA"                          ║
║    "Dejando tu sistema limpio y soberano"                  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Magenta

# ============================================
# 2. VERIFICAR ADMINISTRADOR
# ============================================
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "`n❌ ERROR: Ejecuta PowerShell como Administrador" -ForegroundColor Red
    Write-Host "   Haz clic derecho en PowerShell > 'Ejecutar como administrador'" -ForegroundColor Yellow
    Read-Host "`nPresiona Enter para salir"
    Exit
}

# ============================================
# 3. CREAR PUNTO DE RESTAURACIÓN
# ============================================
Write-Host "`n📌 Creando punto de restauración..." -ForegroundColor Magenta
try {
    Checkpoint-Computer -Description "AshWardDelAI v1.0 - Antes de limpieza" -RestorePointType MODIFY_SETTINGS
    Write-Host "✅ Punto de restauración creado" -ForegroundColor Green
} catch {
    Write-Host "⚠️ No se pudo crear punto de restauración" -ForegroundColor Yellow
    Write-Host "   (Puede estar desactivado en tu sistema)" -ForegroundColor Gray
}

# ============================================
# 4. MENÚ PRINCIPAL (OPCIONES CON COLORES)
# ============================================
Write-Host "`n════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "   🟣 ASHWARDDELAI - NIVEL DE ELIMINACIÓN" -ForegroundColor Magenta
Write-Host "════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""
Write-Host "  [1] 🟢 BÁSICO   - IA visible y telemetría básica" -ForegroundColor Green
Write-Host "  [2] 🟡 PROFUNDO - Servicios, apps y firewall (RECOMENDADO)" -ForegroundColor Yellow
Write-Host "  [3] 🔴 EXTREMO  - ELIMINA TODOS los rastros de IA (máxima limpieza)" -ForegroundColor Red
Write-Host "  [4] ❌ SALIR" -ForegroundColor White
Write-Host ""
$opcion = Read-Host "Opción (1-4)"

# ============================================
# 5. FUNCIONES DE ELIMINACIÓN
# ============================================

# --- FUNCIÓN: BÁSICO (VERDE) ---
function Limpiar-Basico {
    Write-Host "`n🟢 Aplicando limpieza BÁSICA..." -ForegroundColor Green
    
    # 1. Desactivar Copilot en barra de tareas
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -Value 0
    Write-Host "  ✅ Copilot desactivado de la barra de tareas" -ForegroundColor Green
    
    # 2. Desactivar telemetría básica
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0
    Write-Host "  ✅ Telemetría básica desactivada" -ForegroundColor Green
    
    # 3. Desactivar sugerencias de IA
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0
    Write-Host "  ✅ Sugerencias de IA desactivadas" -ForegroundColor Green
    
    # 4. Desactivar Windows Copilot por política
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1
    Write-Host "  ✅ Windows Copilot desactivado por política" -ForegroundColor Green
    
    Write-Host "`n🟢 Limpieza BÁSICA completada" -ForegroundColor Green
}

# --- FUNCIÓN: PROFUNDO (AMARILLO) ---
function Limpiar-Profundo {
    Write-Host "`n🟡 Aplicando limpieza PROFUNDA..." -ForegroundColor Yellow
    
    # Ejecutar limpieza básica primero
    Limpiar-Basico
    
    # === 1. DESACTIVAR SERVICIOS DE IA Y TELEMETRÍA ===
    Write-Host "`n  📌 Desactivando servicios..." -ForegroundColor Cyan
    $servicios = @(
        "CopilotSvc",           # Servicio de Copilot
        "WindowsAI",            # Servicio general de IA
        "RecallSvc",            # Recall (capturas de pantalla)
        "PcaSvc",               # Compatibilidad de aplicaciones
        "DiagTrack",            # Seguimiento de diagnósticos
        "dmwappushservice",     # Servicio push de telemetría
        "WpnService",           # Notificaciones push (usado por IA)
        "PimIndexMaintenanceSvc", # Indexado (usado por búsqueda IA)
        "SysMain",              # Superfetch (recopila datos de uso)
        "WSearch"               # Búsqueda de Windows (indexa para IA)
    )
    
    foreach ($svc in $servicios) {
        try {
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "    ✅ Desactivado: $svc" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠️ No encontrado: $svc" -ForegroundColor Yellow
        }
    }
    
    # === 2. BLOQUEAR DOMINIOS DE TELEMETRÍA ===
    Write-Host "`n  📌 Bloqueando dominios..." -ForegroundColor Cyan
    $dominios = @(
        "*.telemetry.microsoft.com",
        "*.vortex.data.microsoft.com",
        "*.settings.data.microsoft.com",
        "*.azure-dataprocessing.com",
        "*.cloudapp.azure.com",
        "*.microsoftmetrics.com",
        "*.watson.telemetry.microsoft.com"
    )
    
    foreach ($dom in $dominios) {
        try {
            New-NetFirewallRule -DisplayName "AshWardDelAI - Bloquear $dom" -Direction Outbound -RemoteAddress $dom -Action Block -ErrorAction SilentlyContinue
            Write-Host "    ✅ Bloqueado: $dom" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠️ No se pudo bloquear: $dom" -ForegroundColor Yellow
        }
    }
    
    # === 3. DESINSTALAR APPS DE IA ===
    Write-Host "`n  📌 Desinstalando apps..." -ForegroundColor Cyan
    $apps = @(
        "Microsoft.Copilot",
        "Microsoft.Windows.DevHome",
        "Microsoft.Windows.AI.Copilot.Provider",
        "Microsoft.People",
        "Microsoft.BingWeather",
        "Microsoft.MicrosoftEdge.Stable",  # Edge tiene IA integrada
        "Microsoft.Windows.Photos"         # Tiene etiquetado y reconocimiento de imágenes
    )
    
    foreach ($app in $apps) {
        try {
            Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like "*$app*"} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            Write-Host "    ✅ Desinstalado: $app" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠️ No instalado: $app" -ForegroundColor Yellow
        }
    }
    
    # === 4. ELIMINAR TAREAS PROGRAMADAS DE TELEMETRÍA ===
    Write-Host "`n  📌 Eliminando tareas programadas..." -ForegroundColor Cyan
    $tareas = @(
        "\Microsoft\Windows\Application Experience\*",
        "\Microsoft\Windows\Customer Experience Improvement Program\*",
        "\Microsoft\Windows\DiskDiagnostic\*",
        "\Microsoft\Windows\Windows Error Reporting\*"
    )
    
    foreach ($tarea in $tareas) {
        try {
            Get-ScheduledTask -TaskPath $tarea | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue
            Write-Host "    ✅ Eliminadas tareas en: $tarea" -ForegroundColor Green
        } catch {
            Write-Host "    ⚠️ No se encontraron tareas en: $tarea" -ForegroundColor Yellow
        }
    }
    
    # === 5. LIMPIAR CACHÉ DE IA ===
    Write-Host "`n  📌 Limpiando cachés de IA..." -ForegroundColor Cyan
    $caches = @(
        "$env:LOCALAPPDATA\Microsoft\Windows\AI",
        "$env:LOCALAPPDATA\Microsoft\Windows\Copilot",
        "$env:APPDATA\Microsoft\Windows\AI"
    )
    
    foreach ($cache in $caches) {
        if (Test-Path $cache) {
            try {
                Remove-Item -Path $cache -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "    ✅ Caché eliminado: $cache" -ForegroundColor Green
            } catch {
                Write-Host "    ⚠️ No se pudo eliminar caché: $cache" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host "`n🟡 Limpieza PROFUNDA completada" -ForegroundColor Yellow
}

# --- FUNCIÓN: EXTREMO (ROJO) ---
function Limpiar-Extremo {
    Write-Host "`n🔴🔴🔴  MODO EXTREMO  🔴🔴🔴" -ForegroundColor Red
    Write-Host "Se ELIMINARÁN TODOS los rastros de IA." -ForegroundColor Red
    Write-Host "Puede afectar actualizaciones futuras y estabilidad del sistema." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Recomendaciones:" -ForegroundColor Magenta
    Write-Host "  - Tener backup completo del sistema" -ForegroundColor White
    Write-Host "  - Estar dispuesto a reinstalar Windows si algo sale mal" -ForegroundColor White
    Write-Host ""
    $confirm = Read-Host "¿Escribe 'ASHWARD' para confirmar"
    if ($confirm -ne "ASHWARD") { 
        Write-Host "❌ Cancelado por seguridad" -ForegroundColor Red
        return
    }
    
    # Ejecutar limpieza profunda primero
    Limpiar-Profundo
    
    # === 6. ELIMINAR CARPETAS Y ARCHIVOS FÍSICOS ===
    Write-Host "`n🔥 Eliminando archivos físicos..." -ForegroundColor Red
    $carpetas = @(
        "$env:LOCALAPPDATA\Microsoft\Windows\AI",
        "$env:LOCALAPPDATA\Microsoft\Windows\Copilot",
        "$env:APPDATA\Microsoft\Windows\ActivityCache",
        "$env:PROGRAMFILES\WindowsAI",
        "$env:PROGRAMFILES(x86)\WindowsAI",
        "$env:WINDIR\SystemApps\Microsoft.Copilot_*",
        "$env:WINDIR\SystemApps\Microsoft.Windows.DevHome_*",
        "$env:PROGRAMFILES\WindowsApps\Microsoft.Copilot_*",
        "$env:PROGRAMDATA\Microsoft\Diagnosis",
        "$env:PROGRAMDATA\Microsoft\Windows\WER"  # Reportes de errores
    )
    
    foreach ($ruta in $carpetas) {
        if (Test-Path $ruta) {
            try {
                # Tomar ownership y dar permisos para eliminar
                Takeown /F $ruta /R /D Y | Out-Null
                Icacls $ruta /grant Administradores:F /T | Out-Null
                Remove-Item -Path $ruta -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "    ✅ Eliminado: $ruta" -ForegroundColor Green
            } catch {
                Write-Host "    ❌ No se pudo eliminar: $ruta (permisos)" -ForegroundColor Red
            }
        }
    }
    
    # === 7. LIMPIAR REGISTRO ===
    Write-Host "`n  📌 Limpiando registro..." -ForegroundColor Cyan
    $registros = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\AI",
        "HKLM:\SOFTWARE\Microsoft\Windows\Copilot",
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot",
        "HKCU:\SOFTWARE\Microsoft\Windows\AI",
        "HKCU:\SOFTWARE\Microsoft\Windows\Copilot"
    )
    
    foreach ($reg in $registros) {
        if (Test-Path $reg) {
            try {
                Remove-Item -Path $reg -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "    ✅ Eliminado: $reg" -ForegroundColor Green
            } catch {
                Write-Host "    ❌ No se pudo eliminar: $reg" -ForegroundColor Red
            }
        }
    }
    
    # === 8. DESHABILITAR ONEDRIVE ===
    Write-Host "`n  📌 Deshabilitando OneDrive..." -ForegroundColor Cyan
    try {
        Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        if (Test-Path $onedrive) { 
            & $onedrive /uninstall | Out-Null
            Write-Host "    ✅ OneDrive deshabilitado" -ForegroundColor Green
        } else {
            Write-Host "    ⚠️ OneDrive no encontrado" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "    ⚠️ No se pudo deshabilitar OneDrive" -ForegroundColor Yellow
    }
    
    # === 9. CONFIGURAR EDGE SIN IA ===
    Write-Host "`n  📌 Configurando Edge sin IA..." -ForegroundColor Cyan
    try {
        $edgePolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
        New-Item -Path $edgePolicy -Force | Out-Null
        Set-ItemProperty -Path $edgePolicy -Name "HubsSidebarEnabled" -Value 0
        Set-ItemProperty -Path $edgePolicy -Name "CopilotInEdgeEnabled" -Value 0
        Set-ItemProperty -Path $edgePolicy -Name "EdgeShoppingAssistantEnabled" -Value 0
        Write-Host "    ✅ Edge configurado sin IA" -ForegroundColor Green
    } catch {
        Write-Host "    ⚠️ No se pudo configurar Edge" -ForegroundColor Yellow
    }
    
    # === 10. ELIMINAR TELEMETRÍA DE WINDOWS DEFENDER ===
    Write-Host "`n  📌 Configurando Windows Defender sin telemetría..." -ForegroundColor Cyan
    try {
        $defenderPolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
        New-Item -Path $defenderPolicy -Force | Out-Null
        Set-ItemProperty -Path $defenderPolicy -Name "DisableAntiSpyware" -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Value 2 -ErrorAction SilentlyContinue
        Write-Host "    ✅ Windows Defender configurado sin telemetría" -ForegroundColor Green
    } catch {
        Write-Host "    ⚠️ No se pudo configurar Windows Defender" -ForegroundColor Yellow
    }
    
    Write-Host "`n🔴 Limpieza EXTREMA completada" -ForegroundColor Red
    Write-Host "⚠️ REINICIA TU PC para que los cambios surtan efecto" -ForegroundColor Yellow
}

# ============================================
# 6. EJECUTAR OPCIÓN SELECCIONADA
# ============================================
switch ($opcion) {
    "1" { Limpiar-Basico }
    "2" { Limpiar-Profundo }
    "3" { Limpiar-Extremo }
    "4" { 
        Write-Host "`nSaliendo..." -ForegroundColor White
        Exit 
    }
    default { 
        Write-Host "❌ Opción no válida" -ForegroundColor Red
    }
}

# ============================================
# 7. MENSAJE FINAL (PÚRPURA)
# ============================================
Write-Host "`n════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "   🟣🔥🛡️ ASHWARDDELAI - ¡Sistema limpio!" -ForegroundColor Magenta
Write-Host "════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""
Write-Host "📌 REINICIA TU PC para aplicar cambios" -ForegroundColor Yellow
Write-Host "📌 Para revertir: Punto de restauración creado" -ForegroundColor Yellow
Write-Host ""
Write-Host "🔗 GitHub: https://github.com/FenixDF/AshWardDelAI" -ForegroundColor Cyan
Write-Host "🟣 Purple Team CyberSecurity" -ForegroundColor Magenta
Write-Host "🐦‍🔥 https://github.com/FenixDF" -ForegroundColor Cyan
Write-Host ""
Read-Host "Presiona Enter para salir"
