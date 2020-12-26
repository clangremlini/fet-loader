#Include Lib\LibCon.ahk

if (build_status != "release")
{
	SmartStartConsole()
	Logging(1,"opened debug console")
}

Logging(status,text)
{
	if (status = 1)
	{
		out = [LOG]%A_DD%.%A_MM%.%A_YYYY% - %A_Hour%:%A_Min%:%A_Sec% - %text%
		puts(out)
		FileAppend, %out%, %A_AppData%\FET Loader\logs.log
	}
	if (status = 2)
	{
		out = [ERR]%A_DD%.%A_MM%.%A_YYYY% - %A_Hour%:%A_Min%:%A_Sec% - %text%`n
		puts(out)
		FileAppend, %out%, %A_AppData%\FET Loader\logs.log
	}
}


OnError("LogError")

LogError(exception)
{
	Logging(2, "Error on line " exception.Line ": " exception.Message)
	MsgBox, 16, %Script%, %string_error%
    ExitApp
}