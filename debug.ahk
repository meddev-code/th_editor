;#SingleInstance Force
;#NoTrayIcon
;SetBatchLines, -1
 
;s1w_'s debug helper
;import this to your script after autoexecute section but additionally run debug.ahk in own instance
;functions: debug(msg, [optional]A_LineNumber) or debug("clear")
  global DebugWindowInstance := 1, ROWS_ := 30
  global debugtitle := "Debug Window", Pause := 0
  WM_VSCROLL := 0x115, SB_BOTTOM := 7
  Gui()
  OnMessage(0x4a, "DebugMonitor")
Return
 
debug(msg_, var_ = "")
{
  static debugmsg
  dhw := A_DetectHiddenWindows
  debugScript := "debug.ahk ahk_class AutoHotkey"
  DetectHiddenWindows On
  if WinExist(debugScript) {
    debugmsg := msg_ "||" var_
    VarSetCapacity(DataStruct, 3*A_PtrSize, 0)
    msgBytes := (StrLen(debugmsg) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(msgBytes, DataStruct, A_PtrSize)
    NumPut(&debugmsg, DataStruct, 2*A_PtrSize)
    ;TimeOutTime := 4000
    SendMessage, 0x4a, 0, &DataStruct,, %debugScript% ;,,,, %TimeOutTime%
  }
  DetectHiddenWindows %dhw%
}
 
#If DebugWindowInstance
DebugMonitor( wParam, lParam )
{
  Global WM_VSCROLL,SB_BOTTOM,Pause
  static varCol := 0
 
  ;Winset, Top,, %debugtitle%
  ;If DllCall("IsWindowVisible", "UInt", WinExist(debugtitle))
  WinGet, min, MinMax, %debugtitle% ahk_class AutoHotkeyGUI
    WinGet id,, %debugtitle%
  if min < 0
    Gui, Show, NoActivate

  
  If ( Pause = 0 )
  {
    addr := NumGet(lParam + 2*A_PtrSize)
    strg := StrGet(addr)
    data1 := StrSplit(strg,"||")[1]
    data2 := StrSplit(strg,"||")[2]
    if (data1 = "clear" && data2 = "")
      GoSub, clear
    else 
    {
      LV_Add( "", data2 ? data2 " :" : "", data1)
      if (data2)
        varCol := 1
      if (!varCol)
        LV_ModifyCol(1, 0)
      else
        LV_ModifyCol(1, "AutoHdr")
      LV_ModifyCol(2, "AutoHdr")
      SendMessage, WM_VSCROLL, SB_BOTTOM, 0, SysListView321, %debugtitle% ahk_class AutoHotkeyGUI
    }
  }
 
}
 
Gui()
{
  Global
  Gui, +LastFound +Resize ;+AlwaysOnTop 
  Gui, Margin, 0, 0
  Gui, Font, s8, Microsoft Sans Serif
  Gui, Color,, DEDEDE
  Gui, Add, ListView, w400 r%ROWS_% vDebugMessages hwndmsgList +Grid +NoSort, line |message
  LV_ModifyCol(1, 0), LV_ModifyCol(2, 310)
  LV_ModifyCol(1, "-Hdr")
  LV_ModifyCol(1, "Right")
  LV_ModifyCol(2, "AutoHdr")
  Gui, Show,, %debugtitle%
}
 
DecToHex( ByRef lParam )
{
  SetFormat, Integer, Hex
  Return lParam += 0
}
#If DebugWindowInstance AND WinActive(debugtitle . " ahk_class AutoHotkeyGUI")
 
GuiSize:
GuiControl, Move, DebugMessages, w%A_GuiWidth% h%A_GuiHeight%
SendMessage, WM_VSCROLL, SB_BOTTOM, 0, SysListView321, %debugtitle% ahk_class AutoHotkeyGUI
LV_ModifyCol(2, "AutoHdr")
Return
 
%%GuiClose:
;ExitApp
Gui, Hide
GuiEscape:
Return
 
;#IfWinActive Debug Window
clear:
  C::
  LV_Delete()
  LV_ModifyCol(1, 0)
  LV_ModifyCol(2, "AutoHdr")
  Return
 
  P::
  Pause :=! Pause, WinTitle := ( Pause = 0 ? debugtitle : debugtitle . " (Paused)" )
  WinSetTitle %WinTitle%
  Return
 
  R::Reload
  H::
  X::
  Gui, Hide
  Return
;#IfWinActive
#If
#If