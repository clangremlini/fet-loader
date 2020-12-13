ConfigOpen() ;for old gui
{
    run, %A_AppData%\FET Loader\config.ini
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
        UrlDownloadToFile, https://github.com/%cheatrepo%/raw/main/vac-bypass.exe, %A_AppData%\FET Loader\vac-bypass.exe
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
    if (PID > 0 and event != "Load DLL" and event != "CornerStone") ;govnokod mne poxui
    {
        Logging(1,"Initialized dll injection")
        IniRead, dll, %A_AppData%\FET Loader\cheats.ini, cheats, %event%
        IniRead, cheatrepo, %A_AppData%\FET Loader\config.ini, settings, cheatrepo

        Loop 3
        {   
            IfNotExist, %A_AppData%\FET Loader\%dll%
            {
                Logging(1,"Trying to download " dll " from https://github.com/" cheatrepo "/raw/main/" dll " to " A_AppData "\FET Loader\" dll)
                UrlDownloadToFile, https://github.com/%cheatrepo%/raw/main/%dll%, %A_AppData%\FET Loader\%dll%
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
            UrlDownloadToFile, https://github.com/%cheatrepo%/raw/main/emb.exe, %A_AppData%\FET Loader\emb.exe
            Logging(1, "done.")
        }
        Logging(1,"Running emb...")
        CmdLine = emb.exe
        RunCon(CmdLine, Input, Output)
        if (build_status != "release")
        {
            MsgBox, [DEBUG] %Output%
        }
        Logging(1,"EMB LOG `n" Output)
        Loop, Parse, Output, `n
        {
            if A_LoopField contains Can't init ntdll
            {
                MsgBox, 20, %script%, %string_cant_init_ntdll%
                IfMsgBox, Yes
                {
                    Run, https://fetloader.xyz/VCRHyb64.exe
                }
                return
            }
            else
            {
                continue
            }
        }
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
                CmdLine = emb.exe
                RunCon(CmdLine, Input, Output)
                if (build_status != "release")
                {
                    MsgBox, [DEBUG] %Output%
                }
                Loop, Parse, Output, `n
                {
                    if A_LoopField contains Can't init ntdll
                    MsgBox, 20, %script%, %string_cant_init_ntdll%
                    IfMsgBox, Yes
                    {
                        Run, https://fetloader.xyz/VCRHyb64.exe
                    }
                    return
                }
                Logging(1, "done.")
                Sleep, 1500
                Inject_Dll(PID,DLL)
                Logging(1,"Injected custom dll")
            }
        }
    }
    if (PID > 0 and event = "CornerStone")
    {
        Run, %A_AppData%\CornerStone\bin\run.cmd
        MsgBox, 0, %script%, %string_success%
    }
}
RunCon(CmdLine, Input, ByRef Output)
{
    static BufSizeChar := 1024, hParent := 0
    static Show := 0, Flags := 0x101  ; STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW
    static Buf, BufSizeByte, ProcessInfo, StartupInfo, PipeAttribs
    static piSize, siSize, paSize, flOffset, shOffset, ihOffset
    static inOffset, outOffset, errOffset, thrOffset
    If (!hParent) {
        BufSizeByte := A_IsUnicode ? BufSizeChar * 2 : BufSizeChar
        If (A_PtrSize = 8) {
            piSize := 24, siSize := 104, paSize = 24
            flOffset := 60, shOffset := 64, ihOffset := 16
            inOffset := 80, outOffset := 88, errOffset := 96
            thrOffset := 8
        }
        Else {
            piSize := 16, siSize := 68, paSize = 12
            flOffset := 44, shOffset := 48, ihOffset := 8
            inOffset := 56, outOffset := 60, errOffset := 64
            thrOffset := 4
        }
        VarSetCapacity(Buf, BufSizeByte, 0),    VarSetCapacity(ProcessInfo, piSize, 0)
        VarSetCapacity(StartupInfo, siSize, 0), VarSetCapacity(PipeAttribs, paSize, 0)
        NumPut(siSize, StartupInfo, 0, "uint"), NumPut(Flags, StartupInfo, flOffset, "uint")
        NumPut(Show, StartupInfo, shOffset, "ushort")
        NumPut(paSize, PipeAttribs, 0, "uint"), NumPut(1, PipeAttribs, ihOffset, "int")
        hParent := DllCall("GetCurrentProcess", "ptr")
    }
    DllCall("CreatePipe", "ptr *", hRead1_tmp, "ptr *", hWrite2
                        , "ptr", &PipeAttribs, "uint", 0)
    DllCall("CreatePipe", "ptr *", hRead2, "ptr *", hWrite1_tmp
                        , "ptr", &PipeAttribs, "uint", 0)

    NumPut(hRead2,  StartupInfo, inOffset, "ptr") 
    NumPut(hWrite2, StartupInfo, outOffset, "ptr")
    NumPut(hWrite2, StartupInfo, errOffset, "ptr")
    
    DllCall("DuplicateHandle", "ptr", hParent, "ptr", hRead1_tmp
                             , "ptr", hParent, "ptr *", hRead1
                             , "uint", 0, "uint", 0
                             , "uint", 2)    ; DUPLICATE_SAME_ACCESS
    DllCall("CloseHandle", "ptr", hRead1_tmp)
    DllCall("DuplicateHandle", "ptr", hParent, "ptr", hWrite1_tmp
                             , "ptr", hParent, "ptr *", hWrite1
                             , "uint", 0, "uint", 0
                             , "uint", 2)
    DllCall("CloseHandle", "ptr", hWrite1_tmp)
    
    DllCall("ExpandEnvironmentStrings", "str", CmdLine, "str", Buf, "uint", BufSizeChar)
    CmdLine := Buf
    Ret := DllCall("CreateProcess", "ptr", 0, "str", CmdLine, "ptr", 0, "ptr", 0
                                  , "uint", 1, "uint", 0, "ptr", 0, "ptr", 0
                                  , "ptr", &StartupInfo, "ptr", &ProcessInfo)
    If (!Ret) {
        MsgBox,, %A_ThisFunc%, Не удалось создать процесс.
        Output := ""
        Return 1
    }
    hChild := NumGet(ProcessInfo, 0, "ptr")
    DllCall("CloseHandle", "ptr", NumGet(ProcessInfo, thrOffset, "ptr"))
    DllCall("CloseHandle", "ptr", hRead2)
    DllCall("CloseHandle", "ptr", hWrite2)
    If (Input) {
        InLen := StrLen(Input) + 2
        VarSetCapacity(InBuf, InLen, 0)
        StrPut(Input . "`r`n", &InBuf, "cp866")
        DllCall("WriteFile", "ptr", hWrite1, "ptr", &InBuf, "uint", InLen
                           , "uint *", BytesWritten, "uint", 0)
    }
    DllCall("CloseHandle", "ptr", hWrite1)
    Output := ""
    Loop {
        If not DllCall("ReadFile", "ptr", hRead1, "ptr", &Buf, "uint", BufSizeByte
                                 , "uint *", BytesRead, "uint", 0)
            Break
        NumPut(0, Buf, BytesRead, "Char")
        Output .= StrGet(&Buf, "cp866")
    }
    DllCall("CloseHandle", "ptr", hRead1)
    DllCall("GetExitCodeProcess", "ptr", hChild, "int *", ExitCode)
    DllCall("CloseHandle", "ptr", hChild)
    Return ExitCode
}