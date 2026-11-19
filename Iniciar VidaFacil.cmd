@echo off
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
 echo Instale o Node.js 22 ou superior e abra este arquivo novamente.
 pause
 exit /b 1
)
if not exist node_modules (
 call npm.cmd install
 if errorlevel 1 (
  echo Nao foi possivel instalar as dependencias.
  pause
  exit /b 1
 )
)
call npm.cmd run dev -- --open
pause
