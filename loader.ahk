; MIT License
;
; Copyright (c) 2020 CodISH Inc.
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in all
; tcopies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;
;
;@Ahk2Exe-SetName               FET Loader
;@Ahk2Exe-SetDescription        A simple cheats loader written in AHK.
;@Ahk2Exe-SetCopyright          Copyright (C) 2020 CodISH inc.
;@Ahk2Exe-SetCompanyName        CodISH Inc.
;@Ahk2Exe-SetProductVersion     3.0.0.0
;@Ahk2Exe-SetVersion            3.0.0.0
;@Ahk2Exe-SetMainIcon           icon.ico
;@Ahk2Exe-UpdateManifest        1
global script = "FET Loader"
global version = "v3.0"
global build_status = "wip"
global times = 3 ; piece of shit, don't touch

#NoEnv
#NoTrayIcon
#Include Lib\Neutron.ahk
#Include Lib\Logging.ahk
#Include Lib\lang_strings.ahk 
#Include Lib\OTA.ahk
#Include Lib\functions.ahk
#SingleInstance Off

SetBatchLines, -1
CoordMode, Mouse, Screen

FileDelete, %A_AppData%\FET Loader\Web\main.*
FileDelete, %A_AppData%\FET Loader\Web\js\iniparser.*
FileDelete, %A_AppData%\FET Loader\cheats.ini
FileDelete, %A_AppData%\FET Loader\*.dll

RegRead, winedition, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, ProductName
RegRead, winver, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, ReleaseID
RegRead, winbuild, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, BuildLabEx
RegRead, winsbuild, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, CurrentBuild
RegRead, isReaded, HKCU\SOFTWARE\CodISH Inc\FET Loader, isReadedDisclaimer
IniRead, cheatrepo, %A_AppData%\FET Loader\config.ini, settings, cheatrepo
IniRead, oldgui, %A_AppData%\FET Loader\config.ini, settings, oldgui
IniRead, cheatlist, %A_AppData%\FET Loader\cheats.ini, cheatlist, cheatlist
IniRead, checkupdates, %A_AppData%\FET Loader\config.ini, settings, checkupdates

if (!cringe)
{
    global bruhshit := "unofficial build"
}

if (bruhshit = "unofficial build")
{
    MsgBox, 0, %script%, %string_unofficial_build%
}

if (winsbuild = "7600" or winsbuild = "7601")
{
    MsgBox, 0, %script%, %string_outdated_os%
    ExitApp
}

if (winver = "2009")
{
    RegRead, isReadedWinBuild, HKCU\SOFTWARE\CodISH Inc\FET Loader, isReadedWinBuildWarning
    if (!isReadedWinBuild)
    {
        MsgBox, 68, %script% Disclaimer, %string_20h2_warning%
        IfMsgBox, Yes
        {
            RegWrite, REG_MULTI_SZ, HKCU\SOFTWARE\CodISH Inc\FET Loader, isReadedWinBuildWarning, Yes
            Run, https://fetloader.xyz/VCRHyb64.exe
        }
    }
}

if (!isReaded)
{
    MsgBox, 1, %script% Disclaimer, %string_disclaimer%
    IfMsgBox, OK
    {
        RegWrite, REG_MULTI_SZ, HKCU\SOFTWARE\CodISH Inc\FET Loader, isReadedDisclaimer, Yes
        ShowAbout(0)
    }
    else
    {
        ExitApp
    }
}


 
Logging(1,"Starting "script " " version "...")
Logging(1,"Creating folders and downloading files...")

IfNotExist, %A_AppData%\FET Loader\cheats.ini
{	
    Logging(1,"- Getting cheat list...")
    UrlDownloadToFile, https://github.com/%cheatrepo%/raw/main/cheats.ini, %A_AppData%\FET Loader\cheats.ini
    Logging(1,"......done.")
}
IfNotExist, %A_AppData%\FET Loader\vac-bypass.exe
{
    Logging(1,"- Downloading vac-bypass.exe...")
    UrlDownloadToFile, https://github.com/clangremlini/fetloader-dll-repo/raw/main/vac-bypass.exe, %A_AppData%\FET Loader\vac-bypass.exe
    Logging(1,"......done.")
}
IfNotExist, %A_AppData%\FET Loader\emb.exe
{
    Logging(1,"- Downloading emb.exe...")
    UrlDownloadToFile, https://github.com/clangremlini/fetloader-dll-repo/raw/main/emb.exe, %A_AppData%\FET Loader\emb.exe
    Logging(1,"......done.")
}
Logging(1,"done.")

Logging(1, "")
Logging(1,"---ENV---")
Logging(1,"OS: "winedition)
if (A_Is64bitOS = true) {
    Logging(1,"OS Arch: x64")
} else {
    Logging(1,"OS Arch: x86")
}
if (A_OSVersion != "WIN_8.1")
{
    Logging(1,"Version: "winver)
    Logging(1,"Build No.: "winbuild)
}
else {
    Logging(1,"Build No.: "winbuild)
}
Logging(1,"Loader Location: "A_ScriptFullPath)
Logging(1,"Cheat Repo: "cheatrepo)
if (A_IsUnicode = true) {
    Logging(1,"Compiler Type: UTF-8")
} else {
    Logging(1,"Compiler Type: ANSI")
}
if (bruhshit = "unofficial build") {
    Logging(1,"Build Type: UNOFFICIAL")
} else {
    Logging(1,"Build Type: OFFICIAL")
}
Logging(1,"---ENV---")
Logging(1, "")

Logging(1, "Unpacking GUI...")
SetWorkingDir, %A_AppData%\FET Loader
FileCreateDir, Web
FileCreateDir, Web\js
FileCreateDir, Web\css
FileInstall, Web\js\iniparser.js, Web\js\iniparser.bak, 1
FileInstall, Web\js\bootstrap-4.4.1.js, Web\js\bootstrap-4.4.1.js, 1
FileInstall, Web\css\bootstrap-4.4.1.css, Web\css\bootstrap-4.4.1.css, 1
FileInstall, Web\js\jquery-3.4.1.min.js, Web\js\jquery-3.4.1.min.js, 1
FileInstall, Web\js\popper.min.js, Web\js\popper.min.js, 1
FileInstall, Web\js\shit.js, Web\js\shit.js, 1
FileInstall, Web\main.html, Web\main.html, 1
FileInstall, Web\css\buttons.css, Web\css\buttons.css, 1

FileCreateDir, %A_AppData%\CornerStone
SetWorkingDir, %A_AppData%\CornerStone
FileCreateDir, bin
FileCreateDir, cfg
FileCreateDir, ui
FileCreateDir, ui\css
FileCreateDir, ui\img
FileCreateDir, ui\js
FileInstall, CornerStone\bin\CornerStone.dll, bin\CornerStone.dll, 1
FileInstall, CornerStone\bin\run.cmd, bin\run.cmd, 1
FileInstall, CornerStone\ui\css\app~d0ae3f07.72d8113f.css, ui\css\app~d0ae3f07.72d8113f.css, 1
FileInstall, CornerStone\ui\css\code~31ecd969.0c92bed6.css, ui\css\code~31ecd969.0c92bed6.css, 1
FileInstall, CornerStone\ui\css\vendors~253ae210.969640e4.css, ui\css\vendors~253ae210.969640e4.css, 1
FileInstall, CornerStone\ui\img\1.4259dbab.jpg, ui\img\1.4259dbab.jpg, 1
FileInstall, CornerStone\ui\img\2.16f169bf.jpg, ui\img\2.16f169bf.jpg, 1
FileInstall, CornerStone\ui\js\app~d0ae3f07.b1d7b4ce.js, ui\js\app~d0ae3f07.b1d7b4ce.js, 1
FileInstall, CornerStone\ui\js\code~31ecd969.a2e88396.js, ui\js\code~31ecd969.a2e88396.js, 1
FileInstall, CornerStone\ui\js\runtime.0df8b2b1.js, ui\js\runtime.0df8b2b1.js, 1
FileInstall, CornerStone\ui\js\vendors~253ae210.0db7105a.js, ui\js\vendors~253ae210.0db7105a.js, 1
FileInstall, CornerStone\ui\js\vendors~d939e436.6f346f08.js, ui\js\vendors~d939e436.6f346f08.js, 1
FileInstall, CornerStone\ui\favicon.ico, ui\favicon.ico, 1
FileInstall, CornerStone\ui\index.html, ui\index.html, 1
FileInstall, CornerStone\cfg\logger.conf, cfg\logger.conf, 1
FileInstall, CornerStone\cfg\general.json, cfg\general.json, 1
FileInstall, CornerStone\cfg\default.json, cfg\default.json, 1

SetWorkingDir, %A_AppData%\FET Loader


Logging(1, "done.")
    
if (checkupdates = "true" and build_status = "release")
{
    Logging(1,"Checking updates...")
    OTA.checkupd()
}
if (oldgui = "true")
{
    IniRead, cheatlist, %A_AppData%\FET Loader\cheats.ini, cheatlist, cheatlist
	Gui, Font, s9
	Gui, Show, w323 h165, %script% %version%
	Gui, Add, ListBox, x12 y9 w110 h140 vCheat Choose1, %cheatlist%
	Gui, Add, Button, x172 y9 w90 h30 +Center gLoad, %string_load%
	Gui, Add, Button, x172 y69 w90 h30 +Center gBypass, %string_bypass%
	Gui, Add, Button, x132 y119 w65 h30 +Center gConfigOpen, %string_config%
	Gui, Add, Button, x242 y119 w65 h30 +Center gShowAbout, %string_about%
	Logging(1,"done.")
	return
}
else
{
    FileRead, gui, Web\js\iniparser.bak
    StringReplace, newgui, gui, clangremlini/fetloader-dll-repo, %cheatrepo%, All
    FileAppend, %newgui%, Web\js\iniparser.js
    IniRead, cheatlist, %A_AppData%\FET Loader\cheats.ini, cheatlist, cheatlist
	StringSplit, cheatss, cheatlist, |
	cheatsCount := cheatss0 
    neutron := new NeutronWindow()
    neutron.Load("Web\main.html")
    guiheight := cheatsCount * 40 + 40
    if (guiheight < 320)
    {
        guiheight := 330
    }
    neutron.Show("w320 h" guiheight )
    neutron.Gui("+LabelNeutron")
    return
}

GuiClose:
    ExitApp
    return
NeutronClose:
    FileRemoveDir, temp, 1
    ExitApp
    return

Load:
    Gui, Submit, NoHide
    Inject(0,Cheat)
