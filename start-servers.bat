@echo off
cd C:\Users\aydin.ceylan\Desktop\AYC\dev

echo Starting OVWI...
start "OVWI - Port 8081" cmd /k "cd ovwi-oss-main\ovwi_server && dart run bin\server.dart"

timeout /t 2

echo Starting ClinicFlowAC...
start "ClinicFlowAC - Port 8083" cmd /k "cd clinicflowac-oss-main && dart run bin\server.dart"

echo.
echo OVWI: http://localhost:8081
echo ClinicFlowAC: http://localhost:8083
pause
