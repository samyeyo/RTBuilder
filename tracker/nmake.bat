@echo off
@setlocal EnableDelayedExpansion

for /f %%i in ('luart.exe -e "print(sys.registry.read('HKEY_CURRENT_USER','Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\LuaRT','InstallLocation',false)or'')"') do nmake.exe /nologo LUART_PATH=%%i %1
