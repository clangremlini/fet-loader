;=================================================================================
;	InjectDll - An AutoHotkey library for injecting dll files into a process
;	Copyright (C) 2016 Brian Baker https://github.com/Fooly-Cooly
;   Copyright (C) 2021 a1987zz https://github.com/a1987zz
;   Copyright (C) 2021 clownless https://github.com/clownless
;	Requires AutoHotKey ANSI
;=================================================================================

#Include Logging.ahk
#include lang_strings.ahk


Inject_CleanUp(pMsg, pHandle, pLibrary)
{
	If pMsg
		MsgBox, 0, :(, % "Error Code: " . DllCall("GetLastError") . "`n" . pMsg

	If pLibrary
		DllCall("VirtualFreeEx", "UInt", pHandle, "UInt", pLibrary, "UInt", 0, "UInt", 0x8000)

	If pHandle
		DllCall("CloseHandle", "UInt", pHandle)

	Return False
}




Inject_Dll(pID, dllPath, method)
{
	if (method = 2) ; ManualMap
	{
		hModule := DllCall("LoadLibrary", "Str", A_AppData "\FET Loader\gh_injector.dll")
		funcA := DllCall("GetProcAddress","Ptr", hModule, "Astr","InjectA")
		;msgbox % funcA

		VarSetCapacity(ParamStruct, 540, 0)
		DllCall("ZeroMemory", Ptr, &ParamStruct, "UInt", 540)

		NumPut(2, ParamStruct, 528, "Uint")
		NumPut(0, ParamStruct, 532, "Uint")
		NumPut(pID, ParamStruct, 524, "Uint")

		StrPut(dllPath, &ParamStruct + 4, "CP0")

		DllCall(funcA, "Ptr", &ParamStruct)
		MsgBox, 0, %script%, %string_success%
		return
	}
	if (method = 1) ; LoadLibrary
	{
		PROCESS_ALL_ACCESS := 0x1FFFFF,
		MEM_COMMIT := 0x1000,
		MEM_RESERVE := 0x2000,
		MEM_PHYSICAL := 0x004,
		WAIT_FAILED := 0xFFFFFFFF

		Size := VarSetCapacity(dllFile, StrLen(dllPath)+1, NULL)
		StrPut(dllPath, &dllFile)
		
		If (!pHandle := DllCall("OpenProcess", "UInt", PROCESS_ALL_ACCESS, "Char", False, "UInt", pID))
			Return Inject_CleanUp("Couldn't open process!`nPossible Invalid PID.", NULL, NULL)

		If (!pLibrary := DllCall("VirtualAllocEx", "Ptr", pHandle, "Ptr", NULL, "Ptr", Size, "Ptr", MEM_RESERVE | MEM_COMMIT, "Ptr", MEM_PHYSICAL))
			Return Inject_CleanUp("Couldn't allocate memory!", pHandle, NULL)

		If (!DllCall("WriteProcessMemory", "Ptr", pHandle, "Ptr", pLibrary, "Ptr", &dllFile, "Ptr", Size, "Ptr", NULL))
			Return Inject_CleanUp("Couldn't write to memory in process!`nPossible permission Issue, Try Run as Admin.", pHandle, pLibrary)

		If (!pModule := DllCall("GetModuleHandle", "Str", "kernel32.dll"))
			Return Inject_CleanUp("Couldn't find kernel32.dll handle!", pHandle, pLibrary)

		If (!pFunc := DllCall("GetProcAddress", "Ptr", pModule, "AStr", A_PtrSize = 4 ? "LoadLibraryA" : "LoadLibraryW"))
			Return Inject_CleanUp("Couldn't find function 'LoadLibrary' in kernel32.dll!", pHandle, pLibrary)

		If (!hThread := DllCall("CreateRemoteThread", "Ptr", pHandle, "UIntP", NULL, "UInt", NULL, "Ptr", pFunc, "Ptr", pLibrary, "UInt", NULL, "UIntP", NULL))
			Return Inject_CleanUp("Couldn't create thread in PID: " pID, pHandle, pLibrary)

		DllCall("WaitForSingleObject", "Ptr", hThread, "UInt", WAIT_FAILED)
		
		If !DllCall("GetExitCodeThread", "Ptr", hThread, "UIntP", lpExitCode)
			Return Inject_CleanUp("Couldn't create thread in PID: " pID, pHandle, pLibrary)

		DllCall("CloseHandle", "UInt", hThread)
		MsgBox, 0, %script%, %string_success%
		Return
	}
}
