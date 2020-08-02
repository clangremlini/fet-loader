#Include Lib\Logging.ahk

IfNotExist, C:\AYE
{	
	Logging(1, "Creating folder...")
	FileCreateDir, C:\AYE
}
IfNotExist, C:\AYE\config.ini
{	
	Logging(1, "Creating config file...")
	IniWrite, false, C:\AYE\config.ini, settings, custominject
	IniWrite, true, C:\AYE\config.ini, settings, checkupdates
    IniWrite, false, C:\AYE\config.ini, settings, oldgui
	Logging(1, "done.")
}


checkConfigValue("settings","oldgui","false")
checkConfigValue("settings","checkupdates","true")

checkConfigValue(section,key,value)
{   
    IniRead, output_key, C:\AYE\config.ini, %section%, %key%
    if (output_key = "ERROR")
    {   
        Logging(2,"Not found " key " in config. Updating config file")
        IniWrite, %value%, C:\AYE\config.ini, %section%, %key%
    }
}

IniRead, language, C:\AYE\config.ini, settings, language

if (language = "ERROR")
{
    Logging(2,"Not found language line in config. Updating variables...")
	MsgBox, 68, AYE Loader, Если вы хотите использовать Русский язык, нажмите Да.`nIf you want to use English, click No.`n`nДанное сообщение появляется только при первом запуске.`nThis message appears only on the first launch.`n`nВы можете изменить язык в конфигурационном файле.`nYou can change the language in the configuration file. (C:\AYE\config.ini)
	IfMsgBox, Yes
		IniWrite, ru, C:\AYE\config.ini, settings, language
	IfMsgBox, No
		IniWrite, en, C:\AYE\config.ini, settings, language
}

IniRead, language, C:\AYE\config.ini, settings, language
if (language = "en") 
{
    global string_load := "Load"
    global string_bypass := "Enable VAC bypass"
    global string_config := "Config"
    global string_about := "About"
    global string_pid0 := "No csgo.exe process found. Run it?"
    global string_nosteam := "Install steam, retard."
    global string_success := "Successful injection!"
    global string_warning_custom_dll := "We're not gonna help you if your fucking system is gonna blow the fucking wine off it's not our fault. `nGot it?"
    global string_no_dll := "You didn't choose the DLL."
    global string_desc := "AYE loader with open-source for AYE boys."
    global string_devs := "Developers:"
    global string_dev1 := "m4x3r1337"
    global string_dev2 := "rf0x1d"
    global string_count := "Current cheats count:"
    global string_new_version := "A new version is available."
    global string_want_download := "Want to download the update?"
    global string_changelog := "Changelog:"
}
if (language = "ru") 
{
    global string_load := "Заинжектить"
    global string_bypass := "Включить VAC bypass"
    global string_config := "Настройки"
    global string_about := "Инфо"
    global string_pid0 := "Процесс csgo.exe не найден. Запустить?"
    global string_nosteam := "Установи Steam, клоун."
    global string_success := "Инжект прошел успешно"
    global string_warning_custom_dll := "Мы не будем тебе помогать если у тебя нахуй система полетит винда нахуй слетит это не наша вина.`nПонял?"
    global string_no_dll := "Ты не выбрал DLL."
    global string_desc := "АУЕ лоадер для АУЕ пацанов с открытым исходным кодом."
    global string_devs := "Разработчики:"
    global string_dev1 := "m4x3r1337"
    global string_dev2 := "rf0x1d"
    global string_count := "Текущее кол-во читов:"
    global string_new_version := "Доступна новая версия."
    global string_want_download := "Хотите скачать обновление?"
    global string_changelog := "Список изменений:"
}
if (language = "eblo") 
{
    global string_load := "Соснуть хуй"
    global string_bypass := "Насрать VAC bypass"
    global string_config := "Хуенфиг"
    global string_about := "Докс"
    global string_pid0 := "ААХАХАХАХ ДАУН КСГО ЗАПУСТИ ЛМАО"
    global string_nosteam := "Установи Steam, клоун."
    global string_success := "твоя мама выебана успешна"
    global string_warning_custom_dll := "Мы не будем тебе помогать если у тебя нахуй система полетит винда нахуй слетит это не наша вина.`nПонял?"
    global string_no_dll := "ало уебок длл выбери"
    global string_desc := "АУЕ лоадер для АУЕ пацанов с открытым исходным кодом."
    global string_devs := "кодеры):"
    global string_dev1 := "m4x3r1337"
    global string_dev2 := "rf0x1d"
    global string_count := "Текущее кол-во хуев в твоей жопе:"
    global string_new_version := "Доступна новая версия."
    global string_want_download := "Хотите сосать обновление?"
    global string_changelog := "Список членов in ur ass:"
}