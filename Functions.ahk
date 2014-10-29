/*
	--------------------------------------------------------
	REVISION BLOCK
		
	Project Name: Functions
	
	Revision History:
	
	Date		  Rev			Change Description
	--------------------------------------------------------
	07/28/14	1.0.0		Beta release
	10/17/14	1.0.1		Updated Function_UpdateTransparency
	10/29/14	1.0.2		Updated comments
		
*/
; ----------------------------------------------------------
; Function .....: Function_Eject
; Description ..: Ejects a Drive
; Author .......: AHK
; Parameters ...: Drive  - Drive Letter
; ----------------------------------------------------------
Function_Eject(Drive)
{
	Try
	{

		hVolume := DllCall("CreateFile"
		    , Str, "\\.\" . Drive
		    , UInt, 0x80000000 | 0x40000000  ; GENERIC_READ | GENERIC_WRITE
		    , UInt, 0x1 | 0x2  ; FILE_SHARE_READ | FILE_SHARE_WRITE
		    , UInt, 0
		    , UInt, 0x3  ; OPEN_EXISTING
		    , UInt, 0, UInt, 0)
		if hVolume <> -1
		{
		    DllCall("DeviceIoControl"
		        , UInt, hVolume
		        , UInt, 0x2D4808   ; IOCTL_STORAGE_EJECT_MEDIA
		        , UInt, 0, UInt, 0, UInt, 0, UInt, 0
		        , UIntP, dwBytesReturned  ; Unused.
		        , UInt, 0)
		    DllCall("CloseHandle", UInt, hVolume)

		}

		Return 1
	}
	Catch
	{

		Return 0
	}
}
; ----------------------------------------------------------
; Function .....: Function_UpdateRegion
; Description ..: Applies a rounded region to a specified window
; Parameters ...: regionW - Region Width
; ..............: regionH - Region Height
; ..............: winTitle - Referencing GUI
; ----------------------------------------------------------
Function_UpdateRegion(regionW, regionH, winTitle)
{
	Try
	{
		WinGetPos,,,guiWidth,guiHeight,%winTitle%
		WinSet, Region, 0-0 W%guiWidth% H%guiHeight% R%regionW%-%regionH%, %winTitle%	
	
		Return 1
	}
	; on error, return 0
	Catch
	{
		Return 0
	}

}
; ----------------------------------------------------------
; Function .....: Function_AlwaysOnTop
; Description ..: Sets window to be always on top
; Parameters ...: newValue - ON | OFF
; ..............: menuName - Referencing Window
; ..............: winTitle - Referencing GUI
; ----------------------------------------------------------
Function_AlwaysOnTop(newValue, menuName, winTitle)
{
	Try
	{
		If (newValue == "ON")
		{
			WinSet, AlwaysOnTop, ON, %winTitle%
			Menu, %menuName%, Check, ON	
			Menu, %menuName%, Uncheck, OFF			
			Return % newValue
		}
		Else
		{
			WinSet, AlwaysOnTop, OFF, %winTitle%
			Menu, %menuName%, Uncheck, ON				
			Menu, %menuName%, Check, OFF
			Return % newValue
		}		
	}
	; on error, return 0
	Catch
	{
		Return 0
	}

}
; ----------------------------------------------------------
; Function .....: Function_UpdateTransparency
; Description ..: Sets window transparency
; Parameters ...: newValue - 20%, 40%, 60%, 100% 
; ..............: menuName - Referencing Window
; ..............: winTitle - Referencing GUI
; ----------------------------------------------------------
Function_UpdateTransparency(newValue, menuName, winTitle)
{

	const20	:=	51
	const40	:=	102	
	const60	:=	153
	const80	:=	204
	const100	:=	255

	Try
	{
		If (newValue == "20%" or newValue == const20)
		{
			WinSet, Transparent, %const20%, %winTitle%
			Menu, %menuName%, Check, 20`%
			Menu, %menuName%, Uncheck, 40`%	
			Menu, %menuName%, Uncheck, 60`%	
			Menu, %menuName%, Uncheck, 80`%	
			Menu, %menuName%, Uncheck, 100`%	
			Return % const20
		}
		If (newValue == "40%" or newValue == const40)
		{
			WinSet, Transparent, %const40%, %winTitle%
			Menu, %menuName%, Uncheck, 20`%
			Menu, %menuName%, Check, 40`%	
			Menu, %menuName%, Uncheck, 60`%	
			Menu, %menuName%, Uncheck, 80`%	
			Menu, %menuName%, Uncheck, 100`%	
			Return % const40
		}
		If (newValue == "60%" or newValue == const60)
		{
			WinSet, Transparent, %const60%, %winTitle%
			Menu, %menuName%, Uncheck, 20`%
			Menu, %menuName%, Uncheck, 40`%	
			Menu, %menuName%, Check, 60`%	
			Menu, %menuName%, Uncheck, 80`%	
			Menu, %menuName%, Uncheck, 100`%	
			Return % const60
		}
		If (newValue == "80%" or newValue == const80)
		{
			WinSet, Transparent, %const80%, %winTitle%
			Menu, %menuName%, Uncheck, 20`%
			Menu, %menuName%, Uncheck, 40`%	
			Menu, %menuName%, Uncheck, 60`%	
			Menu, %menuName%, Check, 80`%	
			Menu, %menuName%, Uncheck, 100`%			
			Return % const80
		}
		If (newValue == "100%" or newValue == const100)
		{
			WinSet, Transparent, %const100%, %winTitle%
			Menu, %menuName%, Uncheck, 20`%
			Menu, %menuName%, Uncheck, 40`%	
			Menu, %menuName%, Uncheck, 60`%	
			Menu, %menuName%, Uncheck, 80`%	
			Menu, %menuName%, Check, 100`%
			Return % const100
		}
		Else
		{
			Return 0
		}
	}
	; on error, return 0
	Catch
	{
		Return 0
	}
	const20 = const40 = const60 = const80 = const100 =
}
; ----------------------------------------------------------
; Function .....: Function_GuiMove
; Description ..: Docks Gui to Window edges
; Parameters ...: winTitle - Referencing GUI
; ..............: xVirtual - 
; ..............: yVirtual -
; ..............: wVirtual -
; ..............: hVirtual -
; ----------------------------------------------------------
Function_GuiMove(winTitle, xVirtual, yVirtual, wVirtual, hVirtual)
{
	WinGetPos, x1,y1,,, %winTitle%
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
		WinMove, %winTitle%,,x1,y1
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
		WinMove, %winTitle%,,x1,y1
	}
}