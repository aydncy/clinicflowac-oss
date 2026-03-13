# OVWI Push
Write-Host "Pushing OVWI..." -ForegroundColor Green
cd C:\Users\aydin.ceylan\Desktop\AYC\dev\ovwi-oss-main\ovwi_server
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe add -A
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe commit -m "Production-ready OVWI API Platform v1.0 - Dashboard, Auth, Gateway, Mock Data"
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe push origin master

Write-Host "`nOVWI pushed successfully!" -ForegroundColor Cyan

# ClinicFlowAC Push
Write-Host "`nPushing ClinicFlowAC..." -ForegroundColor Green
cd C:\Users\aydin.ceylan\Desktop\AYC\dev\clinicflowac-oss-main
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe add -A
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe commit -m "Production-ready ClinicFlowAC v1.0 - Healthcare SaaS with European Data"
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe push origin master

Write-Host "`nClinicFlowAC pushed successfully!" -ForegroundColor Cyan

Write-Host "`n=== ALL PUSHED ===" -ForegroundColor Yellow
Write-Host "OVWI: https://github.com/aydncy/ovwi-oss" -ForegroundColor Yellow
Write-Host "ClinicFlowAC: https://github.com/aydncy/clinicflowac-oss" -ForegroundColor Yellow
