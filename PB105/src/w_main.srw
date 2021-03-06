$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type st_1 from statictext within w_main
end type
type cb_run from commandbutton within w_main
end type
type mle_log from multilineedit within w_main
end type
type sle_cmd from singlelineedit within w_main
end type
end forward

global type w_main from window
integer width = 2345
integer height = 1296
boolean titlebar = true
string title = "Redirect Console Output"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_run cb_run
mle_log mle_log
sle_cmd sle_cmd
end type
global w_main w_main

type variables
nvo_console_arg invo_arg
end variables

forward prototypes
public subroutine of_refresh (string as_msg)
end prototypes

public subroutine of_refresh (string as_msg);mle_log.Text +=  as_msg
mle_log.Scroll(mle_log.LineCount())

end subroutine

on w_main.create
this.st_1=create st_1
this.cb_run=create cb_run
this.mle_log=create mle_log
this.sle_cmd=create sle_cmd
this.Control[]={this.st_1,&
this.cb_run,&
this.mle_log,&
this.sle_cmd}
end on

on w_main.destroy
destroy(this.st_1)
destroy(this.cb_run)
destroy(this.mle_log)
destroy(this.sle_cmd)
end on

type st_1 from statictext within w_main
integer x = 46
integer y = 48
integer width = 210
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cmd:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_run from commandbutton within w_main
integer x = 1851
integer y = 40
integer width = 265
integer height = 104
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Run"
end type

event clicked;If Not IsValid(invo_arg) Then
	invo_arg = Create nvo_console_arg
End If

If invo_arg.ib_run Then Return

String ls_cmd

mle_log.text = ""
ls_cmd = sle_cmd.Text
If IsNull(ls_cmd) Or Len(Trim(ls_cmd)) = 0 Then
	Return
End If
invo_arg.iw = Parent
invo_arg.of_run(ls_cmd)

end event

type mle_log from multilineedit within w_main
integer x = 133
integer y = 172
integer width = 2030
integer height = 948
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_cmd from singlelineedit within w_main
integer x = 283
integer y = 44
integer width = 1550
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "ping localhost -n 10"
borderstyle borderstyle = stylelowered!
end type

