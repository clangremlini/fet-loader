# AYE Loader 
[![AHK](https://img.shields.io/badge/language-AHK-green.svg?style=flat-square)](https://wikipedia.org/wiki/AutoHotkey) [![Windows](https://img.shields.io/badge/platform-Windows-0078d7.svg?style=flat-square)](https://en.wikipedia.org/wiki/Microsoft_Windows) [![Master](https://img.shields.io/badge/master-1.4.2--1-green.svg?style=flat-square)](https://github.com/clangremlini/aye-ahk-loader) [![hackeri](https://img.shields.io/github/downloads/clangremlini/aye-ahk-loader/total.svg?style=flat-square)](https://github.com/clangremlini/aye-ahk-loader/releases) [![build](https://img.shields.io/github/workflow/status/clangremlini/aye-ahk-loader/AYE%20Loader%20CI?style=flat-square)](https://github.com/clangremlini/aye-ahk-loader/actions)

A simple loader written in AHK.

# How to compile
- Clone the repository with the command `git clone https://github.com/clangremlini/aye-ahk-loader | cd aye-ahk-loader | git submodule update --init --recursive`
- Run `COMPILE.bat`

# How to load your DLLs
##### _We can't help you if your fucking system dies, it's not our fault. You got it?_
- Open the config.
- Change the value of `custominject` to `true`.
- **Restart** loader
- In the folder C:\AYE\custom put dll with the name slot1.dll, slot2.dll, and so on, then we inject this slot.

# Credits
- Loader: [m4x3r1337](https://github.com/m4x3r1337) & [rf0x1d](https://github.com/rfoxxxy) previously
- ExternalModuleBypasser: [0x000cb](https://github.com/0x000cb)
- VAC-Bypass-Loader: [danielkrupinski](https://github.com/danielkrupinski/VAC-Bypass-Loader)
- Ahk2Exe: [AutoHotkey](https://github.com/AutoHotkey/Ahk2Exe)
- Translation: [Gl1c1n](https://github.com/Gl1c1n)
