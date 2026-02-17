@echo off

C:
cd C:\Users\Tusha\AppData\LocalREM

echo "Configure network"
powershell -Command "Start-Process powershell -ArgumentList '-File \"D:\shared\network-port-forward.ps1\"' -Verb RunAs"

echo "Starting Docker-Compose Services"
wsl -d Ubuntu-24.04 /home/tushar/settings/combined/services-up.sh
timeout /t 3

:end
