@echo off
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Instala Node.js 22 o superior para iniciar Black Ops Paintball.
  pause
  exit /b 1
)
if not exist "node_modules\nodemailer\package.json" (
  echo Instalando dependencias para el correo...
  npm install
  if errorlevel 1 (
    pause
    exit /b 1
  )
)
start "" cmd /c "timeout /t 2 /nobreak >nul & start http://127.0.0.1:4173"
node server.mjs
pause
