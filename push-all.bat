@echo off
cd C:\Users\aydin.ceylan\Desktop\AYC\dev\ovwi-oss-main\ovwi_server

echo Pushing OVWI...
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe add -A
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe commit -m "Update"
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe push origin master

cd C:\Users\aydin.ceylan\Desktop\AYC\dev\clinicflowac-oss-main

echo Pushing ClinicFlowAC...
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe add -A
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe commit -m "Update"
C:\Users\aydin.ceylan\Desktop\AYC\dev\PortableGit\bin\git.exe push origin master

echo Done!
pause
