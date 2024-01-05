# | RTBuilder - a GUI RAD tool for LuaRT
# | Luart.org, Copyright (c) Tine Samir 2023.
# | See Copyright Notice in LICENSE.TXT
# |--------------------------------------------------------------
# | Makefile
# | Please set LUART_PATH to your LuaRT folder if autodetection fails
# |--------------------------------------------------------------
# | Usage (default release build)			 : make
# | Usage (clean all)	 				 	 : make clean
# |-------------------------------------------------------------


#---- LuaRT toolchain path
LUART_PATH=..\LuaRT

TARGET=		RTBuilder
VERSION=	0.5
SRC= 		src/main.wlua src\version.lua src/dump.lua src/widgets.wlua  
LIBS=		-ltracker -ljson

ICON = resources\RTBuilder.ico

RM= del /Q
CP= copy /Y
LC= $(LUART_PATH)\bin\rtc.exe

all: $(TARGET).exe

infomodule: 
	@chcp 65001 >nul 2>&1
	@cmd /c echo.
	@echo|set /p dummy="▸  Building $(TARGET) $(VERSION)	  "

tracker.dll:
	@$(MAKE) -C tracker\ LUART_PATH=$(LUART_PATH) $(MAKECMDGOALS) --no-print-directory
	@-$(CP) tracker\tracker.dll tracker.dll  2>&1 >nul

src\version.lua:
	@echo return 'v$(VERSION)' > src\version.lua

$(TARGET).exe: tracker.dll infomodule $(SRC)
	@$(LC) $(SRC) -o $@ -i $(ICON) $(LIBS) 2>&1 >nul 
	@echo|set /p dummy="■"
	@-$(CP) $(LUART_PATH)\bin\lua54.dll 2>&1 >nul
	@-$(CP) $(LUART_PATH)\modules\webview\webview.dll widgets\webview.dll 2>&1 >nul
	@-$(CP) $(LUART_PATH)\modules\canvas\canvas.dll widgets\canvas.dll 2>&1 >nul
	@-$(RM) tracker.dll 2>&1 >nul
	@echo|set /p dummy="■"
	@cmd /c echo.
	
clean:
	@chcp 65001 >nul 2>&1
	@echo|set /p dummy="▸  Cleaning $(TARGET)... "
	@-$(RM) $(TARGET).exe >nul 2>&1
	@$(MAKE) -C tracker\ clean --no-print-directory 2>&1 >nul
	@echo ✓