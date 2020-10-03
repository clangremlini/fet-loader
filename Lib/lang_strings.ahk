#Include Lib\Logging.ahk

IfNotExist, C:\AYE
{	
	Logging(1, "Creating folder...")
	FileCreateDir, C:\AYE
}
IfNotExist, C:\AYE\Web
{	
	FileCreateDir, C:\AYE\Web
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
checkConfigValue("C:\AYE\config.ini","settings","checkupdates","true")

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
    global string_pid0 := "No csgo.exe process found. Run it?"
    global string_nosteam := "Install steam, retard."
    global string_success := "Successful injection!"
    global string_warning_custom_dll := "We're not gonna help you if your fucking system is gonna blow the fucking wine off it's not our fault. `nGot it?"
    global string_no_dll := "You didn't choose the DLL."
    global string_new_version := "A new version is available."
    global string_want_download := "Want to download the update?"
    global string_changelog := "Changelog:"

}
if (language = "ru") 
{
    global string_pid0 := "������� csgo.exe �� ������. ���������?"
    global string_nosteam := "�������� Steam, �����."
    global string_success := "������ ������ �������"
    global string_warning_custom_dll := "�� �� ����� ���� �������� ���� � ���� ����� ������� ������� ����� ����� ������ ��� �� ���� ����.`n�����?"
    global string_no_dll := "�� �� ������ DLL."
    global string_new_version := "�������� ����� ������."
    global string_want_download := "������ ��������� ����������?"
    global string_changelog := "������ ���������"
}
if (language = "eblo") 
{
    global string_pid0 := "��������� ���� ���� ������� ����"
    global string_nosteam := "�������� Steam, �����."
    global string_success := "���� ���� ������� �������"
    global string_warning_custom_dll := "�� �� ����� ���� �������� ���� � ���� ����� ������� ������� ����� ����� ������ ��� �� ���� ����.`n�����?"
    global string_no_dll := "��� ����� ��� ������"
    global string_new_version := "A new version is available."
    global string_want_download := "Want to download the update?"
    global string_changelog := "Changelog:"
}
if (language = "hvh") 
{
    global string_pid0 := "��� ����� ���� ������� �� ������"
    global string_nosteam := "������������� ������ 0 ��� �����"
    global string_success := "������� ������ � ������ ���"
    global string_warning_custom_dll := "���� � ���� ����� ����� ��� ��������� ����� ������ ��� �� ��� ������� ����� ���"
    global string_no_dll := "���, ������ ���."
    global string_new_version := "�������� ����� ������."
    global string_want_download := "������ ��������� ����������?"
    global string_changelog := "������ ���������"
}
if (language = "ukr") 
{
    global string_pid0 := "������ csgo.exe �� ��������. ���������?"
    global string_nosteam := "�������� Steam, �������."
    global string_success := "������ ������� ������"
    global string_warning_custom_dll := "�� �� ������ ��� ���������� ���� � ���� ����� ������� �������� ���� ����� ������� �� �� ���� ����.'n�������?"
    global string_no_dll := "�� �� ������ DLL."
    global string_new_version := "�������� ���� �����."
    global string_want_download := "������ ����������� ���������?"
    global string_changelog := "������ ���:"
}