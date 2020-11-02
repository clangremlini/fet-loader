; Description: Upload logfile to Pastebin!
#include Lib\Multipart.ahk
#include Lib\WinHTTPRequest.ahk

class Pastebin 
{
    UploadLog()
    {
        if (pastebin_key == "")
        {
            MsgBox, 0, FET Loader Logs Uploader, Fill pastebin_key variable for uploading logs.
            return
        }
        IfNotExist, logs.log
        {
            MsgBox, 0, FET Loader Logs Uploader, No logs found for upload!
            return
        }
        Multipart.Make(PostData, PostHeader
            , "api_option=paste"
            , "api_dev_key="+pastebin_key
            , "api_paste_private=0"
            , "api_paste_name=FET Loader Logs"
            , "api_paste_expire_date=N"
            , "api_paste_code=<logs.log")
        WinHttpRequest("https://pastebin.com/api/api_post.php", PostData, PostHeader, "+NO_AUTO_REDIRECT+SaveAs:logs_upload.tmp")
        FileRead, logurl, logs_upload.tmp
        FileDelete, logs_upload.log
        if (InStr(logurl, "Bad API request"))
        {
            MsgBox, 0, FET Loader Logs Uploader, %logurl%
            return
        }
        MsgBox, 0, FET Loader Logs Uploader, Logs uploaded successfully!  
        Run, %logurl%
        Return
    }
}