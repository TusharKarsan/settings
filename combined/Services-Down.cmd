@echo off

C:
cd C:\Users\Tusha\AppData\LocalREM

echo "Stopping Docker-Compose Services"
wsl -d Ubuntu-24.04 /home/tushar/settings/combined/services-down.sh
timeout /t 3

:end
