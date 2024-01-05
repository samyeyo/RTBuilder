@echo off
@setlocal EnableDelayedExpansion


"luart.exe">"%TEMP%\CommandOutput.tmp" 2>&1
if errorlevel 1 goto Failed

for /f %%i in ('luart.exe -e "print(sys.registry.read('HKEY_CURRENT_USER','Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\LuaRT','InstallLocation',false)or'')"') do (
    nmake.exe /nologo LUART_PATH=%%i %1 
    exit /b 0
)

:Failed
nmake.exe /nologo LUART_PATH=%CD%\..\.. %1 %2 %3