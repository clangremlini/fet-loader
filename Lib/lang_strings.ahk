; compile with utf-8

#Include Lib\Logging.ahk

IfNotExist, C:\FET Loader
{	
	Logging(1, "Creating folder...")
	FileCreateDir, C:\FET Loader
}
IfNotExist, C:\FET Loader\Web
{	
	FileCreateDir, C:\FET Loader\Web
}
IfNotExist, C:\FET Loader\config.ini
{	
	Logging(1, "Creating config file...")
	IniWrite, false, C:\FET Loader\config.ini, settings, custominject
	IniWrite, true, C:\FET Loader\config.ini, settings, checkupdates
	IniWrite, clangremlini/fetloader-dll-repo, C:\FET Loader\config.ini, settings, cheatrepo
    IniWrite, false, C:\FET Loader\config.ini, settings, oldgui
	Logging(1, "done.")
}


checkConfigValue("C:\FET Loader\config.ini","settings","oldgui","false")
checkConfigValue("C:\FET Loader\config.ini","settings","checkupdates","true")
checkConfigValue("C:\FET Loader\config.ini","settings","cheatrepo","clangremlini/fetloader-dll-repo")

checkConfigValue(file,section,key,value)
{   
    IniRead, output_key, %file%, %section%, %key%
    if (output_key = "ERROR")
    {   
        Logging(2,"Not found " key " in config. Updating config file")
        IniWrite, %value%, %file%, %section%, %key%
    }
}

IniRead, language, C:\FET Loader\config.ini, settings, language

setLang()
{
    if (A_Language = "0809" or A_Language = "0409") ; en_UK and en_US
        IniWrite, en, C:\FET Loader\config.ini, settings, language
    if (A_Language = "0419") ; ru_RU
	    IniWrite, ru, C:\FET Loader\config.ini, settings, language
    if (A_Language = "0422") ; ukr
        IniWrite, ukr, C:\FET Loader\config.ini, settings, language
}

if (language = "ERROR")
{
    setLang()
}


IniRead, language, C:\FET Loader\config.ini, settings, language
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
    global string_new_version := "A new version is available."
    global string_want_download := "Want to download the update?"
    global string_changelog := "Changelog:"
    global string_unofficial_build := "You are using an unofficial loader build.`nWe completely disclaim responsibility in case of infection of your system with any of the viruses."
    global string_outdated_os := "You are using an unsupported OS version. There will never be support for Windows 7. Please upgrade to Windows 10"
    global string_disclaimer := "If you downloaded the loader from unverified sources, we completely disclaim responsibility in case of infection of your system with any of the viruses.`nMake sure that you downloaded the loader from trusted sources, such as:`nGitHub, official fetloader.xyz website, telegram channel t.me/ayeloader."
    global string_error := "An error occurred while executing the program. Details can be found in the log file."

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
    global string_new_version := "Доступна новая версия."
    global string_want_download := "Хотите загрузить обновление?"
    global string_changelog := "Список изменений:"
    global string_unofficial_build := "Вы используете неофициальную сборку лоадера.`nМы полностью снимаем с себя ответственность в случае заражения вашей системы каким либо из вирусов."
    global string_outdated_os := "Вы используете не поддерживаемую версию ОС. Поддержки Windows 7 никогда не будет. Пожалуйста обновитесь до Windows 10"
    global string_disclaimer := "Если вы загрузили лоадер из непроверенных источников - мы полностью снимаем с себя ответственность в случае заражения вашей системы каким либо из вирусов.`nУбедитесь что загрузили лоадер с проверенных источников, таких как:`nGitHub, официальный сайт fetloader.xyz, телеграм канал t.me/ayeloader."
    global string_error := "При выполнении программы произошла ошибка. Подробности можно найти в логфайле."
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
}
