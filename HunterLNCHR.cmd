@echo off

:: DON'T CHANGE ANYTHING IN THIS FILE, THANKS

:: This is the launcher for Hunter.ps1. Without it, you'll get an error -
:: Hunter.ps1 cannot be loaded because running scripts is disabled on this system.
:: We temporary bypass that policy using this batch.

:: NOTES
:: Place HunterLNCHR.cmd & Hunter.ps1 in the same folder.
:: Use HunterLNCHR.cmd to run. More info found Hunter.ps1

set asset1=%1
set asset2=%2
set asset3=%3
set asset4=%4
set asset5=%5
set asset6=%6
set asset7=%7
set asset8=%8
set asset=%asset1% %asset2% %asset3% %asset4% %asset5% %asset6% %asset7% %asset8%
set path=%~dp0
set ps="C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
%ps% -noprofile -executionpolicy bypass -file  "%path%Hunter.ps1" %asset%

