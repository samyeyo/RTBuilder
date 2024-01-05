# | Tracker - A LuaRT Widget to move/resize other widgets
# | Luart.org, Copyright (c) Tine Samir 2022.
# | See Copyright Notice in LICENSE.TXT
# |--------------------------------------------------------------
# | Makefile
# | You can prefix all the following tasks with PLATFORM=x64|x86  
# |--------------------------------------------------------------
# | Usage (default release build)			 : make
# | Usage (debug build) 		  			 : make debug
# | Usage (clean all)	 				 	 : make clean
# |-------------------------------------------------------------
# | Or you can use default release build for any platform 
# | Usage (default x64 release build)		 : make x64
# | Usage (default x86 release build)		 : make x86
# |-------------------------------------------------------------

#---- Platform selection
#---- x86 for 32bits lua54.dll, liblua54.a and executables
#---- x64 for 64bits lua54.dll, liblua54.a and executables

PLATFORM ?= x64

#---- LuaRT installation path (set it manually if autodetection fails)
#LUART_PATH=

ifeq ($(LUART_PATH),)
LUART_PATH=$(shell luart.exe -e "print(sys.registry.read('HKEY_CURRENT_USER', 'Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\LuaRT', 'InstallLocation', false) or '')")
endif

ifeq ($(PLATFORM),)
PLATFORM=$(shell $(LUART_PATH)\bin\luart.exe -e "print(_ARCH)")
endif

ifeq ($(LUART_PATH),)
$(error LuaRT is not installed on this computer. Please set the LuaRT installation path manually in the Makefile or download and install LuaRT)
endif

LUART_INCLUDE = -I$(LUART_PATH)\include
LUART_LIB = -L$(LUART_PATH)\lib

ifeq ($(filter $(CLEAN),$(MAKECMDGOALS)),)
ifeq ($(PLATFORM), x86)
 ARCH = -m32 -march=pentium4 -msse -msse2 -mmmx -fno-unwind-tables -fno-asynchronous-unwind-tables
 TARGET = pe-i386
endif
ifeq ($(PLATFORM), x64)
ifneq ($(MAKECMDGOALS),x86)
endif
 ARCH = -m64 -mavx2 -mfma -Wno-int-to-pointer-cast -Wno-pointer-to-int-cast -Wno-int-conversion
 TARGET = pe-x86-64
endif
endif

BUILD := release

cflags.release = $(ARCH) -s -Os -D__MINGW64__ -D_WIN32_WINNT=0x0600 $(LUART_INCLUDE) 
ldflags.release= -static-libgcc $(LUART_LIB) 
cflags.debug = $(ARCH) -g -O0 -mfpmath=sse -mieee-fp -mmmx -msse -msse2 -DDEBUG -D__MINGW64__ -D_WIN32_WINNT=0x0600 -DLUA_COMPAT_5_3 $(LUART_INCLUDE)
ldflags.debug= -g -lm $(LUART_LIB)

CC= gcc
CFLAGS := ${cflags.${BUILD}}
LDFLAGS := ${ldflags.${BUILD}}
LIBS= -lgdi32 -lkernel32 -luser32 -llua54 -lcomctl32
RM= del /Q

MODULE=	tracker
VERSION = 0.5
SRC= 	src\tracker.o

all: $(MODULE).dll

infomodule: 
	@chcp 65001 >nul 2>&1
	@cmd /c echo.
	@echo|set /p dummy="▸  Building $(MODULE) $(VERSION)	  "

%.o : %.c
	@$(CC) $(CFLAGS) -c $< -o $@ 
	@echo|set /p dummy="■"

$(MODULE).dll: infomodule $(SRC)
	@$(CC) -shared $(CFLAGS) $(SRC) $(LDFLAGS) $(LIBS) -o $@

debug:
	$(MAKE) "BUILD=debug"

x64: clean
	@$(MAKE) "PLATFORM=x64"

x86: clean
	@$(MAKE) "PLATFORM=x86"

clean:
	@chcp 65001 >nul 2>&1
	@echo|set /p dummy="▸  Cleaning $(MODULE)... "
	@-$(RM) src\*.o >nul 2>&1
	@-$(RM) $(MODULE).dll >nul 2>&1
	@echo ✓

.PHONY: clean all