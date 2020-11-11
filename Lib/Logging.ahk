Logging(status,text)
{
	if (status = 1)
	{
		FileAppend, [LOG]%A_DD%.%A_MM%.%A_YYYY% - %A_Hour%:%A_Min%:%A_Sec% - %text%`n, C:\FET Loader\logs.log
	}
	if (status = 2)
	{
		FileAppend, [ERR]%A_DD%.%A_MM%.%A_YYYY% - %A_Hour%:%A_Min%:%A_Sec% - %text%`n, C:\FET Loader\logs.log
	}
}


OnError("LogError")

LogError(exception)
{
	Logging(2, "Error on line " exception.Line ": " exception.Message)
	MsgBox, 16, %Script%, %string_error%
    ExitApp
}