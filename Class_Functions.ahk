/*
	--------------------------------------------------------
	REVISION BLOCK
		
	Project Name: Class_Functions
	Project Author: h0ll0w
	
	Revision History:
	
	Date		  Rev			Change Description
	------------------------------------------------------------------------------------------------------------
	07/23/14	1.0.0		Beta release
	
*/	


; -----------------------------------
;	Function_IniRead
; -----------------------------------	
Function_IniRead(Filename, Section, Key, Default = 0)
{ 
  
  ; store ini value
  returnVar := IniRead(Filename, Section, Key)
  ; check for error 
  if (returnVar == "ERROR")
  {
    Return 0
  }
  ; return ini value
  else 
  {
    Return returnVar
  }  
}

; -----------------------------------
;	Function_GuiMove
; -----------------------------------	
; requires param for scipt name, scipt pos, and 4 screen params
Function_GuiMove(Scriptname, xPos, yPos, xVirtual, yVirtual, wVirtual, hVirtual)
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

; -----------------------------------
;	Function_UpdateTransparency
; -----------------------------------	
Function_UpdateTransparency(transValue, winTitle, MyOpacityMenu="")
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
			If !(MyOpacityMenu)
			{
			  Menu, MyOpacityMenu, ToggleCheck, 20`%
			}
			Return % const20
		}
		If (transValue == "40%" or transValue == const40)
		{
			WinSet, Transparent, %const40%, %winTitle%
			If !(MyOpacityMenu)
			{
				Menu, MyOpacityMenu, ToggleCheck, 40`%
			}
			Return % const40
		}
		If (transValue == "60%" or transValue == const60)
		{
			WinSet, Transparent, %const60%, %winTitle%
			If !(MyOpacityMenu)
			{
				Menu, MyOpacityMenu, ToggleCheck, 60`%
			}
			Return % const60
		}
		If (transValue == "80%" or transValue == const80)
		{
			WinSet, Transparent, %const80%, %winTitle%
			If !(MyOpacityMenu)
			{
				Menu, MyOpacityMenu, ToggleCheck, 80`%
			}
			Return % const80
		}
		If (transValue == "100%" or transValue == const100)
		{
			WinSet, Transparent, %const100%, %winTitle%
			If !(MyOpacityMenu)
			{
				Menu, MyOpacityMenu, ToggleCheck, 100`%
			}
			Return % const100
		}
	}
	; on error, return 0
	catch
	{
		Return 0
	}
}
}

