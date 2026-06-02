@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0_buildComposeFromLoincCsv.ps1" %*
