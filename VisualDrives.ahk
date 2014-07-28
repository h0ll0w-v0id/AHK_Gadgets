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

	#include Class_Functions.ahk
	
	; set global defaults
	global scriptName 	:= 	"VisualDrives" 
	global scriptConfig	:=	"Visual_Config.ini"
	global guiX		:=	Center
	global guiY		:=	Center
	global guiDockPadding	:=	5
	global guiTransparency	:=	204
	global guiTheme		:=	Plain
	
	; read in config values if available
	; TODO add error checking function
	IfExist %scriptConfig%
	{
		IniRead	guiX, %scriptConfig%, %scriptName%, guiX
		IniRead	guiY, %scriptConfig%, %scriptName%, guiY	
		IniRead guiTransparency, %scriptConfig%, %scriptName%, guiTransparency
	}

	global guiWidth		:=	400
	global guiHeight	:=	200
	global guiControlWidth	:=	( guiWidth - 30 )

	; obs this??
	; get multiple display resolution
	SysGet, virtualWidth, 78
	SysGet, virtualHeight, 79
	; sets a docking edge 5 px from virtual desktop (for multiple displays)
	global guiDockRight	:=	( virtualWidth - guiWidth - guiDockPadding )
	global guiDockBottom	:=	( virtualHeight - guiHeight - guiDockPadding )
	; left and top start from 0, so able to reuse var
	global guiDockLeftTop	:=	guiDockPadding * 3
	
	; Transparency Menu
	Menu, MyOpacityMenu, Add, 20`%, MenuHandler
	Menu, MyOpacityMenu, Add, 40`%, MenuHandler
	Menu, MyOpacityMenu, Add, 60`%, MenuHandler
	Menu, MyOpacityMenu, Add, 80`%, MenuHandler
	Menu, MyOpacityMenu, Add, 100`%, MenuHandler
	; Themes Menu
	Menu, MyThemesMenu, Add, Alien Green, MenuHandler
	Menu, MyThemesMenu, Add, Plain, MenuHandler
	Menu, MyThemesMenu, Add, Cold Blue, MenuHandler
	Menu, MyThemesMenu, Add, Burnt Red, MenuHandler
	Menu, MyThemesMenu, Add, High Contrast, MenuHandler
	; Main menu
	Menu, MyContextMenu, Add, Always On Top, EventExit
	Menu, MyContextMenu, Add, Opacity, :MyOpacityMenu
	Menu, MyContextMenu, Add, Themes, :MyThemesMenu
	Menu, MyContextMenu, Add
	Menu, MyContextMenu, Add, Close, EventExit
	
; -----------------------------------
;	ShowGui
; -----------------------------------	
ShowGui:

	Gui, 1:	Destroy
	Gui, 1: +LastFound -Caption +ToolWindow +hwndhMain
	Gui, 1: Margin,	10, 10
	Gui, 1: Color, 	000000
	Gui, 1: Font, 	cFFFFFF,	Consolas
	Gui, 1: Add,	Text,		xm ym w80, %scriptName%
	Gui, 1: Font,	c00FF00, 
	Gui, 1: Add, 	Text,     	xm+60  yp w60 0x202, Used
	Gui, 1: Font, 	cFFFFFF,
	Gui, 1: Add, 	Text,     	xm+160 yp   w60 0x202, Total

	Gui, 1: Add, 	Text,    	xm     y+3  w%guiControlWidth% h1 0x7

	Gui, 1: Font, 	cFFFFFF,
	Gui, 1: Add, 	Text,    	xm     y+3 w30 0x200, Fixed:
	
	
	; jNizM parse loops:
	DriveGet, DrvLstFxd, List, FIXED
	Loop, Parse, DrvLstFxd
	{
		Gui, 1: Font, 	cFFFFFF,
		Gui, 1: Add, 	Text,    	xm     y+1 w30 0x200 gDriveClick, %A_Loopfield%:\
		Gui, 1: Font, 	c00FF00,
		Gui, 1: Add, 	Text,    	xm+40  yp w80 0x202 vD%A_Loopfield%1,
		Gui, 1: Font, 	cFFFFFF,
		Gui, 1: Add, 	Text,     	xm+140 yp w80 0x202 vD%A_Loopfield%2,
		Gui, 1: Add, 	Progress, 	xm+250 yp+1 w100 h10 vD%A_Loopfield%3,
		Gui, 1: Font, 	c000000 s7,
		Gui, 1: Add, 	Text,     	xm+250 yp w100 h11 0x202 +BackgroundTrans vD%A_Loopfield%4,
		Gui, 1: Font, 	cFFFFFF s8,
	}

	Gui, 1: Add, 		Text,     	xm     y+3  w%guiControlWidth% h1 0x7
	Gui, 1: Font, 		cFFFFFF,
	Gui, 1: Add, 		Text,     	xm     y+3 w30 0x200, Removable:

	DriveGet, DrvLstRmvbl, List, REMOVABLE
	loop, Parse, DrvLstRmvbl
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

	Gui, 1: Add, Text,     xm     y+3  w%guiControlWidth% h1 0x7
	Gui, 1: Font, cFFFFFF,
	Gui, 1: Add, Text,     xm     y+3 w30 0x200, Network:

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

	Gui, 1: Add, 		Text,     	xm y+3  w%guiControlWidth% h1 0x7
	; Gui, 1: Font, 		c808080,
	; Gui, 1:	Add,		Text,		xm yp+6 w120 h30 vguiPosition, Opacity`:
	; Gui, 1: Add, 		Slider, 	xm+60 yp w100 h20 gEventUpdateTrans vguiSlider Thick10 Range50-255 ToolTip, %startPos%

	Gui, 1: Add, 		Button,   xm+290 yp   w60 h20 -Theme 0x8000 gEventExit, Close
	; Gui, 1: Show, % "AutoSize" (htopx ? " x" htopx " y" htopy : ""), % scriptName
	; Gui, 1: Show,		AutoSize, % scriptName
	Gui, 1: Show, 		% "AutoSize x" guiX " y" guiY " w" guiWidth, %scriptName%	

	SetTimer, UpdateDrive, -1000

	OnMessage(0x201, "WM_LBUTTONDOWN")
	OnMessage(0x219, "WM_DEVICECHANGE")

	; add to Themes??
	; overlay rounded corner region based on current gui width/height
	WinGetPos,,,guiWidth,guiHeight,%scriptName%
	regionWidth 			:= 			(guiWidth - 10)
	regionHeight 			:= 			(guiHeight - 10)
	WinSet, Region, 0-0 W%regionWidth% H%regionHeight% R30-30, %scriptName%	
	
	; set transparency		
	; WinSet, Transparent, %guiTransparency%, %scriptName%	
	
	; call function
	updateTrans := Function_UpdateTransparency(guiTransparency, scriptName)
	; catch error
	If (!updateTrans)
	{
		MsgBox % "Error updating " . A_ThisMenuItem . " with " . scriptName
	}
	; save value for ini
	Else 
	{
		guiTransparency := updateTrans
	}

Return
; -----------------------------------
;	GuiContextMenu
; -----------------------------------	
GuiContextMenu:
	Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
Return
; -----------------------------------
;	MenuHandler
; -----------------------------------
MenuHandler:
	; call function
	updateTrans := Function_UpdateTransparency(A_ThisMenuItem, scriptName)
	; catch error
	If (!updateTrans)
	{
		MsgBox % "Error updating " . A_ThisMenuItem . " with " . scriptName
	}
	; save value for ini
	Else 
	{
		guiTransparency := updateTrans
	}
	; MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%. %scriptName%
	; SubStr(A_GuiControl, 1)
Return
/*
; -----------------------------------
;	UpdateTransparency
;	1st param: value of transparency
;	2nd param: win title
; -----------------------------------
UpdateTransparency(transValue, winTitle)
{
	const20		:=			51
	const40		:=			102	
	const60		:=			153
	const80		:=			204
	const100	:=			255
	
	try
	{
		; allow parameter to contain hard coded or menu selected value
		; enabling function to be called from gui or ini readback
		If (transValue == "20%" or transValue == const20)
		{
			WinSet, Transparent, %const20%, %winTitle%
			Menu, MyOpacityMenu, ToggleCheck, 20`%
			Return % const20
		}
		If (transValue == "40%" or transValue == const40)
		{
			WinSet, Transparent, %const40%, %winTitle%
			Menu, MyOpacityMenu, ToggleCheck, 40`%
			Return % const40
		}
		If (transValue == "60%" or transValue == const60)
		{
			WinSet, Transparent, %const60%, %winTitle%
			Menu, MyOpacityMenu, ToggleCheck, 60`%
			Return % const60
		}
		If (transValue == "80%" or transValue == const80)
		{
			WinSet, Transparent, %const80%, %winTitle%
			Menu, MyOpacityMenu, ToggleCheck, 80`%
			Return % const80
		}
		If (transValue == "100%" or transValue == const100)
		{
			WinSet, Transparent, %const100%, %winTitle%
			Menu, MyOpacityMenu, ToggleCheck, 100`%
			Return % const100
		}
	}
	; on error, return 0
	catch
	{
		Return 0
	}
}
*/
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
    SetTimer, UpdateDrive, 5000
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
        WinGetPos, htopx, htopy,,, ahk_id %hmain%
        ; Gui, 1: Destroy
        Gosub, ShowGui
    }
}
; -----------------------------------
;	EventExit
;	Desc: saves gadget position, transparency, theme
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
ExitApp	
