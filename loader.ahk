; AYE Loader
; A simple cheats loader written in AHK.
; Copyright (C) 2020 CodISH inc. (headed by m4x3r)
; https://github.com/clangremlini/aye-ahk-loader
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
;@Ahk2Exe-SetName               AYE Loader
;@Ahk2Exe-SetDescription        A simple cheats loader written in AHK.
;@Ahk2Exe-SetCopyright          Copyright (C) 2020 CodISH inc.
;@Ahk2Exe-SetCompanyName        CodISH Inc.
;@Ahk2Exe-SetProductVersion     2.2.8.1.3.3.7
;@Ahk2Exe-SetVersion            2.2.8.1.3.3.7

global script = "AYE Loader"
global version = "v2.2.8.1.3.3.7"
global build_type = "release"

#NoEnv
#NoTrayIcon
SetBatchLines, -1
CoordMode, Mouse, Screen

#Include Lib\Neutron.ahk
#Include Lib\Logging.ahk
#include Lib\lang_strings.ahk 
#include Lib\OTA.ahk
#SingleInstance Off

ConfigOpen()
{
    run, C:\AYE\config.ini
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

FileDelete, C:\AYE\cheats.ini
FileDelete, C:\AYE\*.dll

RegRead, winedition, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, ProductName
RegRead, winver, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, ReleaseID
winbuild := DllCall("GetVersion") >> 16 & 0xFFFF

Logging(1,"Starting "script " " version "...")

RunAsAdmin()

IniRead, cheatrepo, C:\AYE\config.ini, settings, cheatrepo

Logging(1, "Creating folders and downloading files...")
IfNotExist, C:\AYE\cheats.ini
{	
    Logging(1, "Getting cheat list...")
    UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/cheats.ini, C:\AYE\cheats.ini
    Logging(1, "done.")
}
IfNotExist, C:\AYE\vac-bypass.exe
{
    Logging(1,"Downloading vac-bypass.exe...")
    UrlDownloadToFile, https://github.com/clangremlini/ayeloader-dll-repo/raw/master/vac-bypass.exe, C:\AYE\vac-bypass.exe
    Logging(1, "done.")
}
IfNotExist, C:\AYE\emb.exe
{
    Logging(1,"Downloading emb.exe...")
    UrlDownloadToFile, https://github.com/clangremlini/ayeloader-dll-repo/raw/master/emb.exe, C:\AYE\emb.exe
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
SetWorkingDir, C:\AYE
FileCreateDir, Web
FileCreateDir, Web\js
FileCreateDir, Web\css
FileInstall, Web\js\bootstrap-4.4.1.js, Web\js\bootstrap-4.4.1.js, 1
FileInstall, Web\css\bootstrap-4.4.1.css, Web\css\bootstrap-4.4.1.css, 1
FileInstall, Web\js\jquery-3.4.1.min.js, Web\js\jquery-3.4.1.min.js, 1
FileInstall, Web\js\popper.min.js, Web\js\popper.min.js, 1
FileInstall, Web\main.html, Web\main.bak, 1
FileInstall, Web\css\buttons.css, Web\css\buttons.css, 1


IniRead, custominject, C:\AYE\config.ini, settings, custominject
IniRead, checkupdates, C:\AYE\config.ini, settings, checkupdates
IniRead, cheatrepo, C:\AYE\config.ini, settings, cheatrepo

StringLower, custominject, custominject
Logging(1, "done.")

if (checkupdates = "true" and build_type = "release")
{
    Logging(1,"Checking updates...")
    OTA.checkupd()
}
FileRead, gui, Web\main.bak
StringReplace, newgui, gui, clangremlini/ayeloader-dll-repo, %cheatrepo%, All
FileAppend, %newgui%, Web\main.html 
neutron := new NeutronWindow()
neutron.Load("Web\main.html")
Loop, Read, C:\AYE\cheats.ini
{
   total_lines = %A_Index%
}
guiheight := (total_lines - 2) * 40 - 1 + 40
neutron.Show("w320 h" guiheight )
neutron.Gui("+LabelNeutron")
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
            IniRead, dll, C:\AYE\cheats.ini, cheats, %event%
            IniRead, cheatrepo, C:\AYE\config.ini, settings, cheatrepo

            IfNotExist, C:\AYE\%dll%
            {
                Logging(1,"Downloading " DLL " from https://github.com/" cheatrepo "/raw/master/"dll " ...")
                UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/%dll%, C:\AYE\%dll%
                Sleep 2500
                Logging(1, "done.")
            }
            IfNotExist, C:\AYE\emb.exe
            {
                Logging(1,"Downloading emb.exe...")
                UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/emb.exe, C:\AYE\emb.exe
                Logging(1, "done.")
            }
            Logging(1,"Running emb...")
            Run, C:\AYE\emb.exe
            Logging(1, "done.")
            Sleep, 1500
            TO_LOAD = C:\AYE\%dll%
            Logging(1,"Injecting " DLL "...")
            Inject_Dll(PID,TO_LOAD)
            Logging(1,"Injected " DLL)
            Return
        }
        if (PID > 0 and Cheat = "Load DLL")
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
                    Run, C:\AYE\emb.exe
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
    IfNotExist, C:\AYE\vac-bypass.exe
    {
        Logging(1,"Downloading vac-bypass.exe...")
        UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/vac-bypass.exe, C:\AYE\vac-bypass.exe
        Logging(1, "done.")
    }
    Logging(1, "Running bypass...")
    Run, C:\AYE\vac-bypass.exe
    Logging(1, "done.")
    return
}

OpenSource(neutron) ; костыли по другому не работают
{
    Run, https://github.com/clangremlini/aye-ahk-loader
}
