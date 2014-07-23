/*
	------------------------------------------------------------------------------------------------------------
	REVISION BLOCK
		
	Project Name: BetterSnipTool
	
	Revision History:
	
	Date		Rev			Change Description
	------------------------------------------------------------------------------------------------------------
	04/16/2014	1.0.0		Beta release

	------------------------------------------------------------------------------------------------------------

	Project Overview:
	
		This project enables user to perform screen captures using Snipping Tool in Windows 7, 32bit or 64bit*
	
	Project Features:
	
		DEPLOYABLE:
			
			No INI file is required to deploy this script - if no configuration file is 
			found within the script directory, it will create one with default values.
			
		CONFIGURABLE:

			The INI can be easily opened and modified from the main screen.
			
	Project Notes:

		Requires PC Running Windows 7, with Snipping Tool.
					
	------------------------------------------------------------------------------------------------------------
*/

	; win 7 security bypass - required for controlsends to SnippingTool >.<
	if not A_IsAdmin
	{
		Run *RunAs "%A_ScriptFullPath%"
		ExitApp
	}
	
	#NoEnv
	#SingleInstance force
	SetWorkingDir %A_ScriptDir%
	SetTitleMatchMode 2

	; set globals
			
		global ScriptName 		:= 			"BetterSnipTool" 		
		global ScriptDesc 		:= 			"Screen Capture tool using Win7 and Snipping Tool"
		global ScriptVersion 	:= 			"1.0.0"
		global ScriptConfig 	:= 			"script config.ini"
	
	; get & set script specific variables
	
	GoSub SubStartScript

; ------------------------------------------------------------------------------------------------------------
; 			SubStartScript:										
; ------------------------------------------------------------------------------------------------------------
SubStartScript:	
	
Try
{
	
	; if the script cannot find the configuration file, it will create one with default values
	IfNotExist %ScriptConfig%
	{
		
		IniWrite 	1,							%ScriptConfig%, 	gui, 			Ini_Gui_AlwaysOnTop
		IniWrite 	20, 						%ScriptConfig%, 	gui, 			Ini_Gui_Pos_X
		IniWrite 	20, 						%ScriptConfig%, 	gui, 			Ini_Gui_Pos_Y
		IniWrite	name,						%ScriptConfig%,		image,			Ini_Image_Name
		IniWrite	.PNG,						%ScriptConfig%,		image,			Ini_Image_Type
		IniWrite	%A_Desktop%, 				%ScriptConfig%,		image,			Ini_Image_Path
		IniWrite	250,						%ScriptConfig%,		delay,			Ini_Delay_Key
		IniWrite	150,						%ScriptConfig%,		delay,			Ini_Delay_Win
		IniWrite	250,						%ScriptConfig%,		delay,			Ini_Delay_Control
		IniWrite	500,						%ScriptConfig%,		delay,			Ini_Delay_Sleep
		IniWrite	10,							%ScriptConfig%,		delay,			Ini_Delay_Load
				
	}

		; read in the variables from the config file
		IniRead		Ini_Gui_AlwaysOnTop,		%ScriptConfig%,		gui,			Ini_Gui_AlwaysOnTop
		IniRead 	Ini_Gui_Pos_X, 				%ScriptConfig%, 	gui, 			Ini_Gui_Pos_X
		IniRead 	Ini_Gui_Pos_Y, 				%ScriptConfig%, 	gui, 			Ini_Gui_Pos_Y		
		IniRead		Ini_Image_Name,				%ScriptConfig%,		image,			Ini_Image_Name
		IniRead		Ini_Image_Type,				%ScriptConfig%,		image,			Ini_Image_Type
		IniRead		Ini_Image_Path, 			%ScriptConfig%,		image,			Ini_Image_Path
		IniRead		Ini_Delay_Key,				%ScriptConfig%,		delay,			Ini_Delay_Key
		IniRead		Ini_Delay_Win,				%ScriptConfig%,		delay,			Ini_Delay_Win
		IniRead		Ini_Delay_Control,			%ScriptConfig%,		delay,			Ini_Delay_Control
		IniRead		Ini_Delay_Sleep,			%ScriptConfig%,		delay,			Ini_Delay_Sleep
		IniRead		Ini_Delay_Load,				%ScriptConfig%,		delay,			Ini_Delay_Load
		
		; may turn these into INI variables for future state
		App1_Name 				:=			SnippingTool.exe
		App1_Window1 			:=			Snipping Tool
		App1_Window2 			:=			Save As		
		App1_Window3			:=			Confirm Save As	
		App1_Button1			:=			&Yes
		App1_Button2			:=			&Save
		App1_Button3			:=			&No
		; App1_Path 			:= 			"C:\Windows\System32\"	
		App1_Path				:=			"C:\Windows\SysNative\"
		App1					:= 			App1_Path . App1_Name
		
		SetKeyDelay 			%Ini_Delay_Key%
		SetWinDelay 			%Ini_Delay_Win%
		SetControlDelay 		%Ini_Delay_Control%
			
	GoSub SubStartGui
	
}
Catch e
{
	ScriptError("Error Description: " 
	. e.what 
	. "`nError on Script Line: " 
	. e.line 
	. "`nError Message: " 
	. e.message 
	. "`nAdditional Info: " 
	. e.extra)
	Return
}
	
Return

; --------------------------------------------------------------------------------------------------------------
; 			SubStartGui
; --------------------------------------------------------------------------------------------------------------
SubStartGui:	
Try
{
		Gui, 1:		Destroy
		Gui, 1:		Margin, 	10, 10
	
		Gui, 1:		Add, 		Tab, 			Section w300 h390 vTab2 -Wrap, Capture|Options|Info 
	
		Gui, 1: 	Tab,		Capture
	
		Gui, 1:		Add,		Button,			xm+50 ym+10 h50 w200 gSubScreenCapture, Capture	
		Gui, 1:		Add,		Text, 			xm+0 ym+185 w300 h1 0x10
		Gui, 1:		Add,		Text,			xm+0 ym+190, Snipping Tool Mode`:
		Gui, 1:		Add,		Radio,			xm+10 ym+210 vGui_CaptureFreeForm, Capture Free Form
		Gui, 1:		Add,		Radio,			xm+10 ym+230 vGui_CaptureRegion checked, Capture Region
		Gui, 1:		Add,		Radio,			xm+10 ym+250 vGui_CaptureWindow, Capture Window
		Gui, 1:		Add,		Radio,			xm+10 ym+270 vGui_CaptureFullScreen, Capture Full Screen
		
		
		Gui, 1: 	Tab,		Options
		
		Gui, 1:		Add, 		Text, 			xm+0 ym+70 w300 h1 0x10	
		Gui, 1:		Add,		Text,			xm+0 ym+75, Output Settings`:
		Gui, 1: 	Add, 		Text, 			xm+0 ym+95, Name`:
		Gui, 1:		Add,		Edit,			xm+75 ym+95 w200 vGui_ImageName, %Ini_Image_Name%`#`#
		Gui, 1:		Add,		Text,			xm+0 ym+125, Type`:
		Gui, 1:		Add,		DropDownList,	xm+75 ym+125 vGui_ImageType, %Ini_Image_Type%
		Gui, 1:		Add,		Text,			xm+0 ym+155, Location`:
		Gui, 1:		Add,		Edit,			xm+75 ym+155 w200 vGui_ImagePath, %Ini_Image_Path%
		
		Gui, 1:		Tab,		Info
		
		Gui, 1:		Add, 		Text, 			xm+0 ym+300 w300 h1 0x10
		Gui, 1: 	Add, 		Button, 		xm+0 ym+305 w75 gSubButtonSettings, Settings
		Gui, 1: 	Add, 		Button, 		xm+80 ym+305 w75 gSubAppExit, Exit
		Gui, 1: 	Add, 		Text, 			xm+160 ym+310, Version %ScriptVersion%
	
	if (Ini_Gui_AlwaysOnTop = 1)
	{
		Gui, 1: 	+AlwaysOnTop			
	}
	else
	{
		Gui, 1: 	-AlwaysOnTop			
	}
		Gui, 1: 	Show, 	x%Ini_Gui_Pos_X% y%Ini_Gui_Pos_Y%, %ScriptName%	

}
Catch e
{
	ScriptError("Error Description: " 
	. e.what 
	. "`nError on Script Line: " 
	. e.line 
	. "`nError Message: " 
	. e.message 
	. "`nAdditional Info: " 
	. e.extra)
	Return
}
		
Return


; --------------------------------------------------------------------------------------------------------------
; 			SubScreenCapture								
; --------------------------------------------------------------------------------------------------------------
SubScreenCapture:

	; hide the gui
	Gui, 1: 		Submit
	; grab the values off the gui
	GuiControlGet, 	Gui_ImageName
	GuiControlGet, 	Gui_ImageType	
	GuiControlGet, 	Gui_ImagePath
	GuiControlGet, 	Gui_CaptureFreeForm
	GuiControlGet,	Gui_CaptureRegion
	GuiControlGet,	Gui_CaptureWindow
	GuiControlGet,	Gui_CaptureFullScreen
	
Try
{

		
	; clear clipboard
	ClipBoard=

	
	; if snipping tool is loaded (user manually loaded)
	; if App1 is open...close it
	; fix this to work TODO...
	IfWinExist %App1_Window1%
	{
		WinClose, %App1_Window1%
		WinWaitClose, %App1_Window1%
		GoSub SubStartGui
		Return
	}
	; snipping tool is not loaded
	IfWinNotExist %App1_Window1%
	{
		Run, "SnippingTool.exe"		
		WinActivate, %App1_Window1%
		WinWaitActive, %App1_Window1%
		
		
		; alt + n = new snip
		ControlSend,, {!}{n}, %App1_Window1%
		
		; based upon GUI selection, send hotkey to snipping tool
		
		If (Gui_CaptureFreeForm) {
			; f = free form
			ControlSend,, {f},%App1_Window1%
			; **** ADD some sort of delay
			Sleep %Ini_Delay_Sleep%*3
			GoSub SubSaveFile
		} Else If (Gui_CaptureRegion) {
			; r = rectangle
			ControlSend,, {r},%App1_Window1%
			Sleep %Ini_Delay_Sleep%*3
			GoSub SubSaveFile
		} Else If (Gui_CaptureWindow) {
			; w = window
			ControlSend,, {w},%App1_Window1%
			Sleep %Ini_Delay_Sleep%*3
			GoSub SubSaveFile
		} Else If (Gui_CaptureFullScreen) {
			; s = full screen
			ControlSend,, {s},%App1_Window1%
			Sleep %Ini_Delay_Sleep%*3
			GoSub SubSaveFile
		} Else {
			MsgBox No Snipping Mode selected...
			Return
		}
	}
}
Catch e
{
	ScriptError("Error Description: " 
	. e.what 
	. "`nError on Script Line: " 
	. e.line 
	. "`nError Message: " 
	. e.message 
	. "`nAdditional Info: " 
	. e.extra)
}

Return
; --------------------------------------------------------------------------------------------------------------
; 			SubSaveFile							
; --------------------------------------------------------------------------------------------------------------
SubSaveFile:
Try
{
	WinActivate, %App1_Window1%
	WinWaitActive, %App1_Window1%
	WinMenuSelectItem, %App1_Window1%,, File, Save As...
	
	Ini_Image_Name := Serial_Number . " " . Image_Extension
	Image_Output := Ini_Image_Path . Ini_Image_Name
	
	
	; if file already exists in directory...
	IfExist %Image_Output%
	{
		MsgBox, 262180, Replace File`?, 
		(
		%Ini_Image_Name% already exists
		`nin directory "%Ini_Image_Path%".
		`n`nDo you wish to replace this file with the new one?
		)
		IfMsgBox No
		{
			MsgBox, 262208, No file saved`!, No image file was saved.
			GoSub SubStartGui
		}
		IfMsgBox Yes
		{
			
			WinWaitActive, %App1_Window2%
			ControlSetText, Edit1, %Ini_Image_Path%, %App1_Window2%
			ControlSend %App1_Button2%, {Space}, %App1_Window2%
			
			Sleep %Ini_Delay_Sleep%
			
			ControlSetText, Edit1, %Ini_Image_Name%, %App1_Window2%
			ControlSend %App1_Button2%, {Space}, %App1_Window2%
			
			Sleep %Ini_Delay_Sleep%
			
			; improves reliability if user moves mouse around
			SetControlDelay -1
			; use controlclick as No (Button2) is default and Button1 is not selected
			ControlClick, %App1_Button1%, %App1_Window3%,,,, NA
			WinWaitClose, %App1_Window2%
			
			GoSub SubStartGui
		}
	}
	
	; if new file...
	IfNotExist %Image_Output%
	{
		WinWaitActive, %App1_Window2%
		ControlSetText, Edit1, %Ini_Image_Path%, %App1_Window2%
		ControlSend %App1_Button2%, {Space}, %App1_Window2%
		
		Sleep %Ini_Delay_Sleep%
		
		ControlSetText, Edit1, %Ini_Image_Name%, %App1_Window2%
		ControlSend %App1_Button2%, {Space}, %App1_Window2%
		WinWaitClose, %App1_Window2%
		
		GoSub SubStartGui
	}
}
Catch e
{
	ScriptError("Error Description: " 
	. e.what 
	. "`nError on Script Line: " 
	. e.line 
	. "`nError Message: " 
	. e.message 
	. "`nAdditional Info: " 
	. e.extra)
}

Return

; --------------------------------------------------------------------------------------------------------------
; 			ScriptError							
; --------------------------------------------------------------------------------------------------------------
;Error handler message
ScriptError(description)
{
	Gui, 1: Submit, Nohide
		
	MsgBox 4112, Script Error!, 
	(
	Script halted during during operation. 
	`nIf this problem persists, notify admin.
	`n`nDescription:
	`n%description%
	)
	; Gui, 1:		Destroy
	
	GoSub SubAppExit
	Exit
	
}

; --------------------------------------------------------------------------------------------------------------
; 			SubButtonSettings
; --------------------------------------------------------------------------------------------------------------
SubButtonSettings:

	; open INI in notepad
	Run, Notepad.exe %ScriptConfig%, , , notePadPID
	WinWait, ahk_pid %notepadPID% WinActivate 
	WinWaitClose
	
	GoSub SubStartScript
	
Return
; --------------------------------------------------------------------------------------------------------------
; 			SubAppExit							
; --------------------------------------------------------------------------------------------------------------
esc::
SubAppExit:
GuiClose:
GuiEscape:

Try
{
		
		; free allocations of memory
		tmpInputVariable = Ini_Image_Name = Serial_Number =
		; capture GUI position and record it in INI
		WinGetPos, 	Ini_Gui_Pos_X, Ini_Gui_Pos_Y, , ,		%ScriptName%
		; do not allow GUI position to be negative (bug fix)
		if (Ini_Gui_Pos_X > 0) and (Ini_Gui_Pos_Y > 0)
		{
		IniWrite, 	%Ini_Gui_Pos_X%,					%ScriptConfig%, 	gui, 			Ini_Gui_Pos_X
		IniWrite, 	%Ini_Gui_Pos_Y%, 					%ScriptConfig%, 	gui, 			Ini_Gui_Pos_Y
		}
		ExitApp
		Return
}
Catch e
{
		ExitApp
		Return
}
Finally
{
		ExitApp
		Return
}
