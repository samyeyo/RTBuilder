<div align="center">

![RTBuilder][title]  
GUI RAD designer for LuaRT

[![LuaRT module](https://badgen.net/badge/LuaRT/module/yellow)](https://www.luart.org/)
![Windows](https://badgen.net/badge/Windows/Vista%20and%20later/blue?icon=windows)
[![LuaRT license](https://badgen.net/badge/License/MIT/green)](#license)
[![Twitter Follow](https://img.shields.io/twitter/follow/__LuaRT__?style=social)](https://www.twitter.com/__LuaRT__)

[Features](#small_blue_diamondfeatures) |
[Installation](#small_blue_diamondinstallation) |
[Documentation](https://www.luart.org/doc/json/index.html) |
[License](#small_blue_diamondlicense)

</div>
   
## :small_blue_diamond:Features

- Visual user interface design tool for LuaRT
- Build Windows desktop applications easily
- Directly generate Lua files, which can then be loaded from Lua scripts
  
## :small_blue_diamond:Installation

Before using RTBuilder, you must have been previously installed [LuaRT](https://github.com/samyeyo/LuaRT) to continue.

#### Method 1 : RTBuilder release package :package:

The preferred way to get the JSON module is to download the latest release package available on GitHub.  
Be sure to download the right platform version as your LuaRT installation, either `x86` or `x64`
Just unpack the downloaded archive to get the `RTBuilder-setup.exe` installer and execute it to proceed with installation.
RTBuilder will then be available as a Start menu shortcut.
  
#### Method 2 : RTBuilder from sources :gear:

All you need to build RTBuilder from sources is a valid installation of [LuaRT](https://github.com/samyeyo/LuaRT)

First clone the RTBuilder module repository (or manualy download the repository as ZIP file) :
```
git clone https://github.com/samyeyo/RTBuilder.git
```

Then go to the root directory of the repository and type ```make```:

```
cd RTBuilder\
make
```
It will try to autodetect the LuaRT path and platform, and if it failed, you can still set the `LUART_PATH` directory in the `make.bat`file.  
If everything went right, it will produce `RTBuilder.exe`.

## :small_blue_diamond:Documentation
  
- :book: [RTBuilder Documentation](http://www.luart.org/doc/json/index.html)
  
## :small_blue_diamond:License
  
RTBuilder is copyright (c) 2023 Samir Tine.
RTBuilder for LuaRT is open source, released under the MIT License.

See full copyright notice in the LICENSE file.

[title]: contrib/RTBuilder.png
