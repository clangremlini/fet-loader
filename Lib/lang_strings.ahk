#Include Lib\Logging.ahk

IfNotExist, C:\AYE
{	
	Logging(1, "Creating folder...")
	FileCreateDir, C:\AYE
}
IfNotExist, C:\AYE\custom
{	
	FileCreateDir, C:\AYE\custom
}
IfNotExist, C:\AYE\config.ini
{	
	Logging(1, "Creating config file...")
	IniWrite, false, C:\AYE\config.ini, settings, custominject
	IniWrite, true, C:\AYE\config.ini, settings, checkupdates
    IniWrite, false, C:\AYE\config.ini, settings, oldgui
	Logging(1, "done.")
}


checkConfigValue("C:\AYE\config.ini","settings","oldgui","false")
checkConfigValue("C:\AYE\config.ini","settings","oldgui","false")
checkConfigValue("C:\AYE\config.ini","settings","checkupdates","true")
checkConfigValue("C:\AYE\custom\custom.ini","dlls","customlist","Slot1|Slot2|Slot3|Slot4|Slot5")

checkConfigValue(file,section,key,value)
{   
    IniRead, output_key, %file%, %section%, %key%
    if (output_key = "ERROR")
    {   
        Logging(2,"Not found " key " in config. Updating config file")
        IniWrite, %value%, %file%, %section%, %key%
    }
}

IniRead, language, C:\AYE\config.ini, settings, language

setLang()
{
    if (A_Language = "0809" or A_Language = "0409") ; en_UK and en_US
        IniWrite, en, C:\AYE\config.ini, settings, language
    if (A_Language = "0419") ; ru_RU
	    IniWrite, ru, C:\AYE\config.ini, settings, language
    if (A_Language = "0422") ; ukr
        IniWrite, ukr, C:\AYE\config.ini, settings, language
}

if (language = "ERROR")
{
    setLang()
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
    global string_dll_not_found1 := "No dll file named "
    global string_dll_not_found2 := ".dll found`nin folder C:\AYE\custom"
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
    global string_dll_not_found1 := "Не найден dll файл с названием "
    global string_dll_not_found2 := ".dll`nв папке C:\AYE\custom"
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
    global string_dll_not_found1 := "Не найдена очередная дллка с ратником, с названием "
    global string_dll_not_found2 := ".dll`nв папке C:\AYE\custom"
    
}
if (language = "hvh") 
{
    global string_load := "Заижектить фри хуйню"
    global string_bypass := "Получить вак"
    global string_config := "Сетинг"
    global string_about := "уиды овнеров"
    global string_pid0 := "але нищий даун запусти кс хуесос"
    global string_nosteam := "АЫЖАЫАХЫАЗХЫЗ БРЕЙНА 0 БЕЗ СТИМА"
    global string_success := "ыазыазы нищита с кряком ору"
    global string_warning_custom_dll := "если у тебя минус винда нам абсолютно похуй потому что ты сам виноват дауна сын"
    global string_no_dll := "нищ, выбери длл."
    global string_desc := "Ауе лоадер для Ауе пацанів з відкритим вихідним кодом."
    global string_devs := "Овнеры:"
    global string_dev1 := "m4x3r1337"
    global string_dev2 := "rf0x1d"
    global string_count := "Количество фри помоек:"
    global string_new_version := "Новая версия вышла обновись."
    global string_want_download := "Гетнуть ауе лоадер?"
    global string_changelog := "Список улудшений:"
    global string_dll_not_found1 := "Не найдена очередная дллка с ратником, с названием "
    global string_dll_not_found1 := ".dll`nв папке C:\AYE\custom"
}
if (language = "ukr") 
{
    global string_load := "З'їсти сало"
    global string_bypass := "Включити VAC bypass"
    global string_config := "Настройка"
    global string_about := "Інформація"
    global string_pid0 := "Процес csgo.exe не знайдено. Запустити?"
    global string_nosteam := "Встанови Steam, москаль."
    global string_success := "Інжект пройшов успішно"
    global string_warning_custom_dll := "Ми не будемо тобі допомагати якщо у тебе нахуй система полетить вінда нахуй злетить це не наша вина.'nзрозумів?"
    global string_no_dll := "Ти не вибрав DLL."
    global string_desc := "Ауе лоадер для Ауе пацанів з відкритим вихідним кодом."
    global string_devs := "Розробник:"
    global string_dev1 := "m4x3r1337"
    global string_dev2 := "rf0x1d"
    global string_count := "Поточна кількість читів:"
    global string_new_version := "Доступна нова версія."
    global string_want_download := "Хочете завантажити оновлення?"
    global string_changelog := "Список змін:"
    global string_dll_not_found1 := "Не знайдено DLL файл з назвою "
    global string_dll_not_found1 := ".dll`nв папці C:\AYE\custom"
}