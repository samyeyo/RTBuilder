# | tracker module for LuaRT
# | Luart.org, Copyright (c) Tine Samir 2023.
# | See Copyright Notice in LICENSE.TXT
# |--------------------------------------------------------------
# | Makefile
# | Please set LUART_PATH to your LuaRT folder if autodetection fails
# |--------------------------------------------------------------
# | Usage (default release build)			 : make
# | Usage (debug build) 		  			 : make debug
# | Usage (clean all)	 				 	 : make clean
# |-------------------------------------------------------------


#---- LuaRT toolchain path
MODULE=		tracker
VERSION=	0.5
SRC= 		src\tracker.obj

#---- Uncomment to manually set LuaRT installation path 
LUART_PATH=..\..\LuaRT

!ifndef LUART_PATH
!message ** LuaRT is not installed on this computer.
!message ** Please install it or set the LuaRT installation path manually in the Makefile
!else

!if "$(BUILD)" == "debug"
CFLAGS = /nologo /D_WIN32_WINNT=0x0600 /DLUA_COMPAT_5_3 /DLUA_ARCH=\"$(_ARCH)\" /DLUART_MINOR=$(LUART_MINOR) /DLUART_MAJOR=$(LUART_MAJOR) /DLUART_RELEASE=$(LUART_RELEASE) /I"$(LUART_PATH)\include" /I"." /Z7
LDFLAGS= /nologo /DEBUG
!else
CFLAGS = /nologo /D_WIN32_WINNT=0x0600 /DLUA_COMPAT_5_3 /DLUA_ARCH=\"$(_ARCH)\" /DLUART_MINOR=$(LUART_MINOR) /DLUART_MAJOR=$(LUART_MAJOR) /DLUART_RELEASE=$(LUART_RELEASE) /I"$(LUART_PATH)\include" /I"." /MD /MD /Gy /Gw /GF /Oi /O2 /GA
LDFLAGS= /nologo /OPT:REF /OPT:ICF /LTCG
!endif

LIBS= "$(LUART_PATH)\lib\lua54.lib" gdi32.lib kernel32.lib user32.lib comctl32.lib
RM= del /Q
CP= copy /Y
LD= link.exe

all: $(MODULE).dll

debug:
	@$(MAKE) /nologo "BUILD=debug"

infomodule: 
	@chcp 65001 >nul 2>&1
	@cmd /c echo.
	@echo|set /p dummy="▸  Building module $(MODULE) $(VERSION)	  "

.c.obj: 
	@$(CC) $(CFLAGS) /c /Fo$@ $< 2>&1 >nul
	@echo|set /p dummy="■"

$(MODULE).dll: infomodule $(SRC)
	@$(LD) /DLL $(LDFLAGS) $(LIBS) $(SRC) /OUT:$@ 2>&1 >nul 
	
clean:
	@echo|set /p dummy="▸  Cleaning $(MODULE) module... "
	@$(RM) $(MODULE).* >nul 2>&1
	@$(RM) $(SRC) >nul 2>&1
	@echo ✓
!endif
