//objectcomments Generated Application Object
forward
global type tst_tpl from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
u_exf_error_manager gu_e

end variables

global type tst_tpl from application
string appname = "tst_tpl"
integer highdpimode = 0
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 22.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = ""
string appruntimeversion = "25.0.0.3711"
boolean manualsession = false
boolean unsupportedapierror = false
boolean ultrafast = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
long webview2distribution = 0
boolean webview2checkx86 = false
boolean webview2checkx64 = false
string webview2url = "https://developer.microsoft.com/en-us/microsoft-edge/webview2/"
end type
global tst_tpl tst_tpl

on tst_tpl.create
appname="tst_tpl"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on tst_tpl.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;gu_e = create u_exf_error_manager

// Make sure the working directory contains the dll so it can be loaded
changedirectory('..')

// Put your test code here

u_pbni_example lu_example
lu_example = create u_pbni_example
try
	messagebox("of_add", "1 + 2 = " + string(lu_example.of_add(1, 2)))
catch (u_exf_ex lu_e)
	gu_e.of_display(lu_e)
end try
end event

