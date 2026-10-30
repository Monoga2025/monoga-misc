@echo off
title CRM Monoga
set "ROOT=%CRM_ROOT%"
set "PG=%CRM_PG%"

:menu
cls
echo ==============================
echo        CRM MONOGA
echo ==============================
echo.
echo   [E] Encender
echo   [A] Apagar
echo   [S] Salir
echo.
choice /c EAS /n /m "Elige una opcion: "
if errorlevel 3 exit /b
if errorlevel 2 goto apagar
goto encender

:encender
cls
echo Limpiando procesos viejos...
powershell -NoProfile -Command "Get-NetTCPConnection -State Listen -LocalPort 3000,3101,2000 -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }"

echo [1/4] Postgres...
"%PG%\pgsql\bin\pg_ctl.exe" -D "%PG%\data" status >nul 2>&1 || "%PG%\pgsql\bin\pg_ctl.exe" -D "%PG%\data" -l "%PG%\pg.log" -w start

echo [2/4] API...
start "CRM API" /min cmd /c "cd /d "%ROOT%" && bunx turbo run dev --filter=api"

echo [3/4] App...
start "CRM App" /min cmd /c "cd /d "%ROOT%\apps\app" && bunx next dev --webpack"

echo [4/4] Agente de IA (usa unos 2 GB de RAM).
choice /c SN /t 10 /d S /m "Iniciar el agente? (S=si, N=no, 10 s para decidir)"
if errorlevel 2 goto esperar
start "CRM Agente" /min cmd /c "cd /d "%ROOT%\apps\agent" && bun run dev:headless"

:esperar
echo Esperando a que la app este lista...
:loop
netstat -ano | findstr ":3000 " | findstr LISTENING >nul || (timeout /t 3 >nul & goto loop)
netstat -ano | findstr ":3101 " | findstr LISTENING >nul || (timeout /t 3 >nul & goto loop)
start "" "http://localhost:3000/api/dev-login"
echo.
echo CRM encendido. Vuelve a abrir este archivo para apagarlo.
timeout /t 5 >nul
exit /b

:apagar
cls
echo Apagando CRM...
powershell -NoProfile -Command "Get-NetTCPConnection -State Listen -LocalPort 3000,3101,2000 -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }"
"%PG%\pgsql\bin\pg_ctl.exe" -D "%PG%\data" stop -m fast
echo.
echo CRM apagado.
timeout /t 3 >nul
exit /b

