;_____________________________________________________________
;;***********************************************************
; control: double slider for autohotkey
;  author: michael sztolcman  http://siwego.net
;codename: s1w_
;_____________________________________________________________
;;**************************USE******************************
;include this file in your script after autoexecute section
;#Include DoubleSlider.ahk  
;
;- dont forget to include slider folder to script directory
;- do not override system messages 0x111 0x201 0x202 0x20A
;  if they are in use, forward them here with SL_COMMAND() SL_LBUTTONDOWN() SL_LBUTTONUP() SL_MOUSEWHEEL()
;;*************************EXAMPLE***************************

_gui    := 1          ;;gui number
_X      := 0          ;;absolute X
_Y      := 10         ;;absolute Y
_min    := 1          ;;slider min value
_max    := 20         ;;slider max value
_tsize  := 15         ;;space between ticks, preferred 10 <> 20
_bmode  := 1          ;;slider buddy mode [0 | 1 | 2]
_color  := 1          ;;1 - blue; 2- green; 3 - red
_prefix := "Slider_"  ;;prefix for all control components
_nn     := "Edit1"    ;;ClassNN (ID) of some other default control on gui; ID can be found using Window Spy > needed for best repaints


Gui, %_gui%:add, Edit, y60 w30 -Tabstop
                              -WantCtrlA
                              -Wrap
                              -Multi
                              -E0x200 ReadOnly, Focus

                        
sWidth := doubleSlider(_gui,_X,_Y,_min,_max,_tsize,_bmode,_color,_prefix,_nn)

Gui, %_gui%:Show, w%sWidth% h80


val1 := Slider_Left.()    ;return values %_prefix%Left.() and %_prefix%Right.()
val2 := Slider_Right.()

ctrl_disable(_prefix), ctrl_hide(_prefix)  ;;test components visibility
Sleep, 500

ctrl_show(_prefix)
Sleep, 1000

ctrl_enable(_prefix)
TT("Slider " val1 "-" val2 "  Enabled", 2)

Slider_Left.(11), Slider_Right.(16)  ;you can set slider values remotely
Sleep, 500

TT("New values: " Slider_Left.() "-" Slider_Right.(), 1.5)
Tooltip

return
;_____________________________________________________________
;;************************END*EXAMPLE************************

TT(msg, sec) {
  Tooltip % msg
  Sleep % sec * 1000
  Tooltip
}

ctrl_hide(group_name) {
  GUI_action(group_name, "hide")
}

ctrl_show(group_name) {
  GUI_action(group_name, "show")
    Sleep, 20
  GoSub, repaint_range    
}

ctrl_disable(group_name) {
  global hdisabled, prefix
  GUI_action(group_name, "disable")
  GuiControl, , %prefix%Range, % hdisabled
  GoSub, repaint_range    
}

ctrl_enable(group_name) {
  global highlight, prefix
  GUI_action(group_name, "enable")
  GuiControl, , %prefix%Range, % highlight
    Sleep, 20
  GoSub, repaint_range    
}

GUI_action(element, action) {
  WinGet, ActiveControlList, ControlList, A
  Loop, Parse, ActiveControlList, `n
  {
    GuiControlGet, control, Name, %A_LoopField%
    if InStr(control, element) 
    {
      GuiControl, %action%, %control%
    }
  }
}

doubleSlider(gui_ = 1, posX = 30, posY = 10, min_ = 1, max_ = 20, tsize_ = 15, bmode_ = 1, color_ = 1, pref_ = "Slider_", focusNN = "Edit1")
{
  global
  hlc := (color_ = 2 ? "g" : color_ = 3 ? "r" : "b")
  highlight=%A_ScriptDir%\slider\area%hlc%.png
  hdisabled=%A_ScriptDir%\slider\disabled.png
  prefix := pref_

  %prefix%Left  := Func("SetSLLeft")
  %prefix%Right := Func("SetSLRight")
  hi_  := Max(min_,max_)
  low_ := Min(min_,max_)

  ticksize := tsize_
  steps := hi_ - low_ + 1
  
  buddymode := bmode_
  SX := posX + (buddymode > 1 ? ticksize + 10  : 0)
  SY := posY

  focusTaker := focusNN   ;;classNN of the other default control taken by Window Spy - needed for repaints
  btnThick = 15

  sbuttonW := btnThick+4  ;;przyblizona szerokosc przyciskow  ;;Thick15 4 Thick16 7 przy default, a przy Thick15 
  rngXAdd_ := 13
  rngWSub_ := rngXAdd_/2

  SlidersRearrange(2, 1)

  rangeX := SX + rngXAdd_
  rangeY := SY + 6
  rangeH := 5

  ;Gui, gui_:+HwndGuiHwnd ;hwnd for repaint blocking - making problems

  if (buddymode)
  {                   ;slider buddys
    B1X := SX - ticksize/2 + 8
    B2X := SX + rangeW - ticksize/2 + 15
    BY := SY + 26
    BW := ticksize + (buddymode = 1 ? 3 : 10)  ;; ? 2  MODDED
    BH := 11                                            ;;Hidden MODDED 
    Gui, %gui_%:Font, Bold
    Gui, %gui_%:add, Edit, x%B1X% y%BY% w%BW% -Tabstop -WantCtrlA -Wrap -Multi -E0x200 R1 Hidden ReadOnly v%prefix%B1 Center, %low_%
    Gui, %gui_%:add, Edit, x%B2X% y%BY% w%BW% -Tabstop -WantCtrlA -Wrap -Multi -E0x200 R1 Hidden ReadOnly v%prefix%B2 Center, %hi_%
    Gui, %gui_%:Font
    GuiControl, Move, %prefix%B1, h11
    GuiControl, Move, %prefix%B2, h11
  }

  Budd1 := buddymode > 1 ? prefix "B1" : ""
  Budd2 := buddymode > 1 ? prefix "B2" : ""
  
  rnglow := "" low_ "-" low_ + 1
  rnghi  := "" low_ + 1 "-" hi_
  
  ;slider controls
  Gui, %gui_%:add, Slider, x%SX% y%SY% w%slider1W% v%prefix%Slider1 hwndSli1 -Tabstop Hidden grange_bot Thick%btnThick% Range%rnglow% TickInterval1 AltSubmit Buddy1%Budd1%, %low_%
  Gui, %gui_%:add, Slider,  x%slider2X% y%SY% w%slider2W% v%prefix%Slider2 hwndSli2 -Tabstop Hidden grange_top Thick%btnThick% Range%rnghi% TickInterval1 AltSubmit Buddy2%Budd2%, %hi_%

  ;range area
  Gui, %gui_%:Add,Picture, x%rangeX% y%rangeY% w%rangeW% h%rangeH% Hidden v%prefix%Range,%highlight%

  Gui, %gui_%:Submit, Nohide

  handleFocus(2)

  ;*************************

  OnMessage(0x111,"SL_COMMAND")
  OnMessage(0x201,"SL_LBUTTONDOWN") 
  OnMessage(0x202,"SL_LBUTTONUP")
  if (!buddymode)
    OnMessage(0x20A,"SL_MOUSEWHEEL")

  winw := rangeW + 30 + (buddymode > 1 ? ticksize*2 + 20 : 0)
  return winw
}

range_bot:
  currCtrl := A_GuiControl
  if (lastVal = %currCtrl% || forcing || autoclick)
    return
  lastVal := %currCtrl%
  SlidersRearrange(1)
  GoSub, repaint_range
  UpdateBuddy(1)
return

range_top:
  currCtrl := A_GuiControl
  if (lastVal = %currCtrl% || forcing || autoclick)
    return
  lastVal := %currCtrl%
  SlidersRearrange(2)
  GoSub, repaint_range
  UpdateBuddy(2)
return

SlidersRearrange(mod, remote = 0)
{
  global
  sl := mod
  
  if (lastSl = sl)
    return
  if %prefix%Slider1 = 
    %prefix%Slider1 := low_
  if %prefix%Slider2 =
    %prefix%Slider2 := hi_

  GuiControl, Disable, %prefix%Slider%sl%

  rng1 := (sl = 1 ? %prefix%Slider2 - 1 : %prefix%Slider1)
  rng2 := (sl = 2 ? %prefix%Slider1 + 1 : %prefix%Slider2)
  rnglow := "" low_ "-" rng1
  rnghi  := "" rng2 "-" hi_
  GuiControl, +Range%rnghi%, %prefix%Slider2
  GuiControl, +Range%rnglow%, %prefix%Slider1, 
  
  slider1W := (ticksize*Abs(rng1-low_))+sbuttonW
  slider2W := (ticksize*Abs(hi_-rng2))+sbuttonW
  slider2X := slider1W + SX + (ticksize)-sbuttonW
  rangeW := Abs(%prefix%Slider2-%prefix%Slider1)*ticksize-rngWSub_
  
  GuiControl, Move, %prefix%Slider2, x%slider2X% w%slider2W%
  GuiControl, Move, %prefix%Slider1, w%slider1W%

  GuiControl, Enable, %prefix%Slider%sl%

  if !remote
    handleFocus(sl, 1)  ;;;sprawdzic czy logicznie mozna bez mousehook  GetKeyState("LButton", "P") ? 1 : 0
  
  if !lastCtrl
    lastCtrl = %prefix%Slider%sl%

  lastSl := sl
}

repaint_range:
  GuiControlGet, vis, Visible, %prefix%Range
  if (!vis) 
    return
  rangeX := SX+(Abs(low_-%prefix%Slider1)*ticksize)+rngXAdd_
  rangeW := Abs(%prefix%Slider2-%prefix%Slider1)*ticksize-rngWSub_
  GuiControl, MoveDraw, %prefix%Range, % "x" rangeX "w" rangeW 
  ctrl := (!lastSl || lastSl = 2 ? prefix "Slider1" : prefix "Slider2")
  GuiControl, +Redraw, %ctrl%
return

SetSLLeft(val = 0) {
  global
  if !val
    return %prefix%Slider1
  if (%prefix%Slider1 = val)
    return
  else if (%prefix%Slider2 < val)
    val := %prefix%Slider2 - 1
  else if (low_ > val)
    val := low_
  return SetSLValue(1, val)
}

SetSLRight(val = 0) {
  global
  if !val
    return %prefix%Slider2  
  if (%prefix%Slider2 = val)
    return
  else if (%prefix%Slider1 >= val)
    val := %prefix%Slider1 + 1
  else if (hi_ < val)
    val := hi_
  return SetSLValue(2, val)
}

SetSLValue(SL, val)
{
  global
  %prefix%Slider%SL% := lastVal := val
  SlidersRearrange(SL, 1)
  GuiControl,, %prefix%Slider%SL%, %val%
  currCtrl = %prefix%Slider%SL%
  lastCtrl = %prefix%Slider%SL%
  GoSub, repaint_range
  UpdateBuddy(SL)
  return %prefix%Slider%SL%
}

UpdateBuddy(bd)
{
  global
  %prefix%Left14  := %prefix%Slider1  ;;editor mod
  %prefix%Right15 := %prefix%Slider2
  if (buddymode)
  {
    GuiControl,, %prefix%B%bd%, % %prefix%Slider%bd%
    if (buddymode = 1)
    {
      BX:=SX-ticksize/2+8+(Abs(low_-%prefix%Slider%bd%)*ticksize)
      GuiControl, Move, %prefix%B%bd%, x%BX% h11
    }
  }
  else
  {
    Tooltip % %prefix%Slider%bd%
  }
  ;slider_check(bd)  ;;th editor addon
}


GetSysColor( Dis=1, RGB=1, Pre="" ) {
  Static Hex := "123456789ABCDEF0"
  VarSetCapacity( TMV,4,0 ), NumPut(DllCall( "GetSysColor",Int,Dis), TMV ), Ptr:=&TMV-1
  Loop 3
    V%A_Index% := SubStr(Hex, (*++Ptr >> 4), 1) . SubStr(Hex, (*Ptr & 15), 1) 
  return Pre . ( RGB ? V1 V2 V3 : V3 V2 V1 )
}

SL_LBUTTONDOWN()
{
  global
  ;Tooltip, LBUTTON
  if !InStr(prefix "Slider1" prefix "Slider2", A_GuiControl)
    return

  forcing := 1, mdown := 1
  currCtrl := A_GuiControl
  if (lastCtrl != currCtrl)
  {
    ;Tooltip % "Slider " sl " --> " 3-sl
    lastCtrl := A_GuiControl
    BlockInput, MouseMove
    autoclick := 1
    ;Click, up
    Click, down
    autoclick := 0
    ;BlockInput, MouseMoveOff
    SetTimer, mouse_release, -200
  }
  else
  {
    UpdateBuddy(sl)
    GoSub, repaint_range
  }
  forcing := 0
}

mouse_release:
  BlockInput, MouseMoveOff
  ;Tooltip, TIMED RELEASE
return


handleFocus(sl1, mouse = 0)
{
  global
  ;Tooltip, HANDLING FOCUS
  ;if (!hBr_Sli%sl1% || mouse)
  {
    VarSetCapacity( SliRect%sl1%,16,0 )
    DllCall( "GetClientRect", UInt, Sli%sl1%, UInt, &SliRect%sl1%)
    hDC_Sli%sl1% := DllCall( "GetDC", UInt, Sli%sl1% )
    hBr_Sli%sl1% := DllCall("CreateSolidBrush", UInt, GetSysColor(15, False, "0x"))
    if (mouse && mdown) ; && GetKeyState("LButton", "P")
    {
      Sleep 20
      autoclick := 1
      Click, up
      Click, down
      autoclick := 0
    }
    DllCall("FrameRect", UInt, hDC_Sli%sl1%, UInt, &SliRect%sl1%, UInt, hBr_Sli%sl1%) 
    BlockInput, MouseMoveOff
    ;Tooltip, RELEASE
  }
}

SL_LBUTTONUP()  ;needed because WM_COMMAND dont recognize focus lost from focus handled sliders
{
  global prefix, focusTaker, autoclick, lastCtrl, mdown
  mdown := 0
  if (!InStr(prefix "Slider1" prefix "Slider2", A_GuiControl) || autoclick)
    return
  lastCtrl := A_GuiControl
  Tooltip
  ControlFocus, %focusTaker%
  GoSub, repaint_range
}

SL_COMMAND(element)
{
  global
  if (forcing || autoclick)
    return

  if (element)
    ctrlname := element
  else
    GuiControlGet, ctrlname, FocusV   ;;mod editor
  if InStr(prefix "Slider1" prefix "Slider2", ctrlname)  ;;;focus gained -----> and moving
  {
    if (ctrlname = lastCtrl) 
    ;  Tooltip, focus %lastSl% restored
    ;else
    ;  Tooltip, focus gained %ctrlname% lastCtrl %lastCtrl%
    ControlFocus, %focusTaker%
  }
  else if InStr(prefix "Slider1" prefix "Slider2", lastCtrl)  ;;;focus lost
  {
    ;Tooltip, focus lost %lastCtrl%
    ;GoSub, repaint_range
  }
}

SL_MOUSEWHEEL()
{
  global prefix
  if (!InStr(prefix "Slider1" prefix "Slider2", A_GuiControl))
    return
  SetTimer, tt, -1000
}

tt:
  Tooltip
return
