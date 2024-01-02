# | RTBuilder - a GUI RAD tool for LuaRT
# | Luart.org, Copyright (c) Tine Samir 2023.
# | See Copyright Notice in LICENSE.TXT
# |--------------------------------------------------------------
# | Makefile
# | Please set LUART_PATH to your LuaRT folder if autodetection fails
# |--------------------------------------------------------------
# | Usage (default release build)			 : make
# | Usage (create release package)		 	 : make package
# | Usage (clean all)	 				 	 : make clean
# |-------------------------------------------------------------


#---- Uncomment to manually set LuaRT installation path 
LUART_PATH=..\LuaRT

!ifndef LUART_PATH
!message ** LuaRT is not installed on this computer.
!message ** Please install it or set the LuaRT installation path manually in the Makefile
!else

TARGET=		RTBuilder.exe
VERSION=	0.5
SRC= 		src/main.wlua src\version.lua src/dump.lua src/widgets.wlua  
LIBS=		-ltracker -ljson

ICON = resources\RTBuilder.ico

RM= del /Q
CP= copy /Y
LC= $(LUART_PATH)\bin\rtc.exe

all: $(TARGET)

infopackage:
	@chcp 65001 >nul 2>&1
	@cmd /c echo.
	@echo|set /p dummy="▸  Building release package       "

package: $(TARGET) infopackage
	@$(LUART_PATH)\bin\luart.exe contrib\package.lua
	@cmd /c echo.

infomodule: 
	@chcp 65001 >nul 2>&1
	@cmd /c echo.
	@echo|set /p dummy="▸  Building $(TARGET) $(VERSION)	  "

tracker.dll:
	@cd tracker
	@$(MAKE) /nologo
	@-$(CP) tracker.dll ..\tracker.dll  2>&1 >nul
	@cd ..

src\version.lua:
	@echo return 'v$(VERSION)' > src\version.lua

$(TARGET): tracker.dll infomodule $(SRC)
	@$(LC) $(SRC) -o $@ -i $(ICON) $(LIBS) 2>&1 >nul 
	@echo|set /p dummy="■"
	@-$(CP) /Y $(LUART_PATH)\bin\lua54.dll 2>&1 >nul
	@-$(CP) /Y $(LUART_PATH)\modules\webview\webview.dll widgets\webview.dll 2>&1 >nul
	@-$(CP) /Y $(LUART_PATH)\modules\canvas\canvas.dll widgets\canvas.dll 2>&1 >nul
	@$(RM) tracker.dll 2>&1 >nul
	@echo|set /p dummy="■"
	@cmd /c echo.
	
clean:
	@echo|set /p dummy="▸  Cleaning $(TARGET)... "
	@$(RM) $(TARGET).* 2>&1 >nul
	@cd tracker
	@$(MAKE) /nologo clean 2>&1 >nul
	@cd ..
	@echo ✓
!endif