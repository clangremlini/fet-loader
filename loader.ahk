; AYE Loader
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

global script = "AYE Loader"
global version = "v2.0.3"
global build_type = "stable"

#NoEnv
#NoTrayIcon
SetBatchLines, -1
CoordMode, Mouse, Screen

#Include Lib\Neutron.ahk
#Include Lib\Logging.ahk
#include Lib\lang_strings.ahk 
#include Lib\OTA.ahk

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

Logging(1,"Starting "script " " version "...")

RunAsAdmin()

Logging(1, "Creating folders and downloading files...")
IfNotExist, C:\AYE\cheats.ini
{	
    Logging(1, "Getting cheat list...")
    UrlDownloadToFile, https://github.com/clangremlini/ayeloader-dll-repo/raw/master/cheats.ini, C:\AYE\cheats.ini
    Logging(1, "done.")
}
IfNotExist, C:\AYE\vac-bypass.exe
{
    Logging(1,"Downloading vac-bypass.exe...")
    UrlDownloadToFile, https://github.com/clangremlini/ayeloader-dll-repo/raw/master/vac-bypass.exe, C:\AYE\vac-bypass.exe
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


SetWorkingDir, C:\AYE
FileCreateDir, Web
FileCreateDir, Web\js
FileCreateDir, Web\css
FileInstall, Web\js\bootstrap-4.4.1.js, Web\js\bootstrap-4.4.1.js, 1
FileInstall, Web\css\bootstrap-4.4.1.css, Web\css\bootstrap-4.4.1.css, 1
FileInstall, Web\js\jquery-3.4.1.min.js, Web\js\jquery-3.4.1.min.js, 1
FileInstall, Web\js\popper.min.js, Web\js\popper.min.js, 1
FileInstall, Web\main.html, Web\main.html, 1
FileInstall, Web\css\buttons.css, Web\css\buttons.css, 1


IniRead, custominject, C:\AYE\config.ini, settings, custominject
IniRead, checkupdates, C:\AYE\config.ini, settings, checkupdates
StringLower, custominject, custominject
Logging(1, "done.")

if (checkupdates = "true" and build_type = "stable")
{
    Logging(1,"Checking updates...")
    OTA.checkupd()
}

neutron := new NeutronWindow()
neutron.Load("Web\main.html")
neutron.Show("w640 h680")
neutron.Gui("+LabelNeutron")
return

NeutronClose:
    FileRemoveDir, temp, 1
ExitApp
return

Load:
    Gui, Submit, NoHide

    Inject(neutron, event)
    {
        if (build_type != "stable")
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
            IfNotExist, C:\AYE\%dll%
            {
                Logging(1,"Downloading " DLL "...")
                UrlDownloadToFile, https://github.com/clangremlini/ayeloader-dll-repo/raw/master/%dll%, C:\AYE\%dll%
                Sleep 2500
                Logging(1, "done.")
            }
            IfNotExist, C:\AYE\emb.exe
            {
                Logging(1,"Downloading emb.exe...")
                UrlDownloadToFile, https://github.com/clangremlini/ayeloader-dll-repo/raw/master/emb.exe, C:\AYE\emb.exe
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
        UrlDownloadToFile, https://github.com/clangremlini/ayeloader-dll-repo/raw/master/vac-bypass.exe, C:\AYE\vac-bypass.exe
        Logging(1, "done.")
    }
    Logging(1, "Running bypass...")
    Run, C:\AYE\vac-bypass.exe
    Logging(1, "done.")
    return
}
