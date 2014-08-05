/*
	--------------------------------------------------------
	REVISION BLOCK
		
	Project Name: MyDrives
	
	Revision History:
	
	--------------------------------------------------------
	; from:
	; AHK Version ...: AHK_L 1.1.15.00 x64 Unicode
	; Win Version ...: Windows 7 Professional x64 SP1
	; Description ...: htopmini
	; Version .......: v0.8.3
	; Modified ......: 2014.04.11-2027
	; Author ........: jNizM
	; Licence .......: WTFPL (http://www.wtfpl.net/txt/copying/)
	; ======================================================
	;@Ahk2Exe-SetName htopmini
	;@Ahk2Exe-SetDescription htopmini
	;@Ahk2Exe-SetVersion v0.8.3
	;@Ahk2Exe-SetCopyright Copyright (c) 2013-2014`, jNizM
	;@Ahk2Exe-SetOrigFilename htopmini.ahk
	--------------------------------------------------------
*/

	#NoEnv
	#SingleInstance Force
	SetWorkingDir %A_ScriptDir%
	SetTitleMatchMode 2	
	SetBatchLines -1

	; found here https://github.com/h0ll0w-v0id/Gadgets
	#include Class_Functions.ahk

	; -----------------------------------
	;	Script Globals
	; -----------------------------------
	global scriptName 	:= 	"VisualDrives" 
	global scriptVersion :=	"1.0.0"
	global scriptConfig	:=	"Visual_Config.ini"
	global guiX	:=	Center
	global guiY	:=	Center
	global guiWidth		:=	400
	global guiHeight	:=	200
	global guiRegion	:=	30
	global guiControlWidth	:=	( guiWidth - ( guiRegion * 2) )
	global guiTransparency	:=	204
	global guiAlwaysOnTop	:=	ON
	
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

		tempX = tempY = tempTransparency = tempAlwaysOnTop = 
	}

	; -----------------------------------
	;	GUI Right Click Menu
	; -----------------------------------		
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
	Gui, 1: Font,	c00FF00, 
	Gui, 1: Add, 	Text,	xm+80  yp w40 0x202, Used
	Gui, 1: Font, 	cFFFFFF,
	Gui, 1: Add, 	Text,	xm+160 yp   w60 0x202, Total
	Gui, 1: Font, 	cC0C0C0,
	Gui, 1: Add,	Text,	xm+250 yp w100 h10, Version %scriptVersion%
	Gui, 1: Font, 	cFFFFFF,
	Gui, 1: Add, 	Text,	xm y+3 w%guiControlWidth% h1 0x7

	Gui, 1: Font, 	cFFFFFF,
	Gui, 1: Add, 	Text,	xm y+3 w30 0x200, Fixed:
	
	; jNizM parse loops:
	; Fixed drives
	DriveGet, DrvLstFxd, List, FIXED
	Loop, Parse, DrvLstFxd
	{
		Gui, 1: Font,	cFFFFFF,
		Gui, 1: Add,	Text,    	xm     y+1 w30 0x200 gDriveClick, %A_Loopfield%:\
		Gui, 1: Font,	c00FF00,
		Gui, 1: Add,	Text,    	xm+40  yp w80 0x202 vD%A_Loopfield%1,
		Gui, 1: Font,	cFFFFFF,
		Gui, 1: Add,	Text,     	xm+140 yp w80 0x202 vD%A_Loopfield%2,
		Gui, 1: Add,	Progress, 	xm+250 yp+1 w100 h10 vD%A_Loopfield%3,
		Gui, 1: Font,	c000000 s7,
		Gui, 1: Add,	Text,     	xm+250 yp w100 h11 0x202 +BackgroundTrans vD%A_Loopfield%4,
		Gui, 1: Font,	cFFFFFF s8,
	}

	Gui, 1: Add, 		Text,     	xm     y+3  w%guiControlWidth% h1 0x7
	Gui, 1: Font, 		cFFFFFF,
	Gui, 1: Add, 		Text,     	xm     y+3 w30 0x200, Removable:
	; Removable drives
	DriveGet, DrvLstRmvbl, List, REMOVABLE
	loop, Parse, DrvLstRmvbl
	{
		Gui, 1: Font, cFFFFFF,
		Gui, 1: Add, Text,     xm     y+1 w30 0x200 gDriveClick, %A_Loopfield%:\
		Gui, 1: Font, c00FF00,
		Gui, 1: Add, Text,     xm+40  yp w80 0x202 vD%A_Loopfield%1,
		Gui, 1: Font, cFFFFFF,
		Gui, 1: Add, Text,     xm+140 yp w80 0x202 vD%A_Loopfield%2,
		Gui, 1: Add, Progress, xm+250 yp+1 w70 h10 vD%A_Loopfield%3,
		Gui, 1: Font, c000000 s7,
		Gui, 1: Add, Text,     xm+250 yp w70 h11 0x202 +BackgroundTrans vD%A_Loopfield%4,
		Gui, 1: Font, cFFFFFF s7,
		Gui, 1: Add, Text,     xm+320 yp w30 0x202 v%A_Loopfield% gDriveEject, Eject
		Gui, 1: Font, cFFFFFF s8,
	}

	Gui, 1: Add, Text,     xm     y+3  w%guiControlWidth% h1 0x7
	Gui, 1: Font, cFFFFFF,
	Gui, 1: Add, Text,     xm     y+3 w30 0x200, Network:
	; Network drives
	DriveGet, DrvLstNtwrk, List, NETWORK
	loop, Parse, DrvLstNtwrk
	{
		Gui, 1: Font, cFFFFFF,
		Gui, 1: Add, Text,     xm     y+1 w30 0x200 gDriveClick, %A_Loopfield%:\
		Gui, 1: Font, c00FF00,
		Gui, 1: Add, Text,     xm+40  yp w80 0x202 vD%A_Loopfield%1,
		Gui, 1: Font, cFFFFFF,
		Gui, 1: Add, Text,     xm+140 yp w80 0x202 vD%A_Loopfield%2,
		Gui, 1: Add, Progress, xm+250 yp+1 w100 h10 vD%A_Loopfield%3,
		Gui, 1: Font, c000000 s7,
		Gui, 1: Add, Text,     xm+250 yp w100 h11 0x202 +BackgroundTrans vD%A_Loopfield%4,
		Gui, 1: Font, cFFFFFF s8,
	}

	Gui, 1: Show, 		% "AutoSize x" guiX " y" guiY " w" guiWidth, %scriptName%	

	OnMessage(0x201, "WM_LBUTTONDOWN")
	OnMessage(0x219, "WM_DEVICECHANGE")
	
	SetTimer, UpdateRegion, -250
	SetTimer, UpdateDrive, -250
	SetTimer, UpdateAlwaysOnTop, -250
	SetTimer, UpdateTrans, -250


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

; -----------------------------------
; 	UpdateDrive
;	Desc: 
; -----------------------------------
UpdateDrive:
    loop, Parse, DrvLstFxd
    {
        i := A_LoopField
        DriveGet, cap%i%, Capacity, %i%:\
        DriveSpaceFree, free%i%, %i%:\
        used%i% := cap%i% - free%i%
        perc%i% := used%i% / cap%i% * 100
        GuiControl,, D%i%1, % Round(used%i% / 1024, 2) " GB"
        GuiControl,, D%i%2, % Round(cap%i% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%i%, D%i%3
        GuiControl, % (perc%i% <= "80") ? "+c00FF00" : (perc%i% <= "90") ? "+cFFA500" : "+cFF0000", D%i%3
        GuiControl,, D%i%3, % used%i%
        GuiControl,, D%i%4, % (varPerc = "1") ? Round(perc%i%, 2) " % " : ""
    }
    loop, Parse, DrvLstRmvbl
    {
        j := A_LoopField
        DriveGet, cap%j%, Capacity, %j%:\
        DriveSpaceFree, free%j%, %j%:\
        used%j% := cap%j% - free%j%
        perc%j% := used%j% / cap%j% * 100
        GuiControl,, D%j%1, % Round(used%j% / 1024, 2) " GB"
        GuiControl,, D%j%2, % Round(cap%j% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%j%, D%j%3
        GuiControl, % (perc%j% <= "80") ? "+c00FF00" : (perc%j% <= "90") ? "+cFFA500" : "+cFF0000", D%j%3
        GuiControl,, D%j%3, % used%j%
        GuiControl,, D%j%4, % (varPerc = "1") ? Round(perc%j%, 2) " % " : ""
    }
    loop, Parse, DrvLstNtwrk
    {
        k := A_LoopField
        DriveGet, cap%k%, Capacity, %k%:\
        DriveSpaceFree, free%k%, %k%:\
        used%k% := cap%k% - free%k%
        perc%k% := used%k% / cap%k% * 100
        GuiControl,, D%k%1, % Round(used%k% / 1024, 2) " GB"
        GuiControl,, D%k%2, % Round(cap%k% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%k%, D%k%3
        GuiControl, % (perc%k% <= "80") ? "+c00FF00" : (perc%k% <= "90") ? "+cFFA500" : "+cFF0000", D%k%3
        GuiControl,, D%k%3, % used%k%
        GuiControl,, D%k%4, % (varPerc = "1") ? Round(perc%k%, 2) " % " : ""
    }
   ; SetTimer, UpdateDrive, 5000
Return
; -----------------------------------
;	DriveEject
;	Desc: run each drive letter
; -----------------------------------
DriveEject:
	tmpVar := A_GuiControl . ":"
	ejectSuccess := Function_Eject(tmpVar)
	If !(ejectSuccess)
	{
		MsgBox, 8256, Safely Remove Hardware and Eject Media, 
		(
		Storage device `"%Drive%`" was unable to be ejected`, ensure no programs are accessing it and try again.
		)
	}
	GoSub, ShowGui
Return

; -----------------------------------
;	DriveClick
;	Desc: run each drive letter
; -----------------------------------
DriveClick:
    Run, % SubStr(A_GuiControl, 1)
Return
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
;	WM_DEVICECHANGE
;	Desc: repaints GUI when drives change
; -----------------------------------
WM_DEVICECHANGE(wParam, lParam, msg, hwnd)
{
    global hmain, htopx, htopy
    if (wParam = 0x8000 || wParam = 0x8004)
    {
        Thread, NoTimers
        ; WinGetPos, htopx, htopy,,, ahk_id %hmain%
        ; Gui, 1: Destroy
        Gosub, ShowGui
    }
}
; -----------------------------------
;	EventExit
;	Desc: saves script vars
; -----------------------------------
EventExit:
GuiClose:
GuiEscape:
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
