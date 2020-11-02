; FET Loader
; A simple cheats loader written in AHK.
; Copyright (C) 2020 CodISH inc. (headed by m4x3r)
; https://github.com/clangremlini/fet-ahk-loader
; 
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;
;@Ahk2Exe-SetName               FET Loader
;@Ahk2Exe-SetDescription        A simple cheats loader written in AHK.
;@Ahk2Exe-SetCopyright          Copyright (C) 2020 CodISH inc.
;@Ahk2Exe-SetCompanyName        CodISH Inc.
;@Ahk2Exe-SetProductVersion     2.2.8
;@Ahk2Exe-SetVersion            2.2.8

global script = "FET Loader"
global version = "v2.2.8"
global build_type = "release" ; release or alpha or beta
global pastebin_key = "" ; Pastebin API Key


global times = 3 ; piece of shit, don't touch

#NoEnv
#NoTrayIcon
SetBatchLines, -1
CoordMode, Mouse, Screen

#Include Lib\Neutron.ahk
#Include Lib\Logging.ahk
#include Lib\lang_strings.ahk 
#include Lib\OTA.ahk
#include Lib\Pastebin.ahk
#SingleInstance Off

FileDelete, C:\FET Loader\cheats.ini
FileDelete, C:\FET Loader\*.dll

ConfigOpen() ;for old gui
{
    run, C:\FET Loader\config.ini
}

RunAsAdmin()
{
    if (A_IsAdmin = false) 
    { 
        Logging(1,"Restarting as admin...")
        Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel
        ExitApp
    }
}
ShowAbout() ;for old gui
{
	Logging(1,"Building About GUI...")
	IfNotExist, %A_TEMP%\cheats.ini
	{
		cheatsCount = "Не удалось получить список читов"
	} else {
		IniRead, cheatlist, %A_TEMP%\cheats.ini, cheatlist, cheatlist
		StringSplit, cheatss, cheatlist, |
		cheatsCount := cheatss0
	}
	Gui, About:New
	Gui, About:Font, s9
	Gui, About:Show, w315 h155, %script% %version% | About
	Gui, About:Add, Text, x112 y9 w100 h20 +Center, %script%
	Gui, About:Add, Text, x59 y29 w200 h30 +Center, %string_desc%
	Gui, About:Add, Link, x79 y69 w200 h20 +Center, %string_devs% <a href="https://m4x3r.xyz/">%string_dev1%</a> and <a href="https://gl1c1n.life/">%string_dev2%</a>
	Gui, About:Add, Text, x59 y89 w200 h20 +Center, %string_count% %cheatsCount%
	Gui, About:Add, Link, x50 y115 w100 h20 +Center, <a href="https://github.com/clangremlini/fet-loader">Github</a>
	Gui, About:Add, Link, x140 y115 w100 h20 +Center, <a href="https://t.me/fetloader">Telegram</a>
	Gui, About:Add, Link, x230 y115 w100 h20 +Center, <a href="https://qiwi.com/n/m4x3r1337">Donate</a>
	Logging(1,"done.")
	return  
}



RegRead, winedition, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, ProductName
RegRead, winver, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, ReleaseID
winbuild := DllCall("GetVersion") >> 16 & 0xFFFF

Logging(1,"Starting "script " " version "...")

RunAsAdmin()

IniRead, cheatrepo, C:\FET Loader\config.ini, settings, cheatrepo

Logging(1, "Creating folders and downloading files...")
IfNotExist, C:\FET Loader\cheats.ini
{	
    Logging(1, "Getting cheat list...")
    UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/cheats.ini, C:\FET Loader\cheats.ini
    Logging(1, "done.")
}
IfNotExist, C:\FET Loader\vac-bypass.exe
{
    Logging(1,"Downloading vac-bypass.exe...")
    UrlDownloadToFile, https://github.com/clangremlini/fetloader-dll-repo/raw/master/vac-bypass.exe, C:\FET Loader\vac-bypass.exe
    Logging(1, "done.")
}
IfNotExist, C:\FET Loader\emb.exe
{
    Logging(1,"Downloading emb.exe...")
    UrlDownloadToFile, https://github.com/clangremlini/fetloader-dll-repo/raw/master/emb.exe, C:\FET Loader\emb.exe
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
Logging(1,"Version: "winver)
Logging(1,"Build No.: "winbuild)
Logging(1,"Loader Location: "A_ScriptFullPath)
Logging(1,"Cheat Repo: "cheatrepo)
if (A_IsUnicode = true) {
    Logging(1,"Compiler Type: UTF-8")
} else {
    Logging(1,"Compiler Type: ANSI")
}
Logging(1,"Compiler Version: "A_AhkVersion)
Logging(1,"---ENV---")
Logging(1, "")

Logging(1, "Unpacking GUI...")
SetWorkingDir, C:\FET Loader
FileCreateDir, Web
FileCreateDir, Web\js
FileCreateDir, Web\css
FileInstall, Web\js\bootstrap-4.4.1.js, Web\js\bootstrap-4.4.1.js, 1
FileInstall, Web\css\bootstrap-4.4.1.css, Web\css\bootstrap-4.4.1.css, 1
FileInstall, Web\js\jquery-3.4.1.min.js, Web\js\jquery-3.4.1.min.js, 1
FileInstall, Web\js\popper.min.js, Web\js\popper.min.js, 1
FileInstall, Web\main.html, Web\main.bak, 1
FileInstall, Web\css\buttons.css, Web\css\buttons.css, 1


IniRead, oldgui, C:\FET Loader\config.ini, settings, oldgui
IniRead, cheatlist, C:\FET Loader\cheats.ini, cheatlist, cheatlist
IniRead, checkupdates, C:\FET Loader\config.ini, settings, checkupdates
IniRead, cheatrepo, C:\FET Loader\config.ini, settings, cheatrepo

Logging(1, "done.")

if (checkupdates = "true" and build_type = "release")
{
    Logging(1,"Checking updates...")
    OTA.checkupd()
}
if (oldgui = "true")
{
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
    Loop, Read, C:\FET Loader\cheats.ini
    {
    total_lines = %A_Index%
    }
    guiheight := (total_lines - 2) * 40 - 1 + 40
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

    Inject(neutron, event)
    {
        if (build_type != "release")
        {
            MsgBox % "[DEBUG] Trying to inject " event
        }
        Process, Wait, csgo.exe, 1
        PID = %ErrorLevel%

        if (PID == 0)
        {
            Logging(2,"csgo process not found. promting to start.")
            MsgBox, 4, %script%, %string_pid0%
            IfMsgBox, Yes
            try {
                Logging(1,"Starting csgo...")
                Run, steam://run/730
                Return
            } catch e {
                MsgBox, 0, %script%, %string_nosteam%
                Logging(2,"steam not found")
                return
            }
            IfMsgBox, No
            Return
        }
        if (PID > 0 and event != "Load DLL") ;govnokod mne poxui
        {
            Logging(1,"Initialized dll injection")
            IniRead, dll, C:\FET Loader\cheats.ini, cheats, %event%
            IniRead, cheatrepo, C:\FET Loader\config.ini, settings, cheatrepo

            Loop 3
            {   
                IfNotExist, C:\FET Loader\%dll%
                {
                    Logging(1,"Trying download " DLL " from https://github.com/" cheatrepo "/raw/master/"dll " to C:\FET Loader\"dll)
                    UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/%dll%, C:\FET Loader\%dll%
                    if (ErrorLevel = "0")
                    {
                        Logging(1, "done.")
                    }
                    else
                    {
                        timesretrying = times - 1   
                        Logging(0, "something went wrong. retrying (" timesretrying " times")

                    }
                    
                }
            }
            IfNotExist, C:\FET Loader\emb.exe
            {
                Logging(1,"Downloading emb.exe...")
                UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/emb.exe, C:\FET Loader\emb.exe
                Logging(1, "done.")
            }
            Logging(1,"Running emb...")
            Run, C:\FET Loader\emb.exe
            Logging(1, "done.")
            Sleep, 1500
            TO_LOAD = C:\FET Loader\%dll%
            Logging(1,"Injecting " TO_LOAD "...")
            Inject_Dll(PID,TO_LOAD)
            Logging(1,"Injected " TO_LOAD)
            Return
        }
        if (PID > 0 and event = "Load DLL")
        {
            MsgBox, 4, %script%, %string_warning_custom_dll%
            IfMsgBox, Yes
            {
                Logging(1,"Initialized custom injection")
                FileSelectFile, DLL, 3, , %script% | Select DLL, DLL (*.dll)
                if (DLL = "")
                {
                    Logging(1,"DLL not selected")
                    MsgBox, 0, %script%, %string_no_dll%
                }
                else
                {
                    Logging(1,"Injecting custom dll...")
                    Logging(1,"Running emb...")
                    Run, C:\FET Loader\emb.exe
                    Logging(1, "done.")
                    Sleep, 1500
                    Inject_Dll(PID,DLL)
                    Logging(1,"Injected custom dll")
                }
            }
        }
    }

Bypass(neutron)
{
    IfNotExist, C:\FET Loader\vac-bypass.exe
    {
        Logging(1,"Downloading vac-bypass.exe...")
        UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/vac-bypass.exe, C:\FET Loader\vac-bypass.exe
        Logging(1, "done.")
    }
    Logging(1, "Running bypass...")
    Run, C:\FET Loader\vac-bypass.exe
    Logging(1, "done.")
    return
}

OpenSource(neutron) ; костыли по другому не работают
{
    Run, https://github.com/clangremlini/fet-loader
}
UploadLog(neutron)
{
    Pastebin.UploadLog()
}