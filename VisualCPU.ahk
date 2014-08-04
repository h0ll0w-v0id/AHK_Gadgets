	/*
	--------------------------------------------------------
	REVISION BLOCK
		
	Project Name: MyDrives
	
	Revision History:
	
	--------------------------------------------------------

*/

	#NoEnv
	#SingleInstance Force
	SetWorkingDir %A_ScriptDir%
	SetTitleMatchMode 2	
	SetBatchLines -1
	ListLines, Off
		
	; found here https://github.com/h0ll0w-v0id/Gadgets
	#include Class_Functions.ahk
	#Include Class_xGraph.ahk
	
	; -----------------------------------
	;	Script Globals
	; -----------------------------------
	global scriptName 	:= 	"VisualCPU" 
	global scriptVersion :=	"1.0.0"
	global scriptConfig	:=	"Visual_Config.ini"
	global guiX	:=	Center
	global guiY	:=	Center
	global guiTransparency	:=	204
	global guiAlwaysOnTop	:=	ON
	
	EnvGet, ProcessorCount, NUMBER_OF_PROCESSORS
	; -----------------------------------
	;	Read in Config values (if available)
	; -----------------------------------
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
		IniRead tempTransparency, %scriptConfig%, %scriptName%, guiTransparency
		If (tempTransparency <> "ERROR")
		{
			guiTransparency := tempTransparency	
		}
		IniRead tempAlwaysOnTop, %scriptConfig%, %scriptName%, guiAlwaysOnTop
		If (guiAlwaysOnTop <> "ERROR")
		{
			guiAlwaysOnTop := tempAlwaysOnTop	
		}

		tempX = tempY = tempTransparency = tempAlwaysOnTop = 
	}

	; -----------------------------------
	;	GUI Position Variables
	; -----------------------------------
	global guiDockPadding	:=	5
	global guiWidth		:=	400
	global guiHeight	:=	200
	global guiControlWidth	:=	( guiWidth - 60 )
	; get multiple display resolution
	SysGet, virtualWidth, 78
	SysGet, virtualHeight, 79
	; sets a docking edge 5 px from virtual desktop (for multiple displays)
	global guiDockRight	:=	( virtualWidth - guiWidth - guiDockPadding )
	global guiDockBottom	:=	( virtualHeight - guiHeight - guiDockPadding )
	; left and top start from 0, so able to reuse var
	global guiDockLeftTop	:=	guiDockPadding * 3
	
	; -----------------------------------
	;	GUI Right Click Menu
	; -----------------------------------		
	Menu, MyAOTMenu, Add, ON, UpdateAOT
	Menu, MyAOTMenu, Add, OFF, UpdateAOT
	Menu, MyOpacityMenu, Add, 20`%, UpdateTrans
	Menu, MyOpacityMenu, Add, 40`%, UpdateTrans
	Menu, MyOpacityMenu, Add, 60`%, UpdateTrans
	Menu, MyOpacityMenu, Add, 80`%, UpdateTrans
	Menu, MyOpacityMenu, Add, 100`%, UpdateTrans
	Menu, MyContextMenu, Add, Add Gadgets..., AddGadgets
	Menu, MyContextMenu, Add
	Menu, MyContextMenu, Add, Always On Top, :MyAOTMenu
	Menu, MyContextMenu, Add, Opacity, :MyOpacityMenu
	Menu, MyContextMenu, Add
	Menu, MyContextMenu, Add, Close, EventExit
	
; -----------------------------------
;	GUI Display
; -----------------------------------	
ShowGui:

	Gui, 1:	Destroy
	Gui, 1: +LastFound -Caption +ToolWindow +hwndhMain
	Gui, 1: Margin,	10, 10
	Gui, 1: Color, 	000000
	Gui, 1: Font, 	cC0C0C0,	Consolas
	Gui, 1: Add,	Text,	xm ym w80, %scriptName%
	Gui, 1: Font, 	cFFFFFF,
	Gui, 1: Add, 	Text,	xm+60 yp w80 0x202 vCPU1,
	Gui, 1: Font, 	cC0C0C0,
	Gui, 1: Add,	Text,	xm+250 yp w100 h10, Version %scriptVersion%
	Gui, 1: Font, 	cFFFFFF,
	Gui, 1: Add,	Text,	xm y+3  w%guiControlWidth% h1 0x7	
	GuiControl,, CPU1, 

	
	/*
	Loop, % 11 + ( Y := 15 ) - 15 ; Loop 11 times 
	{
		Gui, 1: Add,	Text,	xm y+1  w22 h10 0x200 Right, % 125 - (Y += 10) ; %y%
	}

	ColumnW := 10

	hBM := XGraph_MakeGrid(  ColumnW, 10, 33, 12, 0x008000, 0, GraphW, GraphH )
	Gui, 1: Add, 		Text, 		% "xm+25 ym+20 w" ( GraphW + 2 ) " h" ( GraphH + 2 ) " 0x1000" ; SS_SUNKEN := 0x1000
	Gui, 1: Add, 		Text, 		xp+1 ym+20 w%GraphW% h%GraphH% hwndhGraph gXGraph_GetVal 0xE, pGraph
	pGraph := XGraph( hGraph, hBM, ColumnW, "1,10,0,10", 0x00FF00, 1, True )
*/



	Gui, Add, Text, xm+1 y+3 w350 h100 hwndhGraph, pGraph 
	pGraph := XGraph( hGraph, 0x000000, 1, "5,5,5,5", 0x00FF00 )

	; Gui, 1: Add,	Text,	xm y+3  w%guiControlWidth% h1 0x7
	Gui, 1: Show,	% "AutoSize x" guiX " y" guiY " w" guiWidth, %scriptName%	

	OnMessage(0x201, "WM_LBUTTONDOWN")
	OnMessage(0xF, "WM_PAINT")

	/*
	; overlay rounded corner region based on current gui width/height
	WinGetPos,,,guiWidth,guiHeight,%scriptName%
	regionWidth 			:= 			(guiWidth - 10)
	regionHeight 			:= 			(guiHeight - 10)
	WinSet, Region, 0-0 W%regionWidth% H%regionHeight% R30-30, %scriptName%	
	*/
	
	
	SetTimer, UpdateRegion, -250
	SetTimer, UpdateAOT, -250
	SetTimer, UpdateTrans, -250
	; SetTimer, UpdateCPULoad, -1000
	SetTimer, XGraph_Plot, 500

Return
; -----------------------------------
;	GuiContextMenu
; -----------------------------------	
GuiContextMenu:
	Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
Return
; -----------------------------------
;	AddGadgets
; -----------------------------------	
AddGadgets:
	Run https://github.com/h0ll0w-v0id/Gadgets
Return
; -----------------------------------
;	UpdateRegion
; -----------------------------------
UpdateRegion:
	updateSuccess := Function_UpdateRegion(30, 30, scriptName)
Return
; -----------------------------------
;	UpdateAOT
; -----------------------------------
UpdateAOT:
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
		menuName := "MyAOTMenu"
	}
	updateSuccess := Function_AlwaysOnTop(newValue, menuName, scriptName)
	; if not error, save return variables
	If (updateSuccess <> 0)
	{
		guiAlwaysOnTop := updateSuccess
	}
	updateSuccess = newValue =
Return
; -----------------------------------
;	UpdateTrans
; -----------------------------------
UpdateTrans:
	; if label called from a menu
	If (A_ThisMenuItem)
	{
		newValue := A_ThisMenuItem
		menuName := A_ThisMenu
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



; thanks to jNizM
; http://ahkscript.org/boards/viewtopic.php?f=6&t=254
UpdateCPULoad:
    ; GuiControl,, CPU1, % GetProcessCount() " processes"
    CPU := CPULoad()
    GuiControl,, CPU1, % CPU "%"
    ; GuiControl, % ((CPU <= "50") ? "+c00FF00" : ((CPU <= "80") ? "+cFFA500" : "+cFF0000")), CPU3
    ; GuiControl,, CPU3, % CPU

	SetTimer, UpdateCPULoad, 1000
return


CPULoad() 
{ ; By SKAN, CD:22-Apr-2014 / MD:05-May-2014. Thanks to ejor, Codeproject: http://goo.gl/epYnkO
	Static PIT, PKT, PUT	; http://ahkscript.org/boards/viewtopic.php?p=17166#p17166
	IfEqual, PIT,, Return 0, DllCall( "GetSystemTimes", "Int64P",PIT, "Int64P",PKT, "Int64P",PUT )

	DllCall( "GetSystemTimes", "Int64P",CIT, "Int64P",CKT, "Int64P",CUT )
	, IdleTime := PIT - CIT,    KernelTime := PKT - CKT,    UserTime := PUT - CUT
	, SystemTime := KernelTime + UserTime 

	Return ( ( SystemTime - IdleTime ) * 100 ) // SystemTime,    PIT := CIT,    PKT := CKT,    PUT := CUT 
} 

XGraph_Paint:
	Sleep -1
	XGraph_Plot( pGraph )
Return

XGraph_Plot:
	; CPUL := 5
	CPUL := CPULoad()
	{
		XGraph_Plot( pGraph, 100 - CPUL, CPUL )
	}
Return

WM_PAINT() {
	IfEqual, A_GuiControl, pGraph, SetTimer, XGraph_Paint, -1
}
; -----------------------------------
;	WM_LBUTTONDOWN
;	Desc: allows GUI to be movable
; -----------------------------------
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
{
    global hMain
    if (hwnd = hMain)
    {
        PostMessage, 0xA1, 2,,, % WinTitel
    }
}
; -----------------------------------
;	EventExit
;	Desc: saves script vars
; -----------------------------------
EventExit:
GuiClose:
GuiEscape:
	pGraph := XGraph_Detach( pGraph )
	GuiControlGet, curPosition,,guiSlider
	; capture GUI position and record it in INI
	WinGetPos, guiX, guiY, , , %scriptName%
	; do not allow GUI position to be negative
	if (guiX > 0) and (guiY > 0)
	{
		IniWrite, %guiX%, %scriptConfig%, %scriptName%, guiX
		IniWrite, %guiY%, %scriptConfig%, %scriptName%, guiY
	}
		IniWrite, %guiTransparency%, %scriptConfig%, %scriptName%, guiTransparency
		IniWrite, %guiAlwaysOnTop%, %scriptConfig%, %scriptName%, guiAlwaysOnTop
		
ExitApp	
	
	
