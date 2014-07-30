; a circular GUI control that commands Lock, Sleep, Shutdown (with an abort), Reset and Command Prompt


Gui, +Toolwindow
Gui, Add, Text, x6 y10 w90 h30 vTime,
Gui, Add, CheckBox, x6 y50 w100 h30 , Show Milliseconds
; Generated using SmartGUI Creator 4.0
Gui, Show, x131 y91 h100 w150, Simple Clock
WinSet, Region , e w140 h90 0-30 , Simple Clock,
return

GuiEscape:
guiclose:
exitapp
