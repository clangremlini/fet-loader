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
ShowAbout(neutron)
{
	Logging(1,"Building About GUI...")
	Gui, About:New
	Gui, About:Font, s9
	Gui, About:Show, w315 h155, %script% %version% | About
	Gui, About:Add, Text, x112 y9 w100 h30 +Center, %script% | %bruhshit%
	Gui, About:Add, Text, x59 y37 w200 h30 +Center, FET лоадер для FET пацанов от разработчиков из FETьмы
	Gui, About:Add, Link, x75 y69 w200 h20 +Center, Разработчики: <a href="https://m4x3r.xyz/">m4x3r</a>, <a href="https://github.com/toxyxd">toxyxd</a> и <a href="https://rf0x3d.su">rf0x3d</a>
	Gui, About:Add, Link, x50 y115 w100 h20 +Center, <a href="https://github.com/clangremlini/fet-loader">Github</a>
	Gui, About:Add, Link, x140 y115 w100 h20 +Center, <a href="https://t.me/fetloader">Telegram</a>
	Gui, About:Add, Link, x230 y115 w100 h20 +Center, <a href="https://fetloader.xyz">Site</a>
	Logging(1,"done.")
	return  
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
