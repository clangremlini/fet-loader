ConfigOpen() ;for old gui
{
    run, %A_AppData%\FET Loader\config.ini
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
ShowAbout(neutron)
{
	Logging(1,"Building About GUI...")
	Gui, About:New
	Gui, About:Font, s9
	Gui, About:Show, w315 h155, %script% %version% | About
	Gui, About:Add, Text, x112 y9 w100 h30 +Center, %script% | %bruhshit%
	Gui, About:Add, Text, x59 y37 w200 h30 +Center, FET лоадер для FET пацанов от разработчиков из FETьмы
	Gui, About:Add, Link, x60 y69 w200 h20 +Center, Разработчики: <a href="https://m4x3r.xyz/">clownless</a>, <a href="https://github.com/toxyxd">toxyxd</a> и <a href="https://rf0x3d.su">rf0x3d</a>
	Gui, About:Add, Link, x50 y115 w100 h20 +Center, <a href="https://github.com/clangremlini/fet-loader">Github</a>
	Gui, About:Add, Link, x140 y115 w100 h20 +Center, <a href="https://t.me/fetloader">Telegram</a>
	Gui, About:Add, Link, x230 y115 w100 h20 +Center, <a href="https://fetloader.xyz">Site</a>
	Logging(1,"done.")
	return  
}
Bypass(neutron)
{
    IfNotExist, %A_AppData%\FET Loader\vac-bypass.exe
    {
        Logging(1,"Downloading vac-bypass.exe...")
        UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/vac-bypass.exe, %A_AppData%\FET Loader\vac-bypass.exe
        Logging(1, "done.")
    }
    Logging(1, "Running bypass...")
    Run, %A_AppData%\FET Loader\vac-bypass.exe
    Logging(1, "done.")
    return
}
OpenSource(neutron) ; костыли по другому не работают
{
    Run, https://github.com/clangremlini/fet-loader
}
Inject(neutron, event)
{
    if (build_status != "release")
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
        SoundPlay, %A_AppData%\FET Loader\inject.mp3
        Logging(1,"Initialized dll injection")
        IniRead, dll, %A_AppData%\FET Loader\cheats.ini, cheats, %event%
        IniRead, cheatrepo, %A_AppData%\FET Loader\config.ini, settings, cheatrepo

        Loop 3
        {   
            IfNotExist, %A_AppData%\FET Loader\%dll%
            {
                Logging(1,"Trying to download " dll " from https://github.com/" cheatrepo "/raw/master/" dll " to " A_AppData "\FET Loader\" dll)
                UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/%dll%, %A_AppData%\FET Loader\%dll%
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
        IfNotExist, %A_AppData%\FET Loader\emb.exe
        {
            Logging(1,"Downloading emb.exe...")
            UrlDownloadToFile, https://github.com/%cheatrepo%/raw/master/emb.exe, %A_AppData%\FET Loader\emb.exe
            Logging(1, "done.")
        }
        Logging(1,"Running emb...")
        Run, %A_AppData%\FET Loader\emb.exe
        Logging(1, "done.")
        Sleep, 1500
        TO_LOAD = %A_AppData%\FET Loader\%dll%
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
                Run, %A_AppData%\FET Loader\emb.exe
                Logging(1, "done.")
                Sleep, 1500
                Inject_Dll(PID,DLL)
                Logging(1,"Injected custom dll")
            }
        }
    }
}