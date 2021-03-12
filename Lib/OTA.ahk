#include Lib\JSON.ahk
#include Lib\Logging.ahk
#include Lib\lang_strings.ahk

class OTA
{
    checkupd()
    {
        UrlDownloadToFile, https://gitlab.com/api/v4/projects/25081260/repository/files/version.json/raw?ref=master, %A_AppData%\FET Loader\json.tmp
        FileRead, jsonStr, %A_AppData%\FET Loader\json.tmp
        VarSetCapacity(ansi, StrPut(jsonStr, "CP1251")), StrPut(jsonStr, &ansi, "CP1251")
        jsonStr := StrGet(&ansi, "UTF-8")
        parsed := JSON.Load(jsonStr)
        latest_release := parsed.version
        change_log := parsed.changelog
        download_url := parsed.downloadurl
        if (version != latest_release)
        {
            Logging(1,"A new version is available. Latest version: " latest_release)
            MsgBox, 68, %script% | %string_new_version%, %latest_release% | %string_changelog%`n`n%change_log%`n`n`n%string_want_download%
            IfMsgBox, Yes
                OTA.download(download_url,latest_release)
        }
    }
    download(download_url,tag)
    {
        UrlDownloadToFile, %download_url%, %A_ScriptDir%\loader-%tag%.exe
        Run, %A_ScriptDir%\loader-%tag%.exe
        ExitApp
    }
}