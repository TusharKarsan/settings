@echo off
C:
cd C:\Users\Tusha\AppData\Local\Programs\Ollama\

:: Kill any existing Ollama processes to ensure clean start with new ENV
taskkill /f /im ollama.exe >nul 2>&1

netstat -ano | findstr :11434
netsh http add urlacl url=http://+:11434/ user=Everyone

choice /m "Do you want to continue?"
if errorlevel 2 goto end
if errorlevel 1 goto yes

:yes

echo "Starting Docker-Compose Services"
wsl -d Ubuntu-24.04 /home/tushar/settings/combined/services-up.sh

SET OLLAMA_HOST=0.0.0.0
SET OLLAMA_PORT=11434
SET OLLAMA_ORIGINS=*
:: Increased to 24k for better OpenCode/Codebase visibility
SET OLLAMA_CONTEXT_LENGTH=24576
SET PYTHONUTF8=1
.\ollama.exe serve

REM echo "Waiting for Ollama to start.."
REM timeout /t 5

echo "Stopping Docker-Compose Services"
wsl -d Ubuntu-24.04 /home/tushar/settings/combined/services-down.sh

echo "Hit any key to terminate.."
pause

:end
