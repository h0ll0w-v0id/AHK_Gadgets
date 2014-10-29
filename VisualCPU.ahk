/*
	--------------------------------------------------------
	REVISION BLOCK
		
	Project Name: VisualCPU
	
	Revision History:
	
	Date		Rev		Change Description
	--------------------------------------------------------
	10/16/14	1.0.1		Updated to include config file editing
	10/17/14	1.0.2		Updated run command, ini vars write upon close
	10/29/14	1.0.3		Updated comments
	--------------------------------------------------------

	Project Overview:
	
		A AutoHotkey script that displays CPU graph using XGraph.ahk
	
	Project Features:
	
		NA
			
	Project Notes:

		Requires PC Running Windows 7
		
		Requires Functions.ahk + XGraph.ahk
			
	--------------------------------------------------------
*/

#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode 2	
SetBatchLines -1
ListLines, Off

; ----------------------------------------------------------
; Include ......: Functions.ahk
; Author .......: h0ll0w
; Info .........: https://github.com/h0ll0w-v0id/Windows_Gadgets
; ----------------------------------------------------------
#include Functions.ahk
; ----------------------------------------------------------
; Include ......: xGraph.ahk
; Author .......: SKAN
; Info .........: http://ahkscript.org/boards/viewtopic.php?t=3492
; ----------------------------------------------------------
#Include xGraph.ahk

; ----------------------------------------------------------
; Globals
; ----------------------------------------------------------
global scriptName 	:= 	"VisualCPU" 
global scriptVersion 	:=	"1.0.2"
global scriptConfig	:=	"VisualConfig.ini"
global guiX		:=	Center
global guiY		:=	Center
global guiWidth		:=	400
global guiHeight	:=	200
global guiRegion	:=	30
global guiControlWidth	:=	( guiWidth - ( guiRegion * 2) )
global guiAlwaysOnTop	:=	ON
global guiTransparency	:=	204
global guiColor1	:=	"0x000000"
global guiColor2	:=	"0xFF00FF"
; ----------------------------------------------------------
; Menu .........: GUI Right Click Menu
; ----------------------------------------------------------
Menu, MyAlwaysOnTopMenu, Add, ON, UpdateAlwaysOnTop
Menu, MyAlwaysOnTopMenu, Add, OFF, UpdateAlwaysOnTop
Menu, MyOpacityMenu, Add, 20`%, UpdateTrans
Menu, MyOpacityMenu, Add, 40`%, UpdateTrans
Menu, MyOpacityMenu, Add, 60`%, UpdateTrans
Menu, MyOpacityMenu, Add, 80`%, UpdateTrans
Menu, MyOpacityMenu, Add, 100`%, UpdateTrans
Menu, MyContextMenu, Add, Add Gadgets..., AddGadgets
Menu, MyContextMenu, Add
Menu, MyContextMenu, Add, Always On Top, :MyAlwaysOnTopMenu
Menu, MyContextMenu, Add, Opacity, :MyOpacityMenu
Menu, MyContextMenu, Add
Menu, MyContextMenu, Add, Settings, UpdateConfig
Menu, MyContextMenu, Add
Menu, MyContextMenu, Add, Close, EventExit
; ----------------------------------------------------------
; Label ........: GlobalConfig
; ----------------------------------------------------------
GlobalConfig:	
	; ----------------------------------------------------------
	; Read in Config values (if available)
	; ----------------------------------------------------------
	IfExist %scriptConfig%
	{
		IniRead	tempX, %scriptConfig%, %scriptName%, guiX
		If (tempX <> "ERROR")
		{
			guiX := tempX
		}
		IniRead	tempY, %scriptConfig%, %scriptName%, guiY
		If (tempY <> "ERROR")
		{
			guiY := tempY
		}
		IniRead tempAlwaysOnTop, %scriptConfig%, %scriptName%, guiAlwaysOnTop
		If (tempAlwaysOnTop <> "ERROR")
		{
			guiAlwaysOnTop := tempAlwaysOnTop	
		}
		IniRead tempTransparency, %scriptConfig%, %scriptName%, guiTransparency
		If (tempTransparency <> "ERROR")
		{
			guiTransparency := tempTransparency	
		}
		IniRead tempColor1, %scriptConfig%, %scriptName%, guiColor1
		If (tempColor1 <> "ERROR")
		{
			guiColor1 := tempColor1
		}
		IniRead tempColor2, %scriptConfig%, %scriptName%, guiColor2
		If (tempColor2 <> "ERROR")
		{
			guiColor2 := tempColor2
		}
		tempX = tempY = tempAlwaysOnTop = tempTransparency = tempColor1 = tempColor2 = 
	}
	GoSub, ShowGui
Return
; ----------------------------------------------------------
; Label ........: ShowGui
; ----------------------------------------------------------	
ShowGui:

	Gui, 1:	Destroy
	Gui, 1: +LastFound -Caption +ToolWindow +hwndhMain
	Gui, 1: Margin,	10, 10
	Gui, 1: Color, 	%guiColor1%
	Gui, 1: Font,	c%guiColor2%,	Consolas
	Gui, 1: Add,	Text,	xm+30 ym w80, %scriptName%
	Gui, 1: Add,	Text,	xm+250 yp w100 h10, Version %scriptVersion%
	Gui, 1: Add,	Text,	xm y+3  w%guiControlWidth% h1 0x7	
	Gui, 1: Add,	Text,	xm y+100 w20 h10 vCPU1, 0`%
	Gui, 1: Add,	Text,	xm+21 ym+20 w320 h111 hwndhGraph, pGraph 
	pGraph := XGraph( hGraph, guiColor1, 1, "5,5,5,5", guiColor2 )
	Gui, 1: Show,	% "AutoSize x" guiX " y" guiY " w" guiWidth, %scriptName%	
	
	OnMessage(0x201, "WM_LBUTTONDOWN")
	OnMessage(0xF, "WM_PAINT")

	SetTimer, UpdateRegion, -250
	SetTimer, UpdateAlwaysOnTop, -250
	SetTimer, UpdateTrans, -250
	SetTimer, UpdateCPULoad, -250
	SetTimer, XGraph_Plot, 1000
	
Return
; ----------------------------------------------------------
; Label ........: GuiContextMenu
; Description ..: Displays Menu at Gui Coords
; ----------------------------------------------------------	
GuiContextMenu:
	Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
Return
; ----------------------------------------------------------
; Label ........: AddGadgets
; Description ..: Opens GitHub
; ----------------------------------------------------------	
AddGadgets:
	Run https://github.com/h0ll0w-v0id/Windows_Gadgets
Return
; ----------------------------------------------------------
; Label ........: UpdateRegion
; Description ..: Displays a rounded region over Gui
; ----------------------------------------------------------	
UpdateRegion:
	updateSuccess := Function_UpdateRegion(guiRegion, guiRegion, scriptName)
Return
; ----------------------------------------------------------
; Label ........: UpdateConfig
; Description ..: Open and wait for setting file to close
; ----------------------------------------------------------
UpdateConfig:
	Run, Notepad.exe %scriptConfig%, , , notePadPID
	WinWait, ahk_pid %notepadPID%
	WinActivate 
	WinWaitClose
	GoSub ShowGui
Return
; ----------------------------------------------------------
; Label ........: UpdateAlwaysOnTop
; Description ..: Based upon selection, update Gui
; ----------------------------------------------------------
UpdateAlwaysOnTop:
	; if label called from a menu
	If (A_ThisMenuItem)
	{
		newValue := A_ThisMenuItem
		menuName := A_ThisMenu
	}
	; else, use variables to pass to the function
	Else
	{
		newValue := guiAlwaysOnTop
		menuName := "MyAlwaysOnTopMenu"
	}
	updateSuccess := Function_AlwaysOnTop(newValue, menuName, scriptName)
	; if not error, save return variables
	If (updateSuccess <> 0)
	{
		guiAlwaysOnTop := updateSuccess
	}
	updateSuccess = newValue =
Return
; ----------------------------------------------------------
; Label ........: UpdateTrans
; Description ..: Based upon selection, update Gui
; ----------------------------------------------------------
UpdateTrans:
	; if label called from a menu
	If (A_ThisMenuItem)
	{
		If (A_ThisMenuItem == "Settings")
		{
			newValue := guiTransparency
			menuName := "MyOpacityMenu"
		}
		Else
		{
			newValue := A_ThisMenuItem
			menuName := A_ThisMenu
		}
	}
	; else, use variables to pass to the function
	Else
	{
		newValue := guiTransparency
		menuName := "MyOpacityMenu"
	}
	updateSuccess := Function_UpdateTransparency(newValue, menuName, scriptName)
	; if not error, save return variables
	If (updateSuccess <> 0)
	{
		guiTransparency := updateSuccess
	}
	updateSuccess = newValue = 
Return
; ----------------------------------------------------------
; Label ........: UpdateCPULoad
; Description ..: Updates CPU% on Gui
; Author .......: jNizM
; Info .........: http://ahkscript.org/boards/viewtopic.php?f=6&t=254
; ----------------------------------------------------------
UpdateCPULoad:
    CPU := CPULoad()
    GuiControl,, CPU1, % CPU "%"
	SetTimer, UpdateCPULoad, 1000
Return
; ----------------------------------------------------------
; Function .....: CPULoad
; Description ..: Returns CPU load
; Author .......: SKAN, ejor
; Info .........: http://goo.gl/epYnkO
; ..............: http://ahkscript.org/boards/viewtopic.php?p=17166#p17166
; ----------------------------------------------------------
CPULoad() 
{ 
	Static PIT, PKT, PUT	
	IfEqual, PIT,, Return 0, DllCall( "GetSystemTimes", "Int64P",PIT, "Int64P",PKT, "Int64P",PUT )

	DllCall( "GetSystemTimes", "Int64P",CIT, "Int64P",CKT, "Int64P",CUT )
	, IdleTime := PIT - CIT,    KernelTime := PKT - CKT,    UserTime := PUT - CUT
	, SystemTime := KernelTime + UserTime 

	Return ( ( SystemTime - IdleTime ) * 100 ) // SystemTime,    PIT := CIT,    PKT := CKT,    PUT := CUT 
} 
; ----------------------------------------------------------
; Label ........: XGraph_Paint
; ----------------------------------------------------------
XGraph_Paint:
	Sleep -1
	XGraph_Plot( pGraph )
Return
; ----------------------------------------------------------
; Label ........: XGraph_Plot
; ----------------------------------------------------------
XGraph_Plot:
	; CPUL := 5
	CPUL := CPULoad()
	{
		XGraph_Plot( pGraph, 100 - CPUL, CPUL )
	}
Return
; ----------------------------------------------------------
; Function .....: WM_PAINT
; ----------------------------------------------------------
WM_PAINT() {
	If ( A_GuiControl == pGraph)
	{
		SetTimer, XGraph_Paint, -1
	}
}
; ----------------------------------------------------------
; Function .....: WM_LBUTTONDOWN
; Description ..: Allows Caption Gui to be "movable"
; ----------------------------------------------------------
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
{
    global hMain
    If ( hwnd == hMain )
    {
        PostMessage, 0xA1, 2,,, ahk_id %hMain%
    }
}
; ----------------------------------------------------------
; Label ........: EventExit
; Description ..: Save's Menu and Gui vars then exits
; ----------------------------------------------------------
EventExit:
1GuiClose:
1GuiEscape:
	pGraph := XGraph_Detach( pGraph )
	
	; upon close write all current vars to ini
	GuiControlGet, curPosition,,guiSlider
	; capture GUI position and record it in INI
	WinGetPos, guiX, guiY, , , %scriptName%
	; do not allow GUI position to be negative
	If ( guiX > 0 ) and ( guiY > 0 )
	{
		IniWrite, %guiX%, %scriptConfig%, %scriptName%, guiX
		IniWrite, %guiY%, %scriptConfig%, %scriptName%, guiY
	}
		IniWrite, %guiTransparency%, %scriptConfig%, %scriptName%, guiTransparency
		IniWrite, %guiAlwaysOnTop%, %scriptConfig%, %scriptName%, guiAlwaysOnTop
		IniWrite, %guiColor1%, %scriptConfig%, %scriptName%, guiColor1
		IniWrite, %guiColor2%, %scriptConfig%, %scriptName%, guiColor2		
ExitApp	
