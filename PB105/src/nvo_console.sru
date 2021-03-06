$PBExportHeader$nvo_console.sru
forward
global type nvo_console from nonvisualobject
end type
type str_startup_info from structure within nvo_console
end type
type str_process_info from structure within nvo_console
end type
type str_security_attributes from structure within nvo_console
end type
end forward

type str_startup_info from structure
	long		cb
	long		lpreserved
	long		lpdesktop
	long		lptitle
	long		dwx
	long		dwy
	long		dwxsize
	long		dwysize
	long		dwxcountchars
	long		dwycountchars
	long		dwfillattribute
	long		dwflags
	long		wshowwindow
	long		cbreserved2
	long		lpreserved2
	long		hstdinput
	long		hstdoutput
	long		hstderror
end type

type str_process_info from structure
	long  hprocess 
	 long  hthread 
	 long  dwprocessid 
	 long  dwthreadid 
end type

type str_security_attributes from structure
	Long nLength
    Long lpSecurityDescriptor
    Long bInheritHandle
end type

global type nvo_console from nonvisualobject
end type
global nvo_console nvo_console

type prototypes

Function ULong CreatePipe(Ref ULong phReadPipe,Ref ULong phWritePipe,  Ref str_security_attributes lpPipeAttributes,ULong nSize) Library "kernel32.dll"
Function Long ReadFile( ULong hFile,  Ref Blob lpBuffer, Long nNumberOfBytesToRead,  Ref Long lpNumberOfBytesRead, ULong lpOverlapped) Library "kernel32.dll"
Function ULong GetLastError() Library "kernel32.dll"
Function Boolean CloseHandle(ULong h) Library 'kernel32.dll'
Function ULong PeekNamedPipe(ULong hNamedPipe,Ref Blob lpBuffer,ULong nBufferSize, Ref ULong lpBytesRead,Ref ULong lpTotalBytesAvail,Ref ULong lpBytesLeftThisMessage) Library "kernel32.dll"
Function Boolean CreateProcess ( String lpApplicationName, String lpCommandLine,  ULong lpProcessAttributes, ULong lpThreadAttributes, Boolean bInheritHandles, &
	ULong dwCreationFlags, ULong lpEnvironment, String lpCurrentDirectory,  str_startup_info lpStartupInfo, Ref str_process_info lpProcessInformation ) Library "kernel32.dll"  Alias For "CreateProcessA;Ansi"


end prototypes

type variables
Private str_process_info 		istr_proc_info
String		 			is_msg
UnsignedLong 		iul_process_handle = 0
nvo_console_arg invo_arg
end variables
forward prototypes
public function integer of_run ()
public subroutine of_ini (nvo_console_arg anvo_arg)
end prototypes

public function integer of_run ();//====================================================================
// Function: nvo_console.of_run()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2021/03/22
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Constant ULong STARTF_USESHOWWINDOW = 1
Constant ULong STARTF_USESTDHANDLES = 256
Constant ULong DUPLICATE_SAME_ACCESS = 2
Constant ULong BUFSIZE = 1024
Constant ULong PIPE_READMODE_BYTE = 0
Constant ULong PIPE_NOWAIT = 1

Long						ll_CreationFlags, ll_null, lBytesRead, lPipeOutLen
String						ls_null, ls_app_name, ls_cmd, ls_dir, ls_read_string
UnsignedLong 			lul_null, luOverLapped, lul_err
UnsignedLong 			hPipeRead,hPipeWrite
UnsignedLong 			lpBytesRead, lpTotalBytesAvail, lpBytesLeft, lpBufOutLen
Boolean 					lb_created
Blob						lbl_read
Int i
String ls_msg

str_startup_info 			lstr_startup_info
str_security_attributes	lstr_secure_attrib

ls_cmd = invo_arg.is_cmd
invo_arg.ib_run = True
If ls_cmd = "" Then
	invo_arg.ib_run = False
	Return 1
End If

If iul_process_handle > 0 Then
	invo_arg.of_refresh("Error create pipe failed")
	invo_arg.ib_run = False
	Return -1
End If

lbl_read = Blob(Space(BUFSIZE))
SetNull(ll_null)
SetNull(ls_null)
SetNull(lul_null)
luOverLapped = 0
ls_msg = ""
ll_CreationFlags = 0
lstr_secure_attrib.nLength = 12
lstr_secure_attrib.bInheritHandle = 1
lstr_secure_attrib.lpSecurityDescriptor = 0

lstr_startup_info.cb = 17 * 4
lstr_startup_info.dwFlags = STARTF_USESHOWWINDOW   + STARTF_USESTDHANDLES
lstr_startup_info.wShowWindow = 0

If CreatePipe(hPipeRead, hPipeWrite, lstr_secure_attrib, 0) = 0 Then
	invo_arg.of_refresh("Error create pipe failed")
	invo_arg.ib_run = False
	Return -1
End If

lstr_startup_info.hStdOutput  = hPipeWrite
lstr_startup_info.hStdError = hPipeWrite
lstr_startup_info.hStdInput = hPipeWrite

ls_app_name = ls_null
ls_dir = ls_null

lb_created =  CreateProcess(ls_app_name, ls_cmd, ll_null, ll_null, True, ll_CreationFlags, ll_null, ls_dir, lstr_startup_info, istr_proc_info)

If lb_created Then
	
	iul_process_handle = istr_proc_info.hprocess
	
	CloseHandle(hPipeWrite)
	CloseHandle(istr_proc_info.hThread)
	
	lBytesRead = ReadFile( hPipeRead, lbl_read, BUFSIZE,lPipeOutLen, 0)
	If lBytesRead = 0 Then
		lul_err = GetLastError()
		If lul_err = 109 Then
			invo_arg.of_refresh("error reading error 109 - broken pipe")
		Else
			invo_arg.of_refresh("Error Eeading " +  String(lul_err))
		End If
	End If
	
	Do While lBytesRead > 0 And lPipeOutLen > 0
		ls_msg = String(BlobMid(lbl_read,1, lPipeOutLen), encodingANSI!)
		is_msg +=  ls_msg
		invo_arg.of_refresh(ls_msg)
		lBytesRead = ReadFile( hPipeRead, lbl_read, BUFSIZE,lPipeOutLen, 0)
	Loop
	
End If

closeHandle(hPipeRead)
closeHandle(istr_proc_info.hprocess)
iul_process_handle = 0
invo_arg.ib_run = False
Return 1




end function

public subroutine of_ini (nvo_console_arg anvo_arg);invo_arg = anvo_arg
end subroutine

on nvo_console.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_console.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;if iul_process_handle > 0 then
	closeHandle(iul_process_handle)
end if
end event

