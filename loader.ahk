global script = "AYE Loader"
global version = "2.0.0-rc1"
global build_type = "alpha"

#NoEnv
SetBatchLines, -1
CoordMode, Mouse, Screen

#Include Lib\Neutron.ahk
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

SetWorkingDir %A_Temp%
FileCreateDir, Web
FileInstall, Web\bootstrap-4.4.1.js, Web\bootstrap-4.4.1.js, 1
FileInstall, Web\bootstrap-4.4.1.css, Web\bootstrap-4.4.1.css, 1
FileInstall, Web\jquery-3.4.1.min.js, Web\jquery-3.4.1.min.js, 1
FileInstall, Web\popper.min.js, Web\popper.min.js, 1
FileInstall, Web\main.html, Web\main.html, 1
FileInstall, Web\buttons.css, Web\buttons.css, 1

IniRead, custominject, C:\AYE\config.ini, settings, custominject
IniRead, checkupdates, C:\AYE\config.ini, settings, checkupdates
StringLower, custominject, custominject
Logging(1, "done.")

if (checkupdates = "true")
{
    Logging(1,"Checking updates...")
    OTA.checkupd()
}

neutron := new NeutronWindow()
neutron.Load("Web\main.html")
neutron.Show("w400 h600")
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
        Cheat = %event%
        MsgBox % "[DEBUG] Trying to inject " event ;
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
        if (Cheat != "Slot1" and Cheat != "Slot2" and Cheat != "Slot3" and Cheat != "Slot4" and Cheat != "Slot5") and (PID > 0) ;govnokod mne poxui
        {
            Logging(1,"Initialized dll injection")
            IniRead, dll, %A_TEMP%\cheats.ini, cheats, %Cheat%
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
            MsgBox, 0, %script%, %string_success%
            Logging(1,"Injected " DLL)
            Return
        }
    }

Bypass:
    {
        IfNotExist, C:\AYE\vac-bypass.exe
        {
            Logging(1,"Downloading vac-bypass.exe...")
            UrlDownloadToFile, https://github.com/clangremlini/ayeloader-dll-repo/raw/master/vac-bypass.exe, C:\AYE\vac-bypass.exe
            Logging(1, "done.")
        }
        Run, C:\AYE\vac-bypass.exe
        return
    }