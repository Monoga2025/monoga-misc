@echo off
setlocal EnableExtensions DisableDelayedExpansion
if /I "%~1"=="touchpad-action" goto touchpadAction
:main
cls
echo ============================================
echo    Control de Scroll y Touchpad
echo ============================================
echo.
echo  1. Filtro de scroll del mouse
echo  2. Touchpad ELAN
echo  0. Salir
echo.
set "choice="
set /p "choice=Selecciona una opcion: "
if "%choice%"=="1" goto scrollMenu
if "%choice%"=="2" goto touchpadMenu
if "%choice%"=="0" exit /b 0
echo Opcion no valida.
pause
goto main
:scrollMenu
cls
echo Filtro de scroll del mouse
echo.
echo  1. Activar
echo  2. Desactivar
echo  3. Volver
set "choice="
set /p "choice=Selecciona una opcion: "
if "%choice%"=="1" (powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\Filtro-Scroll-Windows.ps1" -Action Activate & goto result)
if "%choice%"=="2" (powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\Filtro-Scroll-Windows.ps1" -Action Deactivate & goto result)
if "%choice%"=="3" goto main
echo Opcion no valida.
pause
goto scrollMenu
:touchpadMenu
cls
echo Touchpad ELAN
echo.
echo  1. Activar
echo  2. Desactivar
echo  3. Volver
set "choice="
set /p "choice=Selecciona una opcion: "
if "%choice%"=="1" goto elevateTouchpadActivate
if "%choice%"=="2" goto elevateTouchpadDeactivate
if "%choice%"=="3" goto main
echo Opcion no valida.
pause
goto touchpadMenu
:elevateTouchpadActivate
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%ComSpec%' -ArgumentList '/c ""%~f0"" touchpad-action activate' -Verb RunAs -Wait"
goto result
:elevateTouchpadDeactivate
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%ComSpec%' -ArgumentList '/c ""%~f0"" touchpad-action deactivate' -Verb RunAs -Wait"
goto result
:touchpadAction
if /I not "%~2"=="activate" if /I not "%~2"=="deactivate" exit /b 2
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $id='HID\ELAN06FA&COL01\5&152B2D68&0&0000'; $action='%~2'; Get-PnpDevice -InstanceId $id -ErrorAction Stop ^| Out-Null; if($action -eq 'activate'){Enable-PnpDevice -InstanceId $id -Confirm:$false -ErrorAction Stop;Write-Host 'Touchpad ELAN activado.'}else{Disable-PnpDevice -InstanceId $id -Confirm:$false -ErrorAction Stop;Write-Host 'Touchpad ELAN desactivado.'}"
if errorlevel 1 (echo Error: no se pudo cambiar el touchpad ELAN. No se modifico ningun otro dispositivo. & pause & exit /b 1)
echo Operacion completada. Solo se uso la instancia ELAN especificada.
pause
exit /b 0
:result
if errorlevel 1 echo La accion no se completo.
echo.
pause
goto main
