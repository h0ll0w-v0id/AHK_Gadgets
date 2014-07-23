	#NoEnv
	#SingleInstance Force
	SetWorkingDir %A_ScriptDir%
	SetTitleMatchMode 2	
	
	ListLines, Off
	
	#Include Class_xGraph.ahk
	; #Include FileTail.ahk
		
	; set global defaults
	
	global scriptName 		:= 			"MyCPU" 
	global scriptConfig		:=			"GadgetsConfig.ini"
	global guiX				:=			Center
	global guiY				:=			Center
	global guiDockPadding	:=			5
	; starting transparency for gui
	global startPos			:=			180
	
	; read in config values if available
	IfExist %scriptConfig%
	{
		IniRead		guiX,		%scriptConfig%,		guiMyCPU, 		guiX
		IniRead		guiY,		%scriptConfig%, 	guiMyCPU,		guiY	
		IniRead		startPos,	%scriptConfig%,		guiMyCPU,		startPos
		
		; thanks to specter333
		; from http://www.autohotkey.com/board/topic/70718-create-variables-from-a-iniread-loop/
	}
	
	global guiWidth			:=			400
	global guiHeight		:=			200
	global guiControlWidth	:=			( guiWidth - 30 )

	; get multiple display resolution
	SysGet, virtualWidth, 78
	SysGet, virtualHeight, 79
	; sets a docking edge 5 px from virtual desktop (for multiple displays)
	global guiDockRight		:=			( virtualWidth - guiWidth - guiDockPadding )
	global guiDockBottom	:=			( virtualHeight - guiHeight - guiDockPadding )
	; left and top start from 0, so able to reuse var
	global guiDockLeftTop	:=			guiDockPadding * 3

	EnvGet, ProcessorCount, NUMBER_OF_PROCESSORS

; --------------------------------------------------------------------------------------------------------------
; 			LoadGui
; --------------------------------------------------------------------------------------------------------------
LoadGui:
	Gui, 1:	Destroy

	
	/*
	
	
	OnMessage(0x201, "Derp")

gui, show, w400 h200

return



Derp(wParam, lParam, Msg) 

{

  Tooltip % "testing..."

}

*/
	

	Gui, 1:	Destroy
	Gui, 1: +LastFound -Caption +ToolWindow +hwndhMain
	Gui, 1: Margin, 10, 10
	Gui, 1: Color, 000000
	Gui, 1: Font, 		cFFFFFF, Consolas
	
	Gui, 1: Add,		Text,		xm ym w80, %scriptName%
	Gui, 1: Font,		c00FF00, 
	; Gui, 1: Add, 		Text,     	xm+40  yp w40 0x202, CPU
	Gui, 1: Add, 		Text,     	xm+60 yp w80 0x202 vCPU1,
	Gui, 1: Add, 		Text,     	xm+160 yp w80 0x202, % ProcessorCount " cores"
	
	
	GuiControl,, CPU1, 
	
	Gui, 1: Font, 		cFFFFFF,
	Gui, 1: Add, 		Text,    	xm     y+3  w%guiControlWidth% h1 0x7
	
	Loop, % 11 + ( Y := 15 ) - 15 ; Loop 11 times 
	{
		Gui, 1: Add, 	Text, 		xm y+1  w22 h10 0x200 Right, % 125 - (Y += 10) ; %y%
	}

	ColumnW := 10

	hBM := XGraph_MakeGrid(  ColumnW, 10, 33, 12, 0x008000, 0, GraphW, GraphH )
	Gui, 1: Add, 		Text, 		% "xm+25 ym+20 w" ( GraphW + 2 ) " h" ( GraphH + 2 ) " 0x1000" ; SS_SUNKEN := 0x1000
	Gui, 1: Add, 		Text, 		xp+1 ym+20 w%GraphW% h%GraphH% hwndhGraph gXGraph_GetVal 0xE, pGraph
	pGraph := XGraph( hGraph, hBM, ColumnW, "1,10,0,00", 0x00FF00, 1, True )

	Gui, 1: Add, 		Text,     	xm     y+3  w%guiControlWidth% h1 0x7
	Gui, 1: Font, 		c808080,
	Gui, 1:	Add,		Text,		xm yp+6 w120 h30 vguiPosition, Opacity`:
	Gui, 1: Add, 		Slider, 	xm+60 yp w100 h20 gEventUpdateTrans vguiSlider Thick10 Range50-255 ToolTip, %startPos%

	Gui, 1: Add, 		Button,   	xm+290 yp   w60 h20 -Theme 0x8000 gEventExit, Close
	
	; hBM := CreateDIB( "E9F5F8|E9F5F8|FFFFFF|FFFFFF|E9F5F8|E9F5F8", 2, 3, 481, 221 )
	; pGraph := XGraph( hGraph, hBM, 5, "1,10,0,10", 0xAF9977, 1 )

	; Gui, 1: Add, StatusBar 
	; SB_SetParts( 100, 100 )
	Gui, 1: Show, 		x%guiX% y%guiY% w%guiWidth% h%guiHeight%, %scriptName%	

	OnMessage(0x201, "WM_LBUTTONDOWN")
	OnMessage(0x219, "WM_DEVICECHANGE")
	OnMessage(0xF, "WM_PAINT")
	
	SetTimer, XGraph_Plot, 1000
	SetTimer, UpdateCPULoad, -1000
	
	; overlay rounded corner region based on current gui width/height
	WinGetPos,,,guiWidth,guiHeight,%scriptName%
	regionWidth 			:= 			(guiWidth - 10)
	regionHeight 			:= 			(guiHeight - 10)
	WinSet, Region, 0-0 W%regionWidth% H%regionHeight% R30-30, %scriptName%	
	
	; set transparency		
	WinSet, Transparent, %startPos%, %scriptName%	

	
Return	


XGraph_GetVal:
	Value := XGraph_GetVal( pGraph ) 
	 If ( Col := ErrorLevel )
	   SB_SetText( "`tColumn : " Col, 1 ), SB_SetText( "`tValue : " Value, 2 ) 
Return

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

; GuiClose:
 ; OnExit
 ; ExitApp

; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

WM_PAINT() {
 IfEqual, A_GuiControl, pGraph, SetTimer, XGraph_Paint, -1
}

; --------------------------------------------------------------------------------------------------------------
; 			EventUpdateTrans
; --------------------------------------------------------------------------------------------------------------
EventUpdateTrans:

	GuiControlGet, curPosition,,guiSlider
	; newTrans 				:= 			(curPosition+155)
	newTrans				:=			curPosition
	WinSet, Transparent, %newTrans%, %scriptName%

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
; ProcessCount ======================================================================
GetProcessCount()
{
    proc := ""
    for process in ComObjGet("winmgmts:\\.\root\CIMV2").ExecQuery("SELECT * FROM Win32_Process")
    {
        proc++
    }
    return proc
}



; --------------------------------------------------------------------------------------------------------------
; 			CPULoad
; --------------------------------------------------------------------------------------------------------------
CPULoad() { ; By SKAN, CD:22-Apr-2014 / MD:05-May-2014. Thanks to ejor, Codeproject: http://goo.gl/epYnkO
Static PIT, PKT, PUT                           ; http://ahkscript.org/boards/viewtopic.php?p=17166#p17166
  IfEqual, PIT,, Return 0, DllCall( "GetSystemTimes", "Int64P",PIT, "Int64P",PKT, "Int64P",PUT )

  DllCall( "GetSystemTimes", "Int64P",CIT, "Int64P",CKT, "Int64P",CUT )
, IdleTime := PIT - CIT,    KernelTime := PKT - CKT,    UserTime := PUT - CUT
, SystemTime := KernelTime + UserTime 

Return ( ( SystemTime - IdleTime ) * 100 ) // SystemTime,    PIT := CIT,    PKT := CKT,    PUT := CUT 
} 
; --------------------------------------------------------------------------------------------------------------
; 			FunctionGuiMove
; --------------------------------------------------------------------------------------------------------------
FunctionGuiMove()
{
	WinGetPos, x1,y1,,, %scriptName%
	; if gui reaches or passes the virtual edge (set in global section), snap it back
	If (x1 >= guiDockRight or y1 >= guiDockBottom)
	{
		; prevent from going past right edge
		If (x1 >= guiDockRight)
		{
			x1 := guiDockRight
		}
		; prevent from going past bottom edge
		If (y1 >= guiDockBottom)
		{
			y1 := guiDockBottom
		}
		WinMove, %scriptName%,,x1,y1
	}
	If (x1 <= guiDockLeftTop or y1 <= guiDockLeftTop)
	{
		; prevent from going past left edge
		If (x1 <= guiDockLeftTop)
		{
			x1 := guiDockLeftTop
		}
		; prevent from going past top edge
		If (y1 <= guiDockLeftTop)
		{
			y1 := guiDockLeftTop
		}
		WinMove, %scriptName%,,x1,y1
	}
}
; --------------------------------------------------------------------------------------------------------------
; 			WM_LBUTTONDOWN
; --------------------------------------------------------------------------------------------------------------
; thanks to j--hn & SKAN
; http://www.autohotkey.com/board/topic/67766-moving-gui-with-caption/
WM_LBUTTONDOWN()
{
	If (A_Gui)
	{
		PostMessage, 0xA1, 2
	}
; 0xA1: WM_NCLBUTTONDOWN, refer to http://msdn.microsoft.com/en-us/library/ms645620%28v=vs.85%29.aspx
; 2: HTCAPTION (in a title bar), refer to http://msdn.microsoft.com/en-us/library/ms645618%28v=vs.85%29.aspx 
}



; --------------------------------------------------------------------------------------------------------------
; 			EventExit							
; --------------------------------------------------------------------------------------------------------------
EventExit:
GuiClose:
GuiEscape:
		GuiControlGet, curPosition,,guiSlider
		; capture GUI position and record it in INI
		WinGetPos, 	guiX, guiY, , ,		%scriptName%
		; do not allow GUI position to be negative
		if (guiX > 0) and (guiY > 0)
		{
			IniWrite,		%guiX%,		%scriptConfig%,		guiMyCPU,		guiX
			IniWrite,		%guiY%,		%scriptConfig%, 	guiMyCPU,		guiY
		}
			IniWrite,		%curPosition%,		%scriptConfig%,		guiMyCPU,		startPos
ExitApp


; where the dead functions dwell

; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - 

; 

; FileAppend, serial %serialNumber%`,%TimeString%`,%L%`n, %app1_output_file%
/*
Loop, read, %app1_output_file%
{
    Loop, parse, A_LoopReadLine, `n
    {
        MsgBox, Field number %A_Index% is %A_LoopField%.
    }
}
*/
/*

LineArray := FileTail(A_ScriptName, 100)
Gui, Add, Text, , % "File: " . A_ScriptName . " -> last " . LineArray.MaxIndex() . " lines."
Gui, Add, Edit, w600 r20, % StrCompose(LineArray)
Gui, Show, , % "FileTail(" . A_ScriptName . ", 100)"
Return

GuiClose:
GuiEscape:
ExitApp

StrCompose(StrArray, Delimiter := "`r`n") {
   String := ""
   For Each, Str In StrArray
      String .= Str . Delimiter
   Return RTrim(String, Delimiter)
}

*/


	; GoTo, XGraph_Plot

; F1::MsgbOx, 0x1040, XGraph, % XGraph_Info( pGraph )                   ; // end of auto-execute section //
; F2::MsgbOx, 0x1040, XGraph - Array, % XGraph_Info( pGraph, "0.2" )
