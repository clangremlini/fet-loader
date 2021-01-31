; compile with utf-8

#Include Lib\Logging.ahk

IfNotExist, %A_AppData%\FET Loader
{	
	Logging(1, "Creating folder...")
	FileCreateDir, %A_AppData%\FET Loader
}
IfNotExist, %A_AppData%\FET Loader\Web
{	
	FileCreateDir, %A_AppData%\FET Loader\Web
}
IfNotExist, %A_AppData%\FET Loader\config.ini
{	
	Logging(1, "Creating config file...")
	IniWrite, true, %A_AppData%\FET Loader\config.ini, settings, checkupdates
	IniWrite, clangremlini/fetloader-dll-repo, %A_AppData%\FET Loader\config.ini, settings, cheatrepo
    IniWrite, false, %A_AppData%\FET Loader\config.ini, settings, oldgui
	Logging(1, "done.")
}


isConfigValue(A_AppData "\FET Loader\config.ini","settings","oldgui","false")
isConfigValue(A_AppData "\FET Loader\config.ini","settings","checkupdates","true")
isConfigValue(A_AppData "\FET Loader\config.ini","settings","cheatrepo","clangremlini/fetloader-dll-repo")

isConfigValue(file,section,key,value)
{   
    IniRead, output_key, %file%, %section%, %key%
    if (output_key = "ERROR")
    {   
        Logging(2,"Not found " key " in config. Updating config file")
        IniWrite, %value%, %file%, %section%, %key%
    }
}

IniRead, language, %A_AppData%\FET Loader\config.ini, settings, language

setLang()
{
    if (A_Language = "0809" or A_Language = "0409") ; en_UK and en_US
        IniWrite, en, %A_AppData%\FET Loader\config.ini, settings, language
    if (A_Language = "0419") ; ru_RU
	    IniWrite, ru, %A_AppData%\FET Loader\config.ini, settings, language
    if (A_Language = "0422") ; ukr
        IniWrite, ukr, %A_AppData%\FET Loader\config.ini, settings, language
}

if (language = "ERROR")
{
    setLang()
}


IniRead, language, %A_AppData%\FET Loader\config.ini, settings, language
if (language = "en") 
{
    global string_load := "Load"
    global string_bypass := "Activate VAC bypass"
    global string_config := "Config"
    global string_about := "About"
    global string_pid0 := "No csgo.exe process found.`nDo you want to run the game?"
    global string_nosteam := "Install Steam, you retard."
    global string_success := "Cheat injected successfully!`nYou can close the loader now."
    global string_warning_custom_dll := "We're not gonna help you if your fucking system is gonna blow the fucking wine off it's not our fault. `nGot it?"
    global string_no_dll := "You didn't choose the DLL, so we've got nothing to inject."
    global string_new_version := "A new version is available."
    global string_want_download := "Want to download the update?"
    global string_changelog := "Changelog:"
    global string_unofficial_build := "You are using an unofficial loader build.`nWe decline any responsibility in case of infection of your system with any of the viruses."
    global string_outdated_os := "You are using an unsupported OS version. There will never be support for Windows 7. Please upgrade to Windows 10"
    global string_disclaimer := "If you've downloaded the loader from third-party sources, we decline all responsibility in case of infection of your system.`nMake sure that you downloaded the loader from trusted sources, such as: `nGitHub, official website fetloader.xyz or Telegram channel @ayeloader."
    global string_error := "An error occurred while executing the program. Details can be found in the log file."
    global string_20h2_warning := "On Windows version 2009/20H2, problems with the injection may occur. `nTo fix them, you need to (re-)install Microsoft Visual C++ Redistributable. `n`nWant to start downloading?"
    global string_cant_init_ntdll := "Important VC++ packages weren't found on your computer.`n`nDo you want to download them now?"
    global string_high_dpi := "You have a display scale other than 100%. The menu won't be displayed correctly."
}
if (language = "ru") 
{
    global string_load := "Заинжектить"
    global string_bypass := "Включить обход VAC"
    global string_config := "Настройки"
    global string_about := "Инфо"
    global string_pid0 := "Процесс csgo.exe не найден.`nЖелаете запустить игру?"
    global string_nosteam := "Установи Steam, клоун."
    global string_success := "Инжект прошел успешно!`nМожете закрыть лоадер, (если) он вам больше не нужен."
    global string_warning_custom_dll := "Мы ничем тебе не поможем, если твоя винда помрёт и/или ты подхватишь ратник+вымогателя.`nПонял?"
    global string_no_dll := "Ты не выбрал DLL, так что нам нечего инжектить."
    global string_new_version := "Доступна новая версия."
    global string_want_download := "Хотите загрузить обновление?"
    global string_changelog := "Список изменений:"
    global string_unofficial_build := "Вы используете неофициальную сборку лоадера.`nМы полностью снимаем с себя ответственность в случае заражения вашей системы."
    global string_outdated_os := "Вы используете неподдерживаемую версию ОС. Поддержки Windows 7 никогда не будет. Пожалуйста, обновитесь до Windows 10"
    global string_disclaimer := "Если вы загрузили лоадер из непроверенных источников, мы полностью снимаем с себя ответственность в случае заражения вашей системы.`nУбедитесь, что загрузили лоадер с проверенных источников, таких как: `nGitHub, официальный сайт fetloader.xyz, Telegram-канал @ayeloader."
    global string_error := "При выполнении программы произошла ошибка. Подробности можно найти в логфайле."
    global string_20h2_warning := "На версии Windows 2009/20H2 могут возникать проблемы с инжектом.`nДля того, чтобы исправить их, нужно (пере-)установить Microsoft Visual C++ Redistributable.`n`nХотите начать скачивание?"
    global string_cant_init_ntdll := "На вашем компьютере не были найдены пакеты VC++, необходимые для работы лоадера`n`nХотите загрузить сейчас?"
    global string_high_dpi := "На вашем ПК установлен масштаб дисплея, отличный от 100%. Меню может и будет отображаться неправильно."

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
    global string_new_version := "Доступна нова версія."
    global string_want_download := "Хочете завантажити оновлення?"
    global string_changelog := "Список змін:"
    global string_unofficial_build := "Ви використовуєте неофіційну збірку лоадера. `nМи повністю знімаємо з себе відповідальність в разі зараження вашої системи будь-яким з вірусів."
    global string_outdated_os := "Ви використовуєте не підтримувану версію ОС. Підтримки Windows 7 ніколи не буде. Будь ласка оновіться до Windows 10"
    global string_disclaimer := "Якщо ви завантажили лоадер з неперевірених джерел - ми повністю знімаємо з себе відповідальність в разі зараження вашої системи будь-яким з вірусів.`nПереконайтеся що завантажили лоадер з перевірених джерел, таких як:`nGitHub, офіційний сайт fetloader.xyz, телеграм канал t.me/ayeloader"
    global string_error := "При виконанні програми сталася помилка. Подробиці можна знайти в логфайлів."
    global string_20h2_warning := "На версії Windows 2009/20H2 можуть виникати проблеми з інжектом.`nДля того щоб виправити їх, потрібно (пере-)встановити Microsoft Visual C++ Redistributable.`n`nХочете почати скачування?"
    global string_cant_init_ntdll := "На вашому комп'ютері не були знайдені пакети VC++ необхідні для роботи лоадера`n`nХотіте почати скачування?"
    global string_high_dpi := "Ваш комп'ютер налаштований на занадто велике значення масштабу. Меню може відображатися неправильно."
}
