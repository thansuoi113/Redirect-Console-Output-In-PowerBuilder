$PBExportHeader$nvo_console_arg.sru
forward
global type nvo_console_arg from nonvisualobject
end type
end forward

global type nvo_console_arg from nonvisualobject
end type
global nvo_console_arg nvo_console_arg

type variables
window iw
String is_cmd
nvo_console invo_console
Boolean ib_run
end variables
forward prototypes
public function integer of_run (string as_cmd)
public subroutine of_refresh (string as_msg)
end prototypes

public function integer of_run (string as_cmd);//====================================================================
// Function: nvo_console_arg.of_run()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	value	string	as_cmd	
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


If ib_run then return 0

If Not IsValid(invo_console) Then
	invo_console = Create nvo_console
End If

is_cmd = as_cmd
invo_console.of_ini(This)
invo_console.Post Function of_run()

Return 1

end function

public subroutine of_refresh (string as_msg);If IsValid(iw) Then
	iw.Dynamic Function of_refresh(as_msg)
End If

end subroutine

on nvo_console_arg.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_console_arg.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ErrorReturn lErrorReturn
lErrorReturn = SharedObjectRegister("nvo_console", "invo_console")
lErrorReturn = SharedObjectGet("invo_console", invo_console)

end event

event destructor;ErrorReturn lErrorReturn
lErrorReturn = SharedObjectUnRegister("invo_console")
destroy invo_console
end event

