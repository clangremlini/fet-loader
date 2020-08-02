#singleinstance, force
#notrayicon
#include Lib\lang_strings.ahk
#include Lib\OTA.ahk

global script = "AYE Loader"
global version = "v1.3.3.3"


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
	}
}
ShowAbout()
{
	Logging(1,"Building About GUI...")
	IfNotExist, %A_TEMP%\cheats.ini
	{
		cheatsCount = "Не удалось загрузить"
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
	Gui, About:Add, Link, x79 y69 w200 h20 +Center, %string_devs% <a href="https://m4x3r.xyz/">%string_dev1%</a> and <a href="https://rf0x3d.su/">%string_dev2%</a>
	Gui, About:Add, Text, x59 y89 w200 h20 +Center, %string_count% %cheatsCount%
	Gui, About:Add, Link, x50 y115 w100 h20 +Center, <a href="https://github.com/rfoxxxyshit/aye-ahk-loader">Github</a>
	Gui, About:Add, Link, x210 y115 w100 h20 +Center, <a href="https://qiwi.me/rfoxxxyshit">Donate :)</a>
	Logging(1,"done.")
	return	
}

FileDelete, %A_TEMP%\cheats.ini
FileDelete, C:\AYE\*.dll

Logging(1,"Starting "script " " version "...")

RunAsAdmin()
Logging(1, "Creating folders and downloading files...")
IfNotExist, %A_TEMP%\cheats.ini
{	
	Logging(1, "Getting cheat list...")
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/cheats.ini, %A_TEMP%\cheats.ini
	Logging(1, "done.")
}
IfNotExist, C:\AYE\vac-bypass.exe
{
	Logging(1,"Downloading vac-bypass.exe...")
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/vac-bypass.exe, C:\AYE\vac-bypass.exe
	Logging(1, "done.")
}
IfNotExist, C:\AYE\vac-bypass.exe
{
	Logging(1,"Downloading vac-bypass.exe...")
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/vac-bypass.exe, C:\AYE\vac-bypass.exe
	Logging(1, "done.")
}
IfNotExist, C:\AYE\emb.exe
{
	Logging(1,"Downloading emb.exe...")
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/emb.exe, C:\AYE\emb.exe
	Logging(1, "done.")
}

Logging(1,"Getting vars...")
IniRead, cheatlist, %A_TEMP%\cheats.ini, cheatlist, cheatlist
IniRead, custominject, C:\AYE\config.ini, settings, custominject
IniRead, checkupdates, C:\AYE\config.ini, settings, checkupdates
StringLower, custominject, custominject
Logging(1, "done.")

if (checkupdates = "true")
{
	Logging(1,"Checking updates...")
	OTA.checkupd()
}

IniRead, oldgui, C:\AYE\config.ini, settings, oldgui
Logging(1,"Building GUI...")
if (oldgui = "false")
{
	Gui, Font, s9
	Gui, Show, w323 h165, %script% %version%

	if (custominject = "true")
	{
		Logging(1,"Custom injection was enabled!")
		Gui, Add, ListBox, x12 y9 w110 h140 vCheat Choose1, %cheatlist%|Load DLL
	} else {
		Gui, Add, ListBox, x12 y9 w110 h140 vCheat Choose1, %cheatlist%
	}

	Gui, Add, Button, x172 y9 w90 h30 +Center gLoad, %string_load%
	Gui, Add, Button, x172 y69 w90 h30 +Center gBypass, %string_bypass%
	Gui, Add, Button, x132 y119 w60 h30 +Center gConfig, %string_config%
	Gui, Add, Button, x242 y119 w60 h30 +Center gAbout, %string_about%
	Logging(1,"done.")
	return
}
else 
{
	Gui, Font, s9
	Gui, Show, w315 h195, %script% %version%
	Gui, Add, Text, x112 y9 w100 h20 +Center, %script%
	Gui, Add, Progress, x22 y39 w270 h20 -smooth +Center vPbar

	if (custominject = "true")
	{
		Logging(1,"Custom injection was enabled!")
		Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%|Load DLL
	} else {
		Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%
	}
	Gui, Add, Button, x15 y129 w100 h30 +Center gLoad, %string_load%
	Gui, Add, Button, x200 y129 w100 h30 +Center gBypass, %string_bypass%
	Menu, AppMenu, Add, &%string_config%, ConfigOpen
	Menu, AppMenu, Add, &%string_about%, ShowAbout
	Gui, Menu, AppMenu
	GuiControl,, Pbar, 0
	Logging(1,"done.")
	return
}


GuiClose:
ExitApp
Load:
Gui, Submit, NoHide

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

if (Cheat != "Load DLL") and (PID > 0)
{
	Logging(1,"Initialized dll injection")
	IniRead, dll, %A_TEMP%\cheats.ini, cheats, %Cheat%
	FileDelete, C:\AYE\%dll%
	Sleep 1500
	IfNotExist, C:\AYE\%dll%
	{
		Logging(1,"Downloading " DLL "...")
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/%dll%, C:\AYE\%dll%
		Sleep 2500
		Logging(1, "done.")
	}
	IfNotExist, C:\AYE\emb.exe
	{
		Logging(1,"Downloading emb.exe...")
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/emb.exe, C:\AYE\emb.exe
		Logging(1, "done.")
	}
	Logging(1,"Running emb...")
	Run, C:\AYE\emb.exe
	Logging(1, "done.")
	Sleep, 1500
	TO_LOAD = C:\AYE\%dll%
	Logging(1,"Injecting " DLL "...")
	Inject_Dll(PID,TO_LOAD)
	MsgBox, %string_success%
	Logging(1,"Injected " DLL)
	Return
}


if (PID > 0) and (Cheat = "Load DLL")
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
		else {
			Logging(1,"Injecting custom dll...")
			Logging(1,"Running emb...")
			Run, C:\AYE\emb.exe
			Logging(1, "done.")
			INJECT := Inject_Dll(PID,DLL)
			if (!INJECT)
			{
				Logging(2,"Injection failed. DLL: " DLL)
				Return
			}
			MsgBox, %string_success%
			Logging(1,"Injected custom dll")
			ExitApp
		}
	}
	IfMsgBox, No
		Return
	Return
}
Bypass:
{
	Run, C:\AYE\vac-bypass.exe
	return
}

Config:
{
	ConfigOpen()
	return
}

About:
{
	ShowAbout()
	return
}