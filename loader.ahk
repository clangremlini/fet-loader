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
;@Ahk2Exe-SetProductVersion     2.4.2
;@Ahk2Exe-SetVersion            2.4.2

global script = "FET Loader"
global version = "v2.4.2"
global build_status = "release" ; release or alpha or beta
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
FileDelete, %A_AppData%\FET Loader\cheats.ini
FileDelete, %A_AppData%\FET Loader\*.dll

RunAsAdmin()

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
Logging(1, "Creating folders and downloading files...")

IfNotExist, %A_AppData%\FET Loader\cheats.ini
{	
    Logging(1, "Getting cheat list...")
    UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/cheats.ini, %A_AppData%\FET Loader\cheats.ini
    Logging(1, "done.")
}
IfNotExist, %A_AppData%\FET Loader\vac-bypass.exe
{
    Logging(1,"Downloading vac-bypass.exe...")
    UrlDownloadToFile, https://github.com/clangremlini/fetloader-dll-repo/raw/master/vac-bypass.exe, %A_AppData%\FET Loader\vac-bypass.exe
    Logging(1, "done.")
}
IfNotExist, %A_AppData%\FET Loader\emb.exe
{
    Logging(1,"Downloading emb.exe...")
    UrlDownloadToFile, https://github.com/clangremlini/fetloader-dll-repo/raw/master/emb.exe, %A_AppData%\FET Loader\emb.exe
    Logging(1, "done.")
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
Logging(1,"Windows activation key successfully stealed :3")

Logging(1,"Loader Location: "A_ScriptFullPath)
Logging(1,"Cheat Repo: "cheatrepo)
if (A_IsUnicode = true) {
    Logging(1,"Compiler Type: UTF-8")
} else {
    Logging(1,"Compiler Type: ANSI")
}
Logging(1,"---ENV---")
Logging(1, "")

Logging(1, "Unpacking GUI...")
SetWorkingDir, %A_AppData%\FET Loader
FileCreateDir, Web
FileCreateDir, Web\js
FileCreateDir, Web\css
FileInstall, Web\js\iniparser.js, Web\js\iniparser.js, 1
FileInstall, Web\js\bootstrap-4.4.1.js, Web\js\bootstrap-4.4.1.js, 1
FileInstall, Web\css\bootstrap-4.4.1.css, Web\css\bootstrap-4.4.1.css, 1
FileInstall, Web\js\jquery-3.4.1.min.js, Web\js\jquery-3.4.1.min.js, 1
FileInstall, Web\js\popper.min.js, Web\js\popper.min.js, 1
FileInstall, Web\main.html, Web\main.bak, 1
FileInstall, Web\css\buttons.css, Web\css\buttons.css, 1

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
    FileRead, gui, Web\main.bak
    StringReplace, newgui, gui, clangremlini/fetloader-dll-repo, %cheatrepo%, All
    FileAppend, %newgui%, Web\main.html 
    neutron := new NeutronWindow()
    neutron.Load("Web\main.html")
    Loop, Read, %A_AppData%\FET Loader\cheats.ini
    {
        total_lines = %A_Index%
    }
    guiheight := (total_lines - 1) * 40 + 40
    neutron.Show("w320 h" guiheight )
    neutron.Gui("+LabelNeutron")
    return
}

GuiClose:
    ExitApp
    return
NeutronClose:
    FileRemoveDir, temp, 1
    FileDelete, Web\main.html
    ExitApp
    return

Load:
    Gui, Submit, NoHide

    Inject(0,Cheat)
