<div align="center">

![RTBuilder][title]  
GUI RAD designer for LuaRT

[![LuaRT module](https://badgen.net/badge/Made%20with/LuaRT/yellow)](https://www.luart.org/)
![Windows](https://badgen.net/badge/Windows/Vista%20and%20later/blue?icon=windows)
[![LuaRT license](https://badgen.net/badge/License/MIT/green)](#license)
[![Twitter Follow](https://img.shields.io/twitter/follow/__LuaRT__?style=social)](https://www.twitter.com/__LuaRT__)

[Features](#small_blue_diamondfeatures) |
[Installation](#small_blue_diamondinstallation) |
[Documentation](https://www.luart.org/doc/json/index.html) |
[License](#small_blue_diamondlicense)

</div>
   
## :small_blue_diamond:Features

- Visual user interface design tool for the LuaRT **ui** module
- Build Windows desktop applications easily
- Generates Lua files, which can then be loaded from Lua scripts
  
## :small_blue_diamond:Installation

#### RTBuilder release package :package:

The preferred way to install RTBuilder is to download the latest release package available on GitHub.  
Be sure to download the right platform version as your LuaRT installation, either `x86` or `x64`
Just unpack the downloaded archive and extract its content in the folder of your choice.
  
## :small_blue_diamond:Documentation
  
RTBuilder should be easy to use :
- Put the desired widgets on the Window, move, resize, and set properties as needed.
- Save the Window as a Lua file using the `Window\Save` menu command
- To make the saved Window available in your Lua scripts, just `require()` for it, and it will return a `Window` LuaRT object ready to use.
- For more information on the LuaRT **ui** module, read the [ui module documentation](http://www.luart.org/doc/ui/index.html)


## :small_blue_diamond:License
  
RTBuilder is copyright (c) 2024 Samir Tine.
RTBuilder for LuaRT is open source, released under the MIT License.

See full copyright notice in the LICENSE file.

[title]: contrib/RTBuilder.png
