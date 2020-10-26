DetectHiddenWindows, On
SetTitleMatchMode, 3    ;;;;;po co 2???? zmienione 17.09
;;; przy wylaczeniu czy zamknac skrypt?


APPVERSION := "3.0" ;to potrzebne w trybie LOCKAPPLOCATION := 0 wersja musi byc wieksza niz skryptu głównego, inaczej warning o nieaktualnosci apki
APPFULLNAME := "TH Script Editor"
APPNAME := "Editor"
VERDESC := "integracja z TH script editor"

LOCKAPPLOCATION := 0 ;TU ZROBIĆ DRUGI TRYB GDY APKA NA QSYNCU I BLOKADE CLOUD FOLDER

DIR_API := "ramdisk_api\api\Api-start.ahk" ; LOCKAPPLOCATION ? \..\
DIR_BOOKTABS := "skrypty\booktabs.ahk"
DIR_CHARTZOOM := "skrypty\chartzoom.ahk"
DIR_SYMBOLS := "symbols\Symbols.ahk"

;DIR_SCRIPTS := { "Api-start.ahk":("1|"(DIR_API)), "booktabs.ahk":"2|"(DIR_BOOKTABS), "chartzoom.ahk":"3|"(DIR_CHARTZOOM), "Symbols.ahk":"4|"(DIR_SYMBOLS)}
DIR_SCRIPTS := { (DIR_API):1, (DIR_BOOKTABS):2, (DIR_CHARTZOOM):3, (DIR_SYMBOLS):4 }
BTN_IMPORTS := ["Imports_apiED05", "Imports_bookED06", "Imports_chartED07", "Imports_symED08"]

;zmienne skryptowe
SCRIPT_VARS := {Cross_BigCrossED13: "BigCross", Cross_SmallCrossED14: "SmallCross", Cross_SubCrossED15: "SubCross", Cross_HandCrossED16: "HandCross", Cross_HalfCrossED17: "HalfCross", Adv_warningsSW10: "warnings", Adv_debuglogsSW11: "debuglogs",  Tab_ctrl_tabSW12: "ctrl_tab", Tab_order_tab_reversedSW13: "order_tab_reversed", Order_limit_price_firstSW20: "limit_price_first", Slider_LeftSW14: "slider_left", Slider_RightSW15: "slider_right", Lot_jump_sizeED24: "jump_size", Lot_equalizerSW16: "equalizer", Lot_fast_sizeSW17: "fast_size", Mysz_book_scrollSW21: "book_scroll", Mysz_mysz_midSW22: "mysz_mid"}
VAR_REVERSE := "equalizer|"


;status consts
INACTIVE := 1, ACTIVE := 2, SCRIPT_ERROR := -1

LOGIN_PATTERN := "imie.nazwisko@traderhouse.pl"

BTNLOAD := "Button69"
BTNSLID := "Button39"
TABCTRL := "SysTabControl321"

SHOWLAYER := 0
LAYER_XOFF := 10
LAYER_YOFF := 130
LAYER_W := 27
LAYER_H := 285

EBOX_XOFF := 0
EBOX_YOFF := -62
EBOX_W := 500
EBOX_H := 210

WatcherTriggered := 0
cloudpath := ["THCloud","TH Cloud","TH_Cloud","TH-Cloud","CloudTH","Cloud TH","Cloud_TH","Cloud-TH","Cloud","TH","Qsync","Qsync TH"]
;SEARCHDIR := 1 juz niepotrzebne
red=%A_ScriptDir%\img\red.png
green=%A_ScriptDir%\img\green.png
blue=%A_ScriptDir%\img\blue.png
yellow=%A_ScriptDir%\img\yellow.png
err=%A_ScriptDir%\icon\err.png
okk=%A_ScriptDir%\icon\okk.png
off=%A_ScriptDir%\icon\off.png
exc=%A_ScriptDir%\icon\exc3.png
war=%A_ScriptDir%\icon\war02.png
;chartbtn1=%A_ScriptDir%\img\mousegrab1.jpg
;chartbtn2=%A_ScriptDir%\img\mousegrab2.jpg
crosshair=%A_ScriptDir%\img\crosshair.png
crossoff=%A_ScriptDir%\img\cross.png
chrtico1=%A_ScriptDir%\img\icon1a.png
chrtico2=%A_ScriptDir%\img\icon1b.png
chrtico3=%A_ScriptDir%\img\icon2.png
changes  := 0x0
switches := 0x0
warnings := 0x0
deprecated := 15 ;0x1111 ;0x0
AddonsMenu()

djpeg=djpeg.exe

TT5s := ""
Gui 1:Default
;Gui,+AlwaysOnTop dla layeru sie krzaczy
Gui,Font,Normal s14 c0x0 Bold,Tahoma
Gui,Add,Text,x40 y20 w300 h24,TH script editor
Gui,Font
Gui,Font,Normal s7 c0x808080 Bold,Tahoma
Gui,Add,Text,x200 y30 w40 h13 c0x808080,v%APPVERSION%
Gui,Font

Gui,Add,Picture,x15 y54 w25 h25 Hidden vGreen_i,%okk% 
Gui,Add,Picture,x15 y54 w25 h25 Hidden vRed_i,%err%
Gui,Add,Picture,x15 y54 w25 h25 Hidden vBlue_i,%off%
Gui,Add,Picture,x39 y49 w208 h35 Hidden vGreen_b,%green%
Gui,Add,Picture,x39 y49 w208 h35 Hidden vRed_b,%red%
Gui,Add,Picture,x39 y49 w208 h35 Hidden vBlue_b,%blue%
ImportScriptBtn_R := ImportScriptBtn_D := "Podłącz skrypt PPRO8.ahk"
Gui,Add,Button,x40 y50 w206 h33 0x1 0x8000 -Wrap Default vImportScriptBtn gregister_script,%ImportScriptBtn_R%
eTRADER_ED01_R := eTRADER_ED01_D := ""
eTRADER_ED01_itt := "ID musi być 8-literowe"
eTRADER_ED01_pattern := "^[A-Za-z]{8}$"
Gui,Add,Picture,x271 y59 w101 h22 Hidden vRed_eTRADER_ED01,%red%
Gui,Add,Edit,x272 y60 w99 h20 -WantReturn -WantCtrlA -Wrap Limit Uppercase Disabled hwndetrader gdata_check veTRADER_ED01,%eTRADER_ED01_R%  ;gdata_check 
Gui,Add,Text,x272 y42 w75 h13,Identyfikator

RegRead, regtab, HKEY_CURRENT_USER, Software\TraderHouse\script, Tab
if (regtab)
{
  tabchoosen := "Choose" regtab
}

Gui,Add,Tab,x10 y110 w435 h310 %tabchoosen% Left Buttons 0x8000 -Wrap vCurrentTab gtab_change AltSubmit,Trader|Imports|API  |Books|Skróty|Tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui,Tab,1
Gui,Add,GroupBox,x70 y110 w320 h190 Disabled vTrader_group,Dane Tradera
Gui,Add,Text,x90 y132 w120 h13 Disabled vTrader_txt1,Login
Trader_loginED02_E := "@traderhouse.pl"
Trader_loginED02_R := Trader_loginED02_D := "@traderhouse.pl"
Trader_loginED02_T := "E-mail logujący"
Trader_loginED02_itt := "Popraw maila"
Trader_loginED02_pattern := "i)^[\w-]+@[\w-]+\.[a-z]{2,}$"
Gui,Add,Picture,x89 y149 w172 h23 Hidden vRed_Trader_loginED02,%red%
Gui,Add,Edit,x90 y150 w170 h21 Border cSilver -WantCtrlA Disabled vTrader_loginED02 gdata_check,%Trader_loginED02_E%
Trader_autologinSW01_R := Trader_autologinSW01_D := 1                ;<--------------------------------------------------------------------------
Trader_autologinSW01_T := "Logować automatycznie po wpisaniu początkowych liter?"
Gui,Add,Checkbox,x100 y180 w100 h13 Checked Disabled vTrader_autologinSW01 gswitch_check,Autologin
Trader_reloadSW02_R := Trader_reloadSW02_D := 1
Trader_reloadSW02_T := "Przeładowywać skrypt po włączeniu prospera?"
Gui,Add,Checkbox,x100 y200 w100 h13 Checked Disabled vTrader_reloadSW02 gswitch_check,Przeładowanie
Trader_passED03_itt := "Wprowadź hasło"
Trader_passED03_R := Trader_passED03_D := ""
;;PATTERN DLA HASLA PROSPER
Gui,Add,Picture,x89 y249 w172 h23 Hidden vRed_Trader_passED03,%red%
Gui,Add,Edit,x90 y250 w130 h21 Password Border Disabled vTrader_passED03 gdata_check,
Gui,Add,Text,x90 y232 w120 h13 Disabled vTrader_txt2,Hasło
Trader_logADR03_R := Trader_logADR03_D := 3
Gui,Add,DropDownList,x220 y180 w40 Disabled Choose2 vTrader_logADR03 gswitch_check,4|3|2|1
Gui,Add,Text,x267 y184 w90 h13 Disabled vTrader_txt3,Litery aktywacji
Trader_pasADR04_R := Trader_pasADR04_D := 3
Gui,Add,DropDownList,x220 y250 w40 Disabled Choose2 vTrader_pasADR04 gswitch_check,4|3|2|1
Gui,Add,Text,x267 y254 w90 h13 Disabled vTrader_txt4,Litery aktywacji
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui,Tab,2
CloudBtnED04_T := "Wskaż folder 'AutoHotKey' na TH Cloud"
CloudBtnED04_R := CloudBtnED04_D := "-->  AutoHotKey na Qsync"
CloudBtnED04_itt := "Zły odnośnik do 'AutoHotKey' na TH Cloud - nie znaleziono skryptów"
Gui,Add,Picture,x79 y111 w212 h25 Hidden vYellow_CloudBtnED04,%yellow%
Gui,Add,Picture,x79 y111 w212 h25 Hidden vRed_CloudBtnED04,%red%
Gui,Add,Button,x80 y112 w210 h23 0x8000 Disabled vCloudBtnED04 grelink_cloud_folder,%CloudBtnED04_R%
Gui,Add,Button,x330 y112 w70 h23 0x8000 Disabled vRawBtn gmanual_imports,Ręcznie
Gui,Add,GroupBox,x70 y150 w340 h165 Disabled vImports_group,Importy
Gui,Add,Text,x309 y151 w42 h13 Disabled vImports_gtxt1,Aktywny
Imports_apiED05_T := "Podłącz skrypt Api-start.ahk"
Imports_apiED05_R := Imports_apiED05_D := DIR_API
Imports_apiED05_itt := "Nie znaleziono pliku -> podłącz skrypt Api-start.ahk"
Gui,Add,Picture,x89 y178 w192 h25 Hidden vYellowB_Imports_apiED05,%yellow%
Gui,Add,Picture,x89 y178 w192 h25 Hidden vRed_Imports_apiED05,%red%
Gui,Add,Button,x90 y179 w190 h23 0x8000 Disabled vImports_apiED05 grelink_import,%Imports_apiED05_R%
Gui,Add,Picture,x253 y181 w19 h17 Hidden vYellowI_Imports_apiED05,%exc%   ;x96
Imports_bookED06_T := "Podłącz skrypt booktabs.ahk"
Imports_bookED06_R := Imports_bookED06_D := DIR_BOOKTABS
Imports_bookED06_itt := "Nie znaleziono pliku -> podłącz skrypt booktabs.ahk"
Gui,Add,Picture,x89 y209 w192 h25 Hidden vYellowB_Imports_bookED06,%yellow%
Gui,Add,Picture,x89 y209 w192 h25 Hidden vRed_Imports_bookED06,%red%
Gui,Add,Button,x90 y210 w190 h23 0x8000 Disabled vImports_bookED06 grelink_import,%Imports_bookED06_R%
Gui,Add,Picture,x253 y212 w19 h17 Hidden vYellowI_Imports_bookED06,%exc%   ;x96
Imports_chartED07_T := "Podłącz skrypt chartzoom.ahk"
Imports_chartED07_R := "S:\chartzoom.ahk"
Imports_chartED07_D := DIR_CHARTZOOM
Imports_chartED07_itt := "Nie znaleziono pliku -> podłącz skrypt chartzoom.ahk"
Gui,Add,Picture,x89 y240 w192 h25 Hidden vYellowB_Imports_chartED07,%yellow%
Gui,Add,Picture,x89 y240 w192 h25 Hidden vRed_Imports_chartED07,%red%
Gui,Add,Button,x90 y241 w190 h23 0x8000 Disabled hwndimportsBtn3 vImports_chartED07 grelink_import,%Imports_chartED07_R%
Gui,Add,Picture,x253 y243 w19 h17 Hidden vYellowI_Imports_chartED07,%exc%   ;x96
Imports_symED08_T := "Podłącz skrypt Symbols.ahk"
Imports_symED08_R := Imports_symED08_D := DIR_SYMBOLS
Imports_symED08_itt := "Nie znaleziono pliku -> podłącz skrypt Symbols.ahk"
Gui,Add,Picture,x89 y271 w192 h25 Hidden vYellowB_Imports_symED08,%yellow%
Gui,Add,Picture,x89 y271 w192 h25 Hidden vRed_Imports_symED08,%red%
Gui,Add,Button,x90 y272 w190 h23 0x8000 Disabled hwndEBtn1 vImports_symED08 grelink_import,%Imports_symED08_R%
Gui,Add,Picture,x253 y274 w19 h17 Hidden vYellowI_Imports_symED08,%exc%   ;x96
Imports_apiSW05_R := Imports_apiSW05_D := 1
Gui,Add,Checkbox,x309 y184 w15 h13 Checked Disabled vImports_apiSW05 gswitch_check,
Imports_bookSW06_R := Imports_bookSW06_D := 1
Gui,Add,Checkbox,x309 y215 w15 h13 Checked Disabled vImports_bookSW06 gswitch_check,
Imports_chartSW07_R := Imports_chartSW07_D := 0
Imports_chartSW07_T := "Narzędzie tylko dla wykresów PPRO8"
Gui,Add,Checkbox,x309 y246 w15 h13 Disabled vImports_chartSW07 gswitch_check,
Imports_symSW08_R := Imports_symSW08_D := 1
Gui,Add,Checkbox,x309 y277 w15 h13 Checked Disabled vImports_symSW08 gswitch_check,

Imports_apiED05_BTNUpdate_T := "Aktualizuj skrypt Api-start.ahk"
Gui,Add,Custom,ClassButton x350 y176 w28 h28 0xE Hidden Disabled hwndhuBtn1 vImports_apiED05_BTNUpdate gupdate_script,R
Imports_bookED06_BTNUpdate_T := "Aktualizuj skrypt booktabs.ahk"
Gui,Add,Custom,ClassButton x350 y207 w28 h28 0xE Hidden Disabled hwndhuBtn2 vImports_bookED06_BTNUpdate gupdate_script,R
Imports_chartED07_BTNUpdate_T := "Aktualizuj skrypt chartzoom.ahk"
Gui,Add,Custom,ClassButton x350 y238 w28 h28 0xE Hidden Disabled hwndhuBtn3 vImports_chartED07_BTNUpdate gupdate_script,R
Imports_symED08_BTNUpdate_T := "Aktualizuj skrypt Symbols.ahk"
Gui,Add,Custom,ClassButton x350 y269 w28 h28 0xE Hidden Disabled hwndhuBtn4 vImports_symED08_BTNUpdate gupdate_script,R

imagefile := "shell32.dll"
numicon   := 239
VarSetCapacity(btn_imagelist, A_PtrSize+20, 0)
il := IL_Create(1)
IL_Add(il, imagefile, numicon)
IL_Add(il, imagefile, numicon)
IL_Add(il, imagefile, numicon)
IL_Add(il, imagefile, numicon)
IL_Add(il, imagefile, numicon)
;IL_Add(il, "InstAll.ico")

Numput(il, btn_imagelist, 0, "ptr")
SendMessage, 0x1602, 0, &btn_imagelist,, ahk_id %huBtn1%
SendMessage, 0x1602, 0, &btn_imagelist,, ahk_id %huBtn2%
SendMessage, 0x1602, 0, &btn_imagelist,, ahk_id %huBtn3%
SendMessage, 0x1602, 0, &btn_imagelist,, ahk_id %huBtn4%


Gui,Add,GroupBox,x50 y330 w385 h90 vCharts_group Hidden,Opcje ChartZoom
;-----------------------------------------------------

  pToken:=Gdip_Startup()

;Gui,Add,Custom,ClassButton x60 y351 w28 h28 Disabled vImports_updateApi gupdate_script,R
Charts_CrossED09_R := Charts_CrossED09_D := (152 - (!RegExMatch(A_OSVersion, "^10\.") ? 2 : 0)) "," (44 - (!RegExMatch(A_OSVersion, "^10\.") ? 8 : 0)) ;if A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME,WIN_VISTA
Charts_CrossED09_L := Charts_CrossED09_R

Charts_Cross_Btn_T := "Wskaż ikonę 'CrossCursor' w okienku wykresu"   ;wskaz srodek ikony
Gui,Add,Button, x60 y351 w36 h30 -Tabstop hwndbtnC1 vCharts_Cross_Btn Hidden gselect_chart_icon,
;Gui,Add,Picture,x100 y351 w40 h40 hwndCharts_icon vCharts_icon,%chartbtn1%
;ILButton(btnC1, chartbtn1, cx=200, cy=351 align=4, margin="1,1,1,1")
;Ext_Image(btnC1, chartbtn2)


   p2Bitmap := charts_set(1) ;Gdip_CreateBitmapFromFile(FileExist(chartbtn1) ? chartbtn1 : crossoff)  
   h2Bitmap := Gdip_CreateHBITMAPFromBitmap(Gdip_CropImage(p2Bitmap, 5, 4, 20, 22))

   
  ; SetImage(btnC1, hBitmap)  
Ext_Image(btnC1, h2Bitmap)

   DeleteObject(h2Bitmap)
   Gdip_DisposeImage(p2Bitmap)   
;Gdip_Shutdown(pToken)
;Gui, Add, Button, x+10 h40 w40 vStates hwndhBtn, pushbuttonstates  ;<--------working
;ILButton(hBtn, "mousegrab.bmp", 40, 40, "top", "0 5")              ;<--------working only for bmp

Gui,Add,Text,x104 y355 w126 h30 vCharts_txt1 Hidden,Wskaż ikonę      lub
Gui,Add,Picture,x168 y355 w14 h14 vCharts_txtico1 Hidden, %chrtico1%
Gui,Add,Picture,x200 y355 w14 h14 vCharts_txtico2 Hidden, %chrtico2%

;Gui,Font,s6 
;Gui,Add,Text,x104 y370 w25 h15 +BackgroundTrans Disabled vCharts_Cross09 Center, 
;Gui,Add,Edit, x104 y369 w40 h20 -Tabstop -WantCtrlA -Wrap -Multi -E0x200 R1 Hidden Disabled ReadOnly vCharts_Cross_coords Center, %Charts_Cross_coords09_R%
;Gui,Font

;-----------------------------------------------------
Charts_ZoomED10_R := Charts_ZoomED10_D := (172 - (!RegExMatch(A_OSVersion, "^10\.") ? 2 : 0)) "," (44 - (!RegExMatch(A_OSVersion, "^10\.") ? 8 : 0))
Charts_ZoomED10_L := Charts_ZoomED10_R

Charts_Zoom_Btn_T := "Wskaż ikonę lupy (+) w okienku wykresu"   ;wskaz srodek ikony
Gui,Add,Button, x232 y351 w36 h30 -Tabstop hwndbtnC2 vCharts_Zoom_Btn Hidden gselect_zoom_icon,


p2Bitmap := charts_set(2) ;Gdip_CreateBitmapFromFile(FileExist(chartbtn2) ? chartbtn2 : crossoff)  
h2Bitmap := Gdip_CreateHBITMAPFromBitmap(Gdip_CropImage(p2Bitmap, 5, 4, 20, 22))

Ext_Image(btnC2, h2Bitmap)

DeleteObject(h2Bitmap)
Gdip_DisposeImage(p2Bitmap)   

Gui,Add,Text,x276 y355 w126 h30 vCharts_txt2 Hidden,Wskaż ikonę lupy (+)
Gui,Add,Picture,x378 y355 w14 h14 vCharts_txtico3 Hidden, %chrtico3%

;Gui,Font,s6
;Gui,Add,Text,x276 y370 w25 h15 +BackgroundTrans Disabled vCharts_Zoom10 Center,
;Gui,Font

Gui,Font,s7 c0x222222
Gui,Add,Text,x60 y386 w364 h28 +BackgroundTrans Disabled vChartstxt3 Hidden,ZOOM: Scroll lub (num)+/-   CROSSHAIR: Space(hold)   ->BOOK: NumLock  MINIMIZE: NumpadDiv        MAXIMIZE: NumpadMult
Gui,Font

/*
Charts_ED09_R := 110
Charts_ED09_T := "wyznacz punkt w środku pierwszej ikony okienka wykresu"
Charts_ED09_ := { min: 100, max: 120 }
min := Charts_ED09_["min"]
max := Charts_ED09_["max"]
Charts_ED09_itt := "Wartość poza zakresem:" min "-" max
Gui,Add,Picture,x59 y350 w42 h22 Hidden vRed_Charts_ED09,%red%
Gui,Add,Edit,x60 y351 w40 h20 vCharts_ED09 gdata_check Hidden Number Limit,%Charts_ED09_R%
Charts_ud1_T := Charts_ED09_T
Gui,Add,UpDown,Range%min%-%max% vCharts_ud1 Hidden,%Charts_ED09_R%
Charts_ED10_R := 40
Charts_ED10_T := "wyznacz punkt w środku linii ikon okienka wykresu"
Charts_ED10_ := { min: 30, max: 50 }
min := Charts_ED10_["min"]
max := Charts_ED10_["max"]
Charts_ED10_itt := "Wartość poza zakresem:" min "-" max
Gui,Add,Picture,x59 y383 w42 h22 Hidden vRed_Charts_ED10,%red%
Gui,Add,Edit,x60 y384 w40 h20 vCharts_ED10 gdata_check Hidden Number Limit,%Charts_ED10_R%
Charts_ud2_T := Charts_ED10_T
Gui,Add,UpDown,Range30-50 vCharts_ud2 Hidden,%Charts_ED10_R%
Charts_ED11_R := 3
Charts_ED11_ := { min: 1, max: 20 }
min := Charts_ED11_["min"]
max := Charts_ED11_["max"]
Charts_ED11_itt := "Wartość poza zakresem:" min "-" max
Gui,Add,Picture,x237 y350 w39 h22 Hidden vRed_Charts_ED11,%red%
Gui,Add,Edit,x238 y351 w37 h20 vCharts_ED11 gdata_check Hidden Number Limit,%Charts_ED11_R%
Gui,Add,UpDown,Range1-20 vCharts_ud3 Hidden,%Charts_ED11_R%
Charts_ED12_R := 4
Charts_ED12_ := { min: 1, max: 20 }
min := Charts_ED12_["min"]
max := Charts_ED12_["max"]
Charts_ED12_itt := "Wartość poza zakresem:" min "-" max
Gui,Add,Picture,x237 y383 w39 h22 Hidden vRed_Charts_ED12,%red%
Gui,Add,Edit,x238 y384 w37 h20 vCharts_ED12 gdata_check Hidden Number Limit,%Charts_ED12_R%
Gui,Add,UpDown,Range1-20 vCharts_ud4 Hidden,%Charts_ED12_R%
Gui,Add,Text,x106 y351 w126 h30 vCharts_txt1 Hidden,Pozycja pierwszej ikony w pikselach od lewej
Gui,Add,Text,x106 y384 w126 h30 vCharts_txt2 Hidden,Poziom ikon w pikselach od góry
Gui,Add,Text,x280 y351 w145 h30 vCharts_txt3 Hidden,Kolejność ikony "CrossCursor" od lewej
Gui,Add,Text,x280 y384 w115 h30 vCharts_txt4 Hidden,Kolejność lupy (+)
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui,Tab,3
Gui,Add,GroupBox,x70 y110 w165 h139 Disabled vCross_group,Cross
Cross_BigCrossED13_R := Cross_BigCrossED13_D := 40
Cross_BigCrossED13_ := { min: 20, max: 100 }
min := Cross_BigCrossED13_["min"]
max := Cross_BigCrossED13_["max"]
Cross_BigCrossED13_itt := "Cross poza zakresem:" min "-" max
Gui,Add,Edit,x81 y130 w25 h18 -E0x200 Border Number Limit Disabled vCross_BigCrossED13 gdata_check,%Cross_BigCrossED13_R%
Cross_SmallCrossED14_R := Cross_SmallCrossED14_D := 3
Cross_SmallCrossED14_ := { min: 0, max: 40 }
min := Cross_SmallCrossED14_["min"]
max := Cross_SmallCrossED14_["max"]
Cross_SmallCrossED14_itt := "Cross poza zakresem:" min "-" max
Gui,Add,Edit,x81 y153 w25 h18 Number Limit Border -E0x200 Disabled vCross_SmallCrossED14 gdata_check,%Cross_SmallCrossED14_R%


Cross_SubCrossED15_R := Cross_SubCrossED15_D := 3
Cross_SubCrossED15_T := "Dla spółek o wartości poniżej dolara"
Cross_SubCrossED15_ := { min: 0, max: 40 }
min := Cross_SubCrossED15_["min"]
max := Cross_SubCrossED15_["max"]
Cross_SubCrossED15_itt := "Cross poza zakresem:" min "-" max
Gui,Add,Edit,x81 y176 w25 h18 Border Number Limit -E0x200 Disabled vCross_SubCrossED15 gdata_check,%Cross_SubCrossED15_R%


Cross_HandCrossED16_R := Cross_HandCrossED16_D := 3
Cross_HandCrossED16_ := { min: 0, max: 40 }
min := Cross_HandCrossED16_["min"]
max := Cross_HandCrossED16_["max"]
Cross_HandCrossED16_itt := "Cross poza zakresem:" min "-" max
Gui,Add,Edit,x81 y199 w25 h18 Border Number Limit -E0x200 Disabled vCross_HandCrossED16 gdata_check,%Cross_HandCrossED16_R%


Cross_HalfCrossED17_R := Cross_HalfCrossED17_D := 3
;Cross_HalfCrossED17_T := "nie istotny dla operacji specialnych (bezcenowych)"
Cross_HalfCrossED17_ := { min: 0, max: 40 }
min := Cross_HalfCrossED17_["min"]
max := Cross_HalfCrossED17_["max"]
Cross_HalfCrossED17_itt := "Cross poza zakresem:" min "-" max
Gui,Add,Edit,x81 y222 w25 h18 Border Number Limit -E0x200 Disabled vCross_HalfCrossED17 gdata_check,%Cross_HalfCrossED17_R%
Gui,Add,Text,x115 y132 w100 h13 Disabled vCross_txt1,Wyjście dla edka
Gui,Add,Text,x115 y155 w100 h13 Disabled vCross_txt2,Wejście dla edka
Gui,Add,Text,x115 y178 w100 h13 Disabled vCross_txt3,Poniżej dolara (sub)
Cross_txt3_T := "Dla spółek o wartości poniżej dolara"
Gui,Add,Text,x115 y201 w100 h13 Disabled vCross_txt4,Zlecenia z ręki (api)
Gui,Add,Text,x115 y224 w100 h13 Disabled vCross_txt5,Wyjście częścią  ;Wychodzenie 
;Cross_txt4_T := Cross_HalfCross16_T

Gui,Add,GroupBox,x70 y260 w165 h155 Disabled vHalf_group,Wychodzenie częścią akcji
Half_one_outED18_R := Half_one_outED18_D := "<"
Gui,Add,Button,x81 y285 w30 h21 0x8000 Disabled vHalf_one_outED18 gbind_key,%Half_one_outED18_R%
Half_half_outED19_R := Half_half_outED19_D := "/"
Gui,Add,Button,x81 y313 w30 h21 0x8000 Disabled vHalf_half_outED19 gbind_key,%Half_half_outED19_R%
Half_third_outED20_R := Half_third_outED20_D := ">"
Gui,Add,Button,x81 y341 w30 h21 0x8000 Disabled vHalf_third_outED20 gbind_key,%Half_third_outED20_R%
Gui,Add,Text,x119 y289 w90 h13 Disabled vHalf_txt1,Jedna trzecia
Gui,Add,Text,x119 y317 w90 h13 Disabled vHalf_txt2,Połowa
Gui,Add,Text,x119 y345 w90 h13 Disabled vHalf_txt3,Dwie trzecie
Gui,Add,Text,x90 y370 w110 h13 Disabled vHalf_txt4,Operacje
;Half_defaultRB09_R := 1
Gui,Add,Radio,x81 y388 w70 h16 0x1000 Checked Disabled vHalf_defaultRB09 gswitch_check,domyślne
;Half_specialRB09_R := 0
Gui,Add,Radio,x151 y388 w70 h16 0x1000 Disabled vHalf_specialRB09 gswitch_check,specjalne

Half_RB_R := Half_RB_D := 1
Half_RB := ["Half_defaultRB09", "Half_specialRB09"]

Gui,Add,GroupBox,x250 y110 w165 h80 Disabled vDef_group,Domyślne Operacje z Ręki
Def_BuyED21_R := Def_BuyED21_D := "F4"
Gui,Add,Button,x261 y130 w30 h21 0x8000 Disabled vDef_BuyED21 gbind_key,%Def_BuyED21_R%
Def_SellED22_R := Def_SellED22_D := "F8"
Gui,Add,Button,x261 y160 w30 h21 0x8000 Disabled vDef_SellED22 gbind_key,%Def_SellED22_R%
Gui,Add,Text,x299 y133 w90 h13 Disabled vDef_txt1,Long
Gui,Add,Text,x299 y163 w90 h13 Disabled vDef_txt2,Short

Gui,Add,GroupBox,x250 y200 w165 h120 Disabled vSpec_group,Specjalne Operacje z Ręki*
Spec_txt1_T := "zalecane do wychodzenia częścią!"
Gui,Font,s7 c0x222222
;Gui, Add, Text,x259 y221 w145 h28 0x12,
Gui,Add,Text,x263 y221 w140 h28 +BackgroundTrans Disabled vSpe_c_txt1,zlecenia bezcenowe w PPRO8; zalecany Parallel-2D
Gui,Font
Spec_BuyED23_R := Spec_BuyED23_D := "+F4"
Spec_BuyED23_T := "KeyboardSetup:  ncsa - nasdaq/nyse - byx  >  shift+F4  >  [Buy->Short][Parallel-2D][Market][DAY]"
Gui,Add,Button,x261 y257 w30 h21 0x8000 Disabled vSpec_BuyED23 gbind_key,%Spec_BuyED23_R%
TT5s := TT5s "|Spec_Buy"
Spec_SellED24_R := Spec_SellED24_D := "+F8"
Spec_SellED24_T := "KeyboardSetup:  ncsa - nasdaq/nyse - byx  >  shift+F8  >  [Sell->Short][Parallel-2D][Market][DAY]"
Gui,Add,Button,x261 y287 w30 h21 0x8000 Disabled vSpec_SellED24 gbind_key,%Spec_SellED24_R%
TT5s := TT5s "|Spec_Sell"
Gui,Add,Text,x300 y261 w90 h13 Disabled vSpec_txt2,Market buy
Gui,Add,Text,x300 y291 w90 h13 Disabled vSpec_txt3,Market sell->short

GuiControlGet, def1,,Def_BuyED21, Text
GuiControlGet, def2,,Def_SellED22, Text
GuiControlGet, spec1,,Spec_BuyED23, Text
GuiControlGet, spec2,,Spec_SellED24, Text
Half_defaultSW09_T = korzystaj z domyślnych operacji %def1%/%def2%                                                            ;;<--------------------uwzglednic przy import values i zmianie bindow
Half_specialSW09_T = korzystaj ze specjalnych operacji %spec1%/%spec2%

Gui,Add,GroupBox,x250 y350 w165 h65 Disabled vAdv_group,Zaawansowane
;Gui,Add,Checkbox,x260 y350 w145 h13 Disabled vAdv_limit_price_first,Zaznaczaj limit price
Adv_warningsSW10_R := Adv_warningsSW10_D := 1
Adv_warningsSW10_T := "Pokazuj błędy w tooltipie"
Gui,Add,Checkbox,x260 y370 w135 h13 Checked Disabled vAdv_warningsSW10 gswitch_check,Informuj o błędach api
Adv_debuglogsSW11_R := Adv_debuglogsSW11_D := 0
Adv_debuglogsSW11_T := "Zrzuć wiecej logów na ramdisk"
Gui,Add,Checkbox,x260 y390 w135 h13 Disabled vAdv_debuglogsSW11 gswitch_check,More logs (debug)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui,Tab,4

/*
Gui,Add,GroupBox,x70 y110 w200 h47 Disabled vTab_group,Tabowanie
Tab_ctrl_tab12_R := 1
Tab_ctrl_tab12_T := "TAB ma zmieniać booki?"
Gui,Add,Checkbox,x80 y130 w180 h16 0x1000 Checked Disabled vTab_ctrl_tab12 gswitch_check,Przeskakiwanie booków
*/

Gui,Add,GroupBox,x70 y110 w200 h85 Disabled vTab_group,Tabowanie
Tab_ctrl_tabSW12_R := Tab_ctrl_tabSW12_D := 1
Tab_ctrl_tabSW12_T := "TAB ma zmieniać booki?"
Gui,Add,Checkbox,x80 y130 w180 h13 Checked Disabled vTab_ctrl_tabSW12 gswitch_check,Przeskakiwanie po bookach
Tab_order_tab_reversedSW13_R := Tab_order_tab_reversedSW13_D := 1
Gui,Add,Checkbox,x80 y150 w180 h13 Checked Disabled vTab_order_tab_reversedSW13 gswitch_check,Odwróć taba w panelu order
Order_limit_price_firstSW20_R := Order_limit_price_firstSW20_D := 0
Order_limit_price_firstSW20_T := "Po otwarciu okienka order -> focus na limit price"
Gui,Add,Checkbox,x80 y170 w180 h13 Disabled vOrder_limit_price_firstSW20 gswitch_check,Limit price pierwsze

/*
Gui,Add,GroupBox,x280 y110 w345 h66 Disabled vOrder_group,Order Panel
Order_limit_price_first19_R := 0
Order_limit_price_first19_T := "Po otwarciu okienka order -> focus na limit price"
Gui,Add,Checkbox,x290 y130 w125 h13 Disabled vOrder_limit_price_first19 gswitch_check,Limit price pierwsze
Tab_order_tab_reversed20_R := 1
Gui,Add,Checkbox,x290 y152 w180 h13 Checked Disabled vTab_order_tab_reversed20 gswitch_check,Odwróć taba
*/

Gui,Add,GroupBox,x70 y207 w200 h52 Disabled vCyfry_group,Cyfry
Cyfry_SRB13_R := Cyfry_SRB13_D := 1
Cyfry_SRB13_T := "Cyfry działają normalnie"
Gui,Add,Radio,x80 y227 w59 h18 0x1000 Disabled vCyfry_SRB13 AltSubmit Checked gtrigger_cyfry,Standard
Cyfry_BRB13_R := Cyfry_BRB13_D := 0
Cyfry_BRB13_T := "Cyfry przenoszą na booki"
Gui,Add,Radio,x139 y227 w59 h18 0x1000 Disabled vCyfry_BRB13 AltSubmit gtrigger_cyfry,Book
Cyfry_LRB13_R := Cyfry_LRB13_D := 0
Cyfry_LRB13_T := "Cyfry ustawiają 'Override Lot Size'"
Gui,Add,Radio,x198 y227 w59 h18 0x1000 Disabled vCyfry_LRB13 AltSubmit gtrigger_cyfry,Lot Size

Cyfry_RB_R := Cyfry_RB_D := 1
Cyfry_RB := ["Cyfry_SRB13", "Cyfry_BRB13", "Cyfry_LRB13"]

Gui,Font,s7 c0x222222
Gui,Add,Text,x284 y211 w76 h13 Right Hidden vSlider_txt1,Aktywny zakres
Gui,Font

Slider_LeftSW14_R := Slider_LeftSW14_D := 1
Slider_RightSW15_R := Slider_RightSW15_D := 10
doubleSlider(1,277,229,Slider_LeftSW14_R,Slider_RightSW15_R,12,1,1,"Slider_",BTNSLID)


Gui,Add,GroupBox,x70 y272 w200 h143 Disabled vLot_group,Quick Lot Size
Lot_jump_sizeED24_R := Lot_jump_sizeED24_D := 50
Lot_jump_sizeED24_T := "Jakim sizem zmieniać Override Lot Size"
Lot_jump_sizeED24_ := { min: 10, max: 1000 }
min := Lot_jump_sizeED24_["min"]
max := Lot_jump_sizeED24_["max"]
Lot_jump_sizeED24_D := 10
Lot_jump_sizeED24_itt := "Cross poza zakresem:" min "-" max
Gui,Add,Edit,x80 y293 w28 h18 Border Number Limit -E0x200 Disabled vLot_jump_sizeED24 gdata_check,%Lot_jump_sizeED24_R%
Gui,Add,Text,x116 y297 w145 h13 Disabled vLot_txt1,Skok "Override Lot Size"
Lot_equalizerSW16_R := Lot_equalizerSW16_D := 1
Gui,Add,Checkbox,x80 y320 w180 h13 Checked Disabled vLot_equalizerSW16 gswitch_check,Zrównaj size po zmianie Lot Size
Lot_fast_sizeSW17_R := Lot_fast_sizeSW17_D := 0
Lot_fast_sizeSW17_T := "Nie wymagaj ctrl by zmieniać size (numpad)"
Gui,Add,Checkbox,x80 y341 w180 h13 Disabled vLot_fast_sizeSW17 gswitch_check,Zmieniaj size bez ctrl
Gui,Add,Text,x260 y227 w15 h13 Hidden vSlider_txt0,-->
Gui,Add,Text,x260 y295 w15 h13 Disabled vLot_txt3,-->
Gui,Add,Text,x260 y340 w15 h13 Disabled vLot_txt4,-->
Gui,Add,Text,x90 y368 w140 h13 Disabled vLot_txt2,Modyfikator Numpad+/-
;Lot_AltRB18_R := 1
Gui,Add,Radio,x81 y386 w40 h16 0x1000 Checked Disabled vLot_AltRB18 gtrigger_mod,alt
;Lot_CtrlRB18_R := 0
Gui,Add,Radio,x121 y386 w40 h16 0x1000 Disabled vLot_CtrlRB18 gtrigger_mod,ctrl
;Lot_ShiftRB18_R := 0
Gui,Add,Radio,x161 y386 w40 h16 0x1000 Disabled vLot_ShiftRB18 gtrigger_mod,shift
;Lot_WinRB18_R := 0
Gui,Add,Radio,x201 y386 w40 h16 0x1000 Disabled vLot_WinRB18 gtrigger_mod,win
;Lot_NoneRB18_R := 0
Gui,Add,Radio,x241 y386 w17 h16 0x1000 Disabled vLot_NoneRB18 gtrigger_mod,-

Lot_RB_R := Lot_RB_D := 1

Gui,Add,GroupBox,x280 y110 w160 h85 Disabled vMysz_group,Mysz
Mysz_book_scrollSW21_R := Mysz_book_scrollSW21_D := 1
Mysz_book_scrollSW21_T := "Czy scroll myszki na booku ma operować sizem"
Gui,Add,Checkbox,x290 y133 w120 h13 Checked Disabled vMysz_book_scrollSW21 gswitch_check,Scroll zmienia size
Mysz_mysz_midSW22_R := Mysz_mysz_midSW22_D := 1
Mysz_mysz_midSW22_T := "Srodkowy przycisk myszki (działa też poza prosperem)"
Gui,Add,Checkbox,x290 y155 w120 h30 Checked 0x2000 0x400 Disabled vMysz_mysz_midSW22 gswitch_check,Środkowy wysyła okienko w tło

Lot_RB := ["Lot_AltRB18", "Lot_CtrlRBl8", "Lot_ShiftRB18", "Lot_WinRB18", "Lot_NoneRB18"]

Gui, Submit, NoHide
for idx, el in Lot_RB  ;["Lot_AltRB18", "Lot_CtrlRBl8", "Lot_ShiftRB18", "Lot_WinRB18", "Lot_NoneRB18"]
if (%el%)
{
  GuiControlGet, lotmod,, %el%, Text
  modif := lotmod = "-" ? "" : "[" lotmod "] + "
  break
}

;GuiControlGet, Cyfry_LRSW13
if (Cyfry_LRB13)
  lotjumptxt := "  lub cyfry"

Gui,Font,s7 c0x222222
Gui,Add,Text,x280 y297 w150 h13 Disabled vLot_txt5,%modif%[numpad+/-]%lotjumptxt%
Gui,Add,Text,x280 y341 w150 h13 Disabled vLot_txt6,a cyfry z altem (na numpad)
Gui,Font

;Gui,Add,Picture,x365 y384 w47 h44 Hidden vBooktabs_warn,%A_ScriptDir%\icon\war1.png
;Gui,Add,Picture,x363 y385 w53 h46 Hidden vBooktabs_warn,%A_ScriptDir%\icon\war2.png
Gui,Add,Picture,x361 y382 w51 h52 Hidden vBooktabs_warn,%A_ScriptDir%\icon\war3.png


Gui,Font,s7 c0x888888
Gui,Add,Text,x288 y402 w73 h15 Hidden vBooktabs_warntxt,podłącz skrypt
Gui,Font


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui,Tab,5

Gui,Add,GroupBox,x70 y110 w370 h85 Disabled vBinds_group,Skróty API
Binds_longED26_R := Binds_longED26_D := "HOME"
Gui,Add,Button,x80 y132 w43 h21 0x8000 Disabled vBinds_longED26 gbind_key,%Binds_longED26_R%
Binds_shortED27_R := Binds_shortED27_D "END"
Gui,Add,Button,x80 y162 w43 h21 0x8000 Disabled vBinds_shortED27 gbind_key,%Binds_shortED27_R%
Binds_biglongED28_R := Binds_biglongED28_D := "PgUp"
Gui,Add,Button,x189 y132 w43 h21 0x8000 Disabled vBinds_biglongED28 gbind_key,%Binds_biglongED28_R%
Binds_bigshortED29_R := Binds_bigshortED29_D := "PgDn"
Gui,Add,Button,x189 y162 w43 h21 0x8000 Disabled vBinds_bigshortED29 gbind_key,%Binds_bigshortED29_R%
Binds_buyhandED30_R := Binds_buyhandED30_D := "="
Gui,Add,Button,x301 y132 w43 h21 0x8000 Disabled vBinds_buyhandED30 gbind_key,%Binds_buyhandED30_R%
Binds_sellhandED31_R := Binds_sellhandED31_D := "-"
Gui,Add,Button,x311 y162 w43 h21 0x8000 Disabled vBinds_sellhandED31 gbind_key,%Binds_sellhandED31_R%

Gui,Add,Text,x129 y134 w55 h13 Disabled vBinds_txt1,Long
Gui,Add,Text,x129 y164 w55 h13 Disabled vBinds_txt2,Short
Gui,Add,Text,x238 y134 w55 h13 Disabled vBinds_txt3,Big Long
Gui,Add,Text,x238 y164 w55 h13 Disabled vBinds_txt4,Big Short
Gui,Add,Text,x350 y134 w55 h13 Disabled vBinds_txt5,Buy Hand
Gui,Add,Text,x350 y164 w55 h13 Disabled vBinds_txt6,Sell Hand

Gui,Add,Button,x170 y210 w80 h16 0x1000 Default Hidden Disabled vRebindBtn grebind_btn,rebind key
Binds_specialSW23_T := "dla niestandardowych wyzwalaczy edków w PPRO8"
Gui,Add,Checkbox,x260 y210 w140 h16 0x1000 Disabled vBinds_specialSW23,PPRO8 special keybinds

/*  <---------- UP DOWN ORDERS

Gui,Add,GroupBox,x280 y350 w200 h53 Disabled vUD_group,UpDown Orders
UD_updown_orders15_R := 0
UD_updown_orders15_T := "Dodatkowe podpięcia zleceń z ręki"
Gui,Add,Checkbox,x290 y369 w150 h30 0x2000 0x400 Disabled vUD_updown_orders15,Strzałki góra/dół jako wejścia long/short
Gui,Add,Text,x260 y421 w15 h13 Disabled vUD_txt1,-->

Gui,Font,s7 c0x222222
Gui,Add,Text,x280 y428 w140 h42 Disabled vUD_txt2,korzysta standardowo z defalutBuy/Sell i specialBuy/Sell (+shift)
Gui, Font

*/



Gui,Add,Text,x80 y220 w80 h13 Disabled vBinds_txt7,Pozostałe bindy
Gui,Add,ListView,x70 y240 w340 h175 r9 0x1 HwndHLV AltSubmit -Multi -ReadOnly Checked Grid NoSort NoSortHdr Disabled vBinds_list gBindList,Opis|Typ|Key   ;IconRight 

;;CHECK IF ENABLED
;;CONTEXT MENU

Loop, %A_MyDocuments%\*.* 
    LV_Add("Check", A_LoopFileName,,A_LoopFileSizeKB )

LV_ModifyCol(1,270)  ; Auto-size each column to fit its contents.
LV_ModifyCol(2, 0)  ; Auto-size each column to fit its contents.
LV_ModifyCol(3, "AutoHdr")  ; Auto-size each column to fit its contents.
;LV_ModifyCol(4, "AutoHdr")  ; Auto-size each column to fit its contents.
;LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.

;GuiControl +BackgroundFF9977, MyListView



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui,Tab,

Gui,Add,Checkbox,x18 y451 w23 h22 0x1000 vAddonsBtn gaddons,^
Addons_T := "Szybkie narzędzia"

Gui,Add,Button,x50 y451 w55 h22 Disabled vResetBtn greset_changes,Reset
ResetBtn_T := "Resetuj ustawienia"

Gui,Add,Button,x107 y451 w123 h22 Disabled vLastBtn hwndlastBtn gapply_changes,Załaduj Zmiany  ;Default 
LastBtn_T := "Zastosuj zmiany i przeładuj skrypt"

Gui,Font, s8 c0xdaa73d Bold,
Gui,Add,Text,x225 y454 w60 h22 Hidden vVerCheck, > ver.%VERSION%
Gui,Font

Gui,Font,Normal s7 c0x808080 Bold,Tahoma
Gui,Add,Text,x280 y470 w120 h13 c0x808080,TraderHouse (c) s1w_
Gui,Font


;----------------------------------------------win position-----------
w := 428
h := 482

RegRead, WinX, HKEY_CURRENT_USER, Software\TraderHouse\script, WinX
RegRead, WinY, HKEY_CURRENT_USER, Software\TraderHouse\script, WinY

x := ""
y := ""

If (WinX)
{
	WinX := WinX << 32 >> 32
	x := "x" WinX
}
If (WinY)
{
	WinY := WinY << 32 >> 32
	y := "y" WinY
}

Gui, Show, %x% %y% w%w% h%h%, %APPNAME%  ;%file_name%
hWin := WinExist("A")
GuiControl,,WindowHandle, %thisWindow%   ;wtf?


SysGet, OutX, 76
SysGet, OutY, 77
SysGet, OutX2, 78
SysGet, OutY2, 79
OutX2 -= Abs(OutX)
OutY2 -= Abs(OutY)

WinGetPos, x, y, WinW, WinH, ahk_id %hWin% ;A

If (x < OutX)
	x1 := OutX
If (x >= OutX2 - WinW)
	x1 := OutX2 - WinW
If (y < OutY)
	y1 := OutY
If (y >= OutY2 - WinH)
	y1 := OutY2 - WinH

If (x <> x1 || y <> y1)
	WinMove, ahk_id %hWin%, , x1, y1

;----------------------------------------------win position-----------

;----------------------------------------------tabs layer-----------

Gui, 7:-LastFound +Owner1 -Caption +ToolWindow   ;+AlwaysOnTop
trans := 1
if (SHOWLAYER)
{
	CustomColor = EEAA99  ; Can be any RGB color.
	Gui, 7: Color, %CustomColor%
	trans := 150
}
;WinSet, TransColor, %CustomColor% 250 ; Make color invisible
WinSet, Transparent, % trans
x_layer := x + LAYER_XOFF
y_layer := y + LAYER_YOFF
Gui, 7:Show, x%x_layer% y%y_layer% w%LAYER_W% h%LAYER_H% NoActivate, tablayer
Gui, 7:Hide
OnMessage(0x201,"WM_LAYERCLICK") 
Gui 1:Default ;niepotrzebne, bo -LastFound --- -LastFound nie działa
;Gui, 7:Hide

;------------------------------------------imports editor-----------




;-------------------------------------------------------------------

WinActivate, ahk_id %hWin% ;A
WinRestore, ahk_id %hWin% ;A



New_Column_Order := "3|1|2"
LV_Set_Column_Order(3, New_Column_Order )


GoSub, on_messages

OnExit("ExitApp")


GoSub, create_cmenu

;----------------------------------------------try last settings------
RegRead, REG_PATH, HKEY_CURRENT_USER, Software\TraderHouse\script, Path
if (REG_PATH)
{
	GoSub, register_script
	REG_PATH :=
}

;tryRegistry() + backupEntries()
;GoSub, check_cloud_folder  ;TO PRZENIEŚĆ DO IMPORT CHANGES!!! -----NAJPIERW SPR LINK Z CONFIGA-----------------------------------------------------
;ALBO TU TEŻ! JEŻELI LINK Z CONFIGA NIE ISTNIEJE, A WYKRYTO Z HEURYSTYKI, PYTANIE CZY UPDATOWAĆ IMPORTY
;debug("clear")
;showGroup("Charts_")
;show("Tab_mysz_tab")
;enableAll()            ; --- new
;ctrl_show("Slider_")   ; --- new

;SetTimer, debug_init, -1
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#include DoubleSlider.ahk
#include gdip.ahk
#include debug.ahk


on_messages:
	OnMessage(0x111,"WM_FOCUS")
	OnMessage(0x200,"WM_MOUSEMOVE")  ;mousemove
	OnMessage(0x201,"WM_MOUSEMOVE")  ;lbuttondown
	OnMessage(0x204,"WM_MOUSEMOVE")  ;rbuttondown
	;;;OnMessage(0x4E, "WM_NOTIFY") juz niepotrzebne
	OnMessage(0x03, "WM_MOVE")
	OnMessage(0x06, "WM_ACTIVATE")
Return

off_messages:
	OnMessage(0x111,"")
	OnMessage(0x200,"")  ;mousemove
	OnMessage(0x201,"")  ;lbuttondown
	OnMessage(0x204,"")  ;rbuttondown
	;;;OnMessage(0x4E, "WM_NOTIFY") juz niepotrzebne
	OnMessage(0x03, "")
	OnMessage(0x06, "")
Return


register_script:
	Gui +OwnDialogs  ; Forces user to dismiss the following dialog before using main window.

	If (REG_PATH)
	{
    if (!RegExMatch(REG_PATH, "i)(.+\\[^\\]+\.ahk)"))  ;;new
    { 
      REG_PATH :=
      RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Path, 
      return  ;;???
    }
    else
      tmp_path := REG_PATH
	}
	else
	{
		If (changes <> 0x0 || switches <> 0x0)
		{
			MsgBox, % 4096+256+4, %file_name%, Porzucić zmiany?
			IfMsgBox, No
				return
		}
		FileSelectFile, tmp_path, 2, %full_path%, Otwórz skrypt PPRO8:, TH Script (*.ahk)
		if not tmp_path  ; The user canceled the dialog.
			return
	}
	If StrLen(tmp_path) > 31
	{
		short_path := shortenPath(tmp_path, 28)
	}
  else
    short_path := tmp_path
    
	ext := RegExReplace(tmp_path, ".+?([^\\\.]{0,4})$", "$1")

	If StrLen(ext) > 3
		short_path := short_path ".ahk"
	else If (ext != "ahk")    ;If StrLen(ext) <= 3 &&
	{
		If (REG_PATH)
		{
			REG_PATH :=
			;scriptStatus(0) ;scriptStatus(SCRIPT_ERROR)
			;disableAll() ;<---------------------------------------------------  albo nic nie robic
			return                       ;;;;button name updatowany?
		}
		else
		{
			if FileExist(tmp_path)
			{
        MsgBox ,4096,, To nie jest plik skryptowy, kmiocie.
				GoSub, register_script
				return
			}
			short_path := RegExReplace(short_path, "(.+\\[^\.]+).*?$", "$1") ".ahk"
		}
	}
	
	if (!REG_PATH && full_path) {
		oldHWND := WinExist(full_path " ahk_class AutoHotkey")
		WinClose, ahk_id %oldHWND%
	}

	file_name := RegExReplace(short_path, ".+\\([^\\]+)$", "$1")
	path_only := RegExReplace(tmp_path, "(.+\\)[^\\]+$", "$1")     ;;new
	full_path := path_only file_name   ;correct full path with correct filename
	
	RESTART := 1
	if IsObject(file)
	{
		PPRO8_PATTERN :=
		debug("::::::::RESTARTING:::::::::", A_LineNumber)
		enableAll(0)
		;GuiControl, Choose, CurrentTab, |1		
		;RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Tab, 1
		file.Close()
		Gui, EditorBox: Destroy
		EditorGuiCreated :=
		GuiControl, Text, ImportScriptBtn, % ImportScriptBtn_D
		GuiControl, Text, eTRADER_ED01, 
		;SetTimer, watch_script, Off
		changes  := 0x0
		switches := 0x0
		warnings := 0x0
		;AHK_UPDATED := 0
		charts_check()
		hideGroup("Red_")
		hideGroup("Yellow")
		hideGroup("Imports_update")
		hideGroup("Booktabs_")
		;disableGroup("Imports_")
		;resetValues();
		wrongVersion := 0
		traderCorrected := 0
		scriptStatus(INACTIVE)
		;ALL CONTROLS TO DEFAULT ----------------------------------------------------------

		;GoSub, read_defaults
		;GoSub, reset_changes
		;RESTART := 0
		TRADER := 0
		;GuiControl, Text, ImportScriptBtn, % ImportScriptBtn_D
		;GuiControl, Text, eTRADER_ED01, 
		;GuiControl, Disable, eTRADER_ED01
		; IMPORT
	}
	;else
	;	debug("::::::::STARTING:::::::::", A_LineNumber)
	;enableAll()  ;;temporary
	
	If !FileExist(full_path) {
		If (REG_PATH)
		{
			REG_PATH :=
			scriptStatus(SCRIPT_ERROR)
			;enableAll()              ;ENABLE ALL ????? --------------------------------------------------------
			GoSub, load_script
			return
		}
		else
		{	
			MsgBox, % 4096+32+4, %file_name%, Skrypt nie istnieje, utworzyć nowy?
			IfMsgBox, Yes
			{
				pattern_path := PPRO8_PATTERN ? PPRO8_PATTERN : A_ScriptDir "\PPRO8.ahk"
				debug(PPRO8_PATTERN " created [" pattern_path "]", A_LineNumber)
				FileCopy, %pattern_path%, %full_path%
				;CREATE_NEW := 1
			}
			else
			{
		    ;file_name := tmp_file_name 
		    ;full_path := tmp_full_path
				;GoSub, register_script   ;; po wyzerowaniu juz nie powracaj do register
				return
			}
		}
	}

	file := FileOpen(full_path, "rw-wd", "UTF-8")
	if !IsObject(file)
	{
		If (REG_PATH)
		{
			REG_PATH :=
			scriptStatus(SCRIPT_ERROR)
			file.Close()
  		MsgBox, % 4096+48, %file_name%, Błąd podczas odczytu pliku.
			;enableAll()              ;ENABLE ALL ????? --------------------------------------------------------
			GoSub, load_script    ;;;;;;;; load or just watch??????
		}
		else
			MsgBox, % 4096+48, %file_name%, Błąd podczas odczytu pliku.
			;MsgBox, Błąd podczas odczytu %file_name%
		return
	}


	scriptBuffer := file.Read()

	validation1 := "im)^[!^+#]*\w+::"
	validation2 := "im)^\s*Send(\s|,)"
	validation3 := "imx)^return$"
	Loop, 3
	{
		valid := RegExMatch(scriptBuffer, validation%A_Index%)
		;debug("validating " A_Index, A_LineNumber)
		if (!valid) {
			If (REG_PATH)
			{
				REG_PATH :=
				;scriptStatus(SCRIPT_ERROR)
			}
			scriptStatus(SCRIPT_ERROR)
			file.close()
			MsgBox, % 4096+48, %file_name%, Błędna zawartość skryptu.				
			;;;;disable alll!!  ;;<-------------------------------------------------
			;GoSub, load_script   ;register_script
			return
		}
	}
	GuiControl, Text, ImportScriptBtn, %short_path%
	RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Path, %full_path%

	;if (RESTART)
	;{
		GoSub, off_messages
		;debug("[>go import links")
		GoSub, read_import_links
		;debug("[>should go init cloud folder")
;msgbox, stage2
		GoSub, get_pattern_file

;		if (!PPRO8_PATTERN)
;			GoSub, init_cloud_folder   ;tutaj qsync link, nie w reset ;wyjebac, update przez restart
		;debug("[>go read defaults")
		GoSub, read_defaults
		;debug("[>go reset changes")
		GoSub, reset_changes
		GoSub, on_messages   ;NA KONIEC GDY NIE MA CLOUD FOLDER SPRAWDZIC CZY JEST W REJESTRZE I SPYTAC CZY UPDATE (UAKTYWNIC RESET)
		RESTART := 0
	;}
	
	TRADER := getVar("TRADER", 0) ;------------------------------pobierz wartość trader, pomiń szablony w razie braku
	If (REG_PATH)
	{
		REG_PATH :=
		scriptStatus(INACTIVE)
		StringUpper, TRADER, TRADER
		GuiControl, Text, eTRADER_ED01, %TRADER%		
		GuiControl, Enable, eTRADER_ED01  ;enable early
		;checkEntry("eTRADER_ED01")
		eTRADER_ED01_R := TRADER
		debug("eTRADER_ED01_R?L <--- " eTRADER_ED01_R, A_LineNumber)
		;if !(eTRADER_ED01_I := badEntry("eTRADER_ED01", RegExMatch(TRADER, eTRADER_ED01_pattern)))
		;	eTRADER_ED01_L := TRADER
		enableAll()
		GoSub, load_script
	}
	else if (!TRADER) {
		MsgBox, % 4096+48+4, %file_name%, Skrypt wydaje się być stary. Przystosować go do API?
		IfMsgBox, Yes
			If (TRADER := setTrader())  ;;;;;;;;;;;;;;;;;; tu zaladowac skrypt
				enableAll()
			GoSub, load_script
	}
	else if !RegExMatch(TRADER, "^[A-Za-z]{8}$")
	{
		;MsgBox, % 48+1, %file_name%, TRADER w skrypcie zawiera błędną wartość, ustawić nową?
		;IfMsgBox, Ok
		;{	
			If (TRADER := setTrader(TRADER))
				enableAll()			
			GoSub, load_script
        ;debug("checkin trader 1", A_LineNumber)
        ;GoSub, edit_canceled
		;}
	}
	else
	{
		StringUpper, TRADER, TRADER
		GuiControl, Text, eTRADER_ED01, %TRADER%	
		eTRADER_ED01_R := eTRADER_ED01_L := TRADER
		debug("eTRADER_ED01_R_L <--- " eTRADER_ED01_R, A_LineNumber)
		enableAll()
		GoSub, load_script
    ;enableAll()  ;;NEW 27.01
	}
	;GuiControl, Enable, eTRADER_ED01
	return
	
load_script:
	GuiControl, Enable, eTRADER_ED01
	;badEntry("eTRADER_ED01", !bitGet(warnings, 1))
	eTRADER_ED01_I := badEntry("eTRADER_ED01", RegExMatch(TRADER, eTRADER_ED01_pattern))
	;eTRADER_ED01_L := TRADER
	;GuiControl, Text, ImportScriptBtn, %short_path%

	;enableAll()
	;CREATE_NEW := 0

	GoSub, update_import_buttons  ;;init???
	;enableGroup("Imports_") 
	;GoSub, ahk_update

	
	;RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Path, %full_path%

	
	watch_ := checkScriptRunning()

	if (!watcherTriggered)
	{
		SetTimer, % (watch_ && (sc_status <> SCRIPT_ERROR) ? "watch_script_close" : "watch_script_open"), -1
		watcherTriggered := 1
	}
	else
	{
		run, %A_ScriptDir%\_reset.ahk
	}

	if (sc_status = SCRIPT_ERROR)
		return
		;APPVERSION
	debug("checking_version " VERSION " getVer()  " getVer() , A_LineNumber)
	;needle := "i)ver\.?\s*(\d+\.?\d*)"  ;getVar("ver") ;;needle := "O)(?<=ver|ver.)\s*\d+\.?\d*" ;Trim(result.Value(0))   ;;przesunac
	;RegExMatch(scriptBuffer, needle, ver)
	If NOT VERSION == getVer()   ;ver1
	{
	debug("heeeeeer")
		GuiControl, Show, VerCheck
		wrongVersion := 1
		enable("LastBtn")
	}
	else
	{
		GuiControl, Hide, VerCheck
	}

	;importEntries()
	;updateRegistry()
	;backupEntries()
	;debug("jestem tu")
	;enableAll()
  ;disableAll()
	
Return


charts_set(btn)
{
  global pToken, crossoff, Charts_CrossED09_L, Charts_ZoomED10_L

  ;if FileExist(chartbtn%btn%)
  ;  return Gdip_CreateBitmapFromFile(chartbtn%btn%)
  
  widthToScan=30
  heightToScan=30

  chart_id := 

	dhw := A_DetectHiddenWindows
	DetectHiddenWindows Off
  WinGet, id, list, ahk_exe ChartWindow.exe
	DetectHiddenWindows %dhw%  

  Loop, %id%
  {
      this_id := id%A_Index%
      WinGetTitle, this_title, ahk_id %this_id%
      chartnum := RegExReplace(this_title, "^.+\s\((\d+)\)$","$1")
      if chartnum is not integer
        continue
      chart_id := this_id
      break
  }
  if (!chart_id)
    return Gdip_CreateBitmapFromFile(crossoff)
    
  WinGetPos x, y, , , ahk_id %chart_id%

  coord := (btn = 1 ? Charts_CrossED09_L : btn = 2 ? Charts_ZoomED10_L : return 0)
  px := StrSplit(coord, ",")[1] + x - (widthToScan / 2)
  py := StrSplit(coord, ",")[2] + y - (heightToScan / 2)
  return Gdip_BitmapFromScreen(px "|" py "|" widthToScan "|" heightToScan)  ; Gdip_CreateBitmapFromFile(folder_a "\" ColorChoice ".png")
}

slider_check(sc)
{
  global
  if (sc < 1 || sc > 2)
    return
  sc_ctrl := (sc = 1 ? "Slider_LeftSW14" : "Slider_RightSW15")
  ctrlnr := 13 + sc
  
	if (%sc_ctrl%_L != %sc_ctrl%)
	{
		%sc_ctrl%_L := %sc_ctrl%
		change(ctrlnr, switches, %sc_ctrl%_R != %sc_ctrl%)
		;debug(ctrlnr " ::::::::::::::::: " (%sc_ctrl%_R != %sc_ctrl%), A_LineNumber)
	}	
}

charts_check()
{
  global
  if (Charts_CrossED09_L != Charts_CrossED09_R || Charts_ZoomED10_L != Charts_ZoomED10_R) {
    MsgBox, % 4096+1, %file_name%,  Porzucić zmiany?
    IfMsgBox, OK
    {
      GUI_visibility("Charts", "hide")
      if (Charts_CrossED09_L != Charts_CrossED09_R)
      {
        Charts_CrossED09_L := Charts_CrossED09_R
        change(09, changes, 0)  ;;;;;;;;;;;;;;; ---------------------??????????????????????????
        p2Bitmap := charts_set(1)
        h2Bitmap := Gdip_CreateHBITMAPFromBitmap(Gdip_CropImage(p2Bitmap, 5, 4, 20, 22))
        Ext_Image(btnC1, h2Bitmap)
      }
      if (Charts_ZoomED10_L != Charts_ZoomED10_R)
      {
        Charts_ZoomED10_L := Charts_ZoomED10_R
        change(10, changes, 0)  ;;;;;;;;;;;;;;; ---------------------??????????????????????????
        p2Bitmap := charts_set(2) 
        h2Bitmap := Gdip_CreateHBITMAPFromBitmap(Gdip_CropImage(p2Bitmap, 5, 4, 20, 22))
        Ext_Image(btnC2, h2Bitmap)
      }
      DeleteObject(h2Bitmap)
      Gdip_DisposeImage(p2Bitmap)      
    }
    else
    {
      GuiControl, , Imports_chartSW07, 1
    }
  }
  else
    GUI_visibility("Charts", "hide")
}

/*
		  StringRight, editable, control, 4

		  if RegExMatch(editable, "ED\d{2}")
		  {
			GuiControlGet, ischecked ,, % regexReplace(control, "ED", "SW")
			if (!ischecked) ; || (editable = "ED06" && !isapiactive))  ;tu jeżeli wyłączać booktabs razem z api
			{
				;if (editable = "ED05")
				;	isapiactive := 0
				continue
			}
			
		  }
		  else if RegExMatch(editable, "SW05") ;api-start.ahk obowiązkowy
				continue
		  ;else if (RegExMatch(editable, "SW06") && !isapiactive)
			;	continue
		}

		GuiControl, %action%, %control%
*/

disableImportButton(button, snr) {
	global
	hide(button "_BTNUpdate")
	GuiControl, Hide, YellowB_%button%
	GuiControl, Hide, YellowI_%button%		
	bitUnset(deprecated, snr - 4)
	%button%_I := badEntry(button, 1)   ;uwzglednic deprecated
	disable(button)
	if (snr = "06")
		GoSub, ahk_checkbooks
	else if (snr = "07")
		GoSub, ahk_checkcharts  
}


switch_check:
  debug(">switch_check", A_LineNumber)
	GuiControlGet, sc_ctrl, FocusV 
	StringRight, switchnr, sc_ctrl, 2
	if switchnr is not number
		return

	GuiControlGet, newValue,, %sc_ctrl%
    ctrlType := SubStr(sc_ctrl, -3, 2)
	if (%sc_ctrl%_L != newValue || ctrlType = "RB")  ;RegExMatch(sc_ctrl, "[A-Za-z_]{3,}RB\d{2}")
	{
		if (ctrlType = "RB")
		{
			RadioGroup := RegExReplace(sc_ctrl, "([A-Za-z]{3,}_)[A-Za-z_]{0,}RB\d{2}","$1RB")
			newValue := 0
			For each, radio in %RadioGroup%
			{
				newValue++
				if (radio = sc_ctrl)
					break
			}
			
			if (%RadioGroup%_L != newValue)
			{
				;debug(RadioGroup " :: " newValue)
				%RadioGroup%_L := newValue
				change(switchnr, switches, %RadioGroup%_R != newValue)
				;debug(switchnr " ::::::::::::::::: " (%RadioGroup%_R != newValue), A_LineNumber)
			}
		}
		else
		{
			%sc_ctrl%_L := newValue
			change(switchnr, switches, %sc_ctrl%_R != newValue)
			;debug(switchnr " ::::::::::::::::: " (%sc_ctrl%_R != newValue), A_LineNumber)
			if (ctrlType = "SW" && InStr("05|06|07|08",switchnr))
			{
				button := regexReplace(sc_ctrl, "SW", "ED")
				if (newValue)
				{
					enable(button)
					;SetTimer, ahk_update, -50
					GoSub, ahk_update
			
				}
				else
				{
					disableImportButton(button, switchnr)
				}

			}
		}
        ;debug("<switches> : : : " switches, A_LineNumber)

		;debug(RegExReplace(sc_ctrl, "([A-Za-z]{3,}_)([A-Za-z_]{2,})RB\d{2}","$1RB"), A_LineNumber)
		;tu dla reszty RB
	}
	
  /* ;moved to ahk_checkcharts
  if (sc_ctrl = "Imports_chartSW07") {
    ;GUI_visibility("Charts", newValue ? "show" : "hide")
    if (!newValue)
      charts_check()
    else {
      cbtn := "1"
      GoSub, set_last_bitmap   
      GUI_visibility("Charts", "show")
    }
  }
  */
Return


ahk_checkbooks:
  GuiControlGet, bookschecked,, Imports_bookSW06

  ;if (!AHK_UPDATED) {  ;to kiedys sprawdzic czy uproscic, czy link potrzebny
	link := currentValue("Imports_bookED06")  ;_L ? Imports_bookED06_L : Imports_bookED06_R
	default := currentValue("CloudBtnED04") "\" Imports_bookED06_D ;_L ? CloudBtnED04_L : CloudBtnED04_R) "\" Imports_bookED06_D
	;debug("default " default)
	;debug("link " link)
	linkExist := FileExist(link) 
	defaultExist := FileExist(default) 
	if (!linkExist && !defaultExist) {
		;debug(">>>> setting warrning booktabs", A_LineNumber)
		bitSet(warnings, "06")
	}
	else
		bitUnset(warnings, "06")
  ;}
  
  ;GuiControlGet, booksenabled, Enabled, Charts_group  /*&& !booksenabled*/ !bitGet(warnings, "06")
  ;debug(">>checkin books " bookschecked " warr " bitGet(warnings, "06") " link " link)
  func := bookschecked && !bitGet(warnings, "06") && UNLOCKED ? "enable" : "disable"  
  ;debug("bookschecked " bookschecked " booksenabled " booksenabled)
  ;debug(">>> " func)
	%func%Group("Tab_")
	%func%Group("UD_")
	%func%Group("Cyfry_")
	GuiControlGet, Cyfry_SRB13
	if (func = "enable" && Cyfry_LRB13)
		ctrl_show("Slider_")
	else
		ctrl_hide("Slider_")
	%func%Group("Lot_")
	%func%Group("Mysz_")
	%func%Group("Order_")
	if (func = "enable")
		hideGroup("Booktabs_")
    else
		showGroup("Booktabs_")

Return

ahk_checkcharts:
  GuiControlGet, chartschecked,, Imports_chartSW07
  GuiControlGet, chartsvisible, Visible, Charts_group
  if (chartschecked && !chartsvisible) {
    ;GUI_visibility("Charts", newValue ? "show" : "hide")
	cbtn := "1"
	GoSub, set_last_bitmap   
	GUI_visibility("Charts", "show")
  }
  else if (!chartschecked && chartsvisible)
  {
	charts_check()  
  }
Return

import_check:
;; sprawdzanie data_check przy imporcie danych
;; z uwzglednieniem min-max zamiast pattern
Return

grab_check:
	StringRight, editable, cctrl, 2
  change(editable, changes, %cctrl%_L != %cctrl%_R)
  ;debug(editable " ::::::::::::::::: " (%cctrl%_L != %cctrl%_R), A_LineNumber)
Return

data_check:
  if (resetting || RESTART /*|| editing*/)  ;;;editing new --- potrzebne przy klikaniu w inny edit bez potwierdzenia zmian (konflikt editable)
    return
  debug(">data_check", A_LineNumber)
  ;GoSub, debug_init
  ;if (inputing)
  ;  return
  GuiControlGet, control_tmp, FocusV 
  if (editing && control_tmp != control) ;;potrzebne przepuszczenie do zmian na bierząco
	return
  control := control_tmp
  
  StringRight, editable, control, 2
  ;debug("editable " editable " (" control ")", A_LineNumber)
  if editable is not number
	return

  ;errval := 0
  ;debug(errval,"err1")
 
  ;inputing := 1
 ; if editing  ;new ------------------- needed? {ESC}?
 ;   return
 ; editing := 1
  
  try GuiControlGet, %control%    
  hint := 0
  if (StrLen(%control%_E) && (%control% = %control%_E))
    hint := 1

  if ((control = hintCtrl) && !hint)  ;;font potrzebny do E
	{
    ;inputing := 1
    Gui, Font, cDefault
		GuiControl, Font, %control%		
		;GuiControl, Text, %control%,
    ;sleep, 100
    hintCtrl :=
    ;inputing := 0
    ;return
	}

  if (!StrLen(%control%) && StrLen(%control%_E) || hint)   ;new zalatwione::: TU ODKOMENTOWAŁEM STRLEN, POTRZEBNE DO POPRAWNEJ OBSLUCGI _czemu było zakomentowane?
  {
    if (%control%_E)        ;;;bitSet(warnings, ctrlno)  to dodac do pustych do warnings przy inicjacji calosci
    {
      ;inputing := 1
      Gui, Font, cSilver
      GuiControl, Font, %control%
      if (!StrLen(%control%))
        GuiControl, Text, %control%, % %control%_E
      ;GuiControl,, %control%, % %control%_E
      ;Gui, Font
      Sleep, 20
      hintCtrl := control
      ;inputing := 0
    }
    GuiControl, Hide, Red_%control%
    ;change(editable, changes, 0)
    change(editable, changes, %control%_R != %control%) ;--- new    
	;debug(editable " ::::::::::::::::: " (%control%_R != %control%), A_LineNumber)
    %control%_I :=
    confirmed := 0
    canceled := 0
    editing := 0
    ;inputing := 0
    return  
  } 
	;GuiControlGet, newValue,, %control%
	%control%_I := badEntry(control, 1)	  ;;;;; 1 to chyba jednak dobrze ///CZEMU TU LUZEM JEST WRONG ZAWSZE USTAWIANE?
	
	;if (%control%_L != %control%)  ;;========================== bylo ok, ale gdy nie sprawdza nie patrzy na bierzaco dla ResetBtn ||new przeniesione do errcheck
	;{
	;	%control%_L := %control%
		change(editable, changes, %control%_R != %control%)
		;debug(editable " ::::::::::::::::: " (%control%_R != %control%), A_LineNumber)
	;}
  ;inputing := 0
  if (!editing)
    SetTimer, errcheck, -1
Return

errcheck:
  editing := 1
	GuiControlGet, ctrl1, FocusV 
;errcontinue:
  debug(". . .", A_LineNumber)
	Loop
	{
		Sleep, 100
		GuiControlGet, ctrl2, FocusV 
    if (canceled) {
      GoSub, edit_canceled
      canceled := 0 ;GoSub, edit_proceed ;stop_errcheck    
    } ;tu nie ma break bo zostaje focus
		if (confirmed || ctrl2 != ctrl1) {
		debug("<<breaking edit loop>>", A_LineNumber)
;      debug("= =", A_LineNumber)
			break  ;break zeby skoczyc na zaladuj
    }
	}
	try GuiControlGet, %ctrl1%
  ;if (ctrl2 != ctrl1) {
    ;editing := 0
 ; }
	;GuiControlGet, newValue,, %ctrl1%

  if (%ctrl1% = "") {
  	GoSub, edit_canceled
	GoSub, stop_errcheck
	return
  }
  else if (%ctrl1% = %ctrl1%_E) {
    GoSub, stop_errcheck
    return
  }
  ;try GuiControlGet, %ctrl1%
  
  if %ctrl1%_
  {
    ;actual := %ctrl1%
    ;minimal := %ctrl1%_["min"]
    if (%ctrl1% > %ctrl1%_["max"])
      GuiControl,, %ctrl1%, % %ctrl1%_["max"]
    else if (%ctrl1% < %ctrl1%_["min"])
      GuiControl,, %ctrl1%, % %ctrl1%_["min"]
  }
  
  ;if %ctrl1%_D                                                         ;;;uwzglednic przy imporcie
  ;  GuiControl,, %ctrl1%, % %ctrl1% - Mod(%ctrl1%, %ctrl1%_D)            ;; CO TO KURWA JEST, MOD?? _D??
	
  %ctrl1%_I := badEntry(ctrl1, RegExMatch(%ctrl1%, %ctrl1%_pattern))
  ;hintCtrl :=
  change(editable, changes, %ctrl1%_R != %ctrl1%) ;--- new
  ;debug(editable " ::::::::::::::::: " (%ctrl1%_R != %ctrl1%), A_LineNumber)
  ;debug("<changes> : : : " changes, A_LineNumber)
  ;%ctrl1%_L := %ctrl1% w edit_proceed

  
  if (!%ctrl1%_I) {
    GoSub, edit_proceed 
    GoSub, stop_errcheck
    return
  }
  ;else if (ctrl1 = "eTRADER_ED01") 
  ;  disableAll()      ;; ---- powtorzone dlatego zeby pominac editing := 0

stop_errcheck:
  debug(">stop_errcheck", A_LineNumber)
  if (resetting || RESTART)
    return
  ;debug("stop_errcheck", A_LineNumber)
  confirmed := 0
  canceled := 0
  editing := 0 ;;bylo wykomentowane?
  GuiControlGet, ctrl2, FocusV 
  if (ctrl2 = ctrl1 && !!(%ctrl1%_I)) {
    errval := 1
    ;debug("stop_focus " ctrl1, A_LineNumber)
    GoSub, errcheck  ;upewnic sie ze focus nie powiela!
  }
  else
  {
	errval := 0
	if (ctrl2 != "LastBtn")	;ten data_check wskakuje pośrednio dwa razy, ale jebać
		GoSub, data_check                              ;;NEW bo w data_check jest return gdy zmiana kontrolki
  }
  ;debug(">end stop_errcheck : focus " ctrl2, A_LineNumber)
  ;if (editing)
  ;  GoSub, errcontinue  <-- czemu to bylo
Return

#If (editing or errval) AND WinActive(APPNAME)
ENTER::
NumpadEnter::
  debug("ENTER", A_LineNumber)
  ;ControlFocus,  ;, ahk_id %lastBtn% ;Button1 ;BTNLOAD
  confirmed := 1
return
ESC::
  debug("ESC", A_LineNumber)
  if (!editing)
    GoSub, edit_canceled
  else
    canceled := 1
return
#If
#If (!editing AND !errval) AND WinActive(APPNAME)
ENTER::
NumpadEnter::
  ;ControlFocus,  ;, ahk_id %lastBtn% ;Button1 ;BTNLOAD
	ControlGetFocus, enteron, ahk_id %hWin% ;A
  debug("ENTER outside <- " enteron, A_LineNumber)
  Send, {TAB}+{TAB}
	;Send, % (enteron == BTNLOAD ? "{Space}" : "{Enter}")
  if InStr(enteron,"Button")
    Send, % "{Space}"
  ;(OutputVarA == BTNLOAD ? "{Space}" : "{Enter}")
  ;ControlClick , BTNLOAD, APPNAME
return
ESC::
  debug("ESC outside", A_LineNumber)
  GoSub, edit_canceled
return
#If

edit_proceed:
  if (resetting || RESTART)
    return
	;%ctrl1%_val := %ctrl1%  ;; to _val w koncu czy _L ?????
	;debug("edit_proceed", A_LineNumber)

	try GuiControlGet, %ctrl1%

	%ctrl1%_I := badEntry(ctrl1, RegExMatch(%ctrl1%, %ctrl1%_pattern))


	;debug("<<>> cloud btn <-- " short_qpath)     ;;TU SPRAWDZIĆ CZY TA SCIEZKA WYMAGA UPDATU
	;GuiControl, Text, CloudBtnED04, %short_qpath%
	errval := !!(%ctrl1%_I)  ;przeniesione nad if (?)

	if (ctrl1 = "eTRADER_ED01" && !errval && !eTRADER_ED01_L) {
		;GuiControlGet, enabled, Enabled, Trader_group
		;if !enabled
		eTRADER_ED01_L := %ctrl1%
		if !eTRADER_ED01_R
			eTRADER_ED01_R := %ctrl1% ;NEW
		debug("eTRADER_ED01_R_L <--- " eTRADER_ED01_R, A_LineNumber)
		enableAll()
		Sleep, 100  ;NEW ZBEDNE
	}
	else if (%ctrl1%_L != %ctrl1% && !%ctrl1%_I)  ;;==========================new przeniesione do errcheck
	{
		;debug("<<>> " ctrl1 "_L <-- " %ctrl1%)
		%ctrl1%_L := %ctrl1%
		debug("--> " ctrl1 "_L <-- " %ctrl1%, A_LineNumber)
		change(editable, changes, %ctrl1%_R != %ctrl1%)
		;debug(editable " ::::::::::::::::: " (%ctrl1%_R != %ctrl1%), A_LineNumber)
	}
  
 ; debug("err2", A_LineNumber)
  if (confirmed) {
    debug("focusing " BTNLOAD, A_LineNumber)

    ControlFocus, %BTNLOAD%, A ;, ahk_id %lastBtn% ;Button1 ;BTNLOAD    
    Send, {TAB}+{TAB}
    ;GuiControl, Focus, %BTNLOAD%
    
;		ControlGetFocus, OutputVarA, A
;		Send, % (OutputVarA == "Button2" ? "{Space}" : "{Enter}")    
  }
    
    ;here start import -------------------------------------------------------------------------------------------
    ;lub jezeli nie bylo bledow to przy globalnym sprawdzaniu
    ;przy resecie disableAll
Return

edit_canceled:
    if (resetting || RESTART)
      return
    debug("edit_canceled >>> " ctrl1, A_LineNumber)
    ;%ctrl1%_val := %ctrl1%_R
    ;%ctrl1%_L := %ctrl1%_R 
    ;Tooltip %  !%ctrl1%_L ? %ctrl1%_R : %ctrl1%_L
	try GuiControlGet, %ctrl1%
	
    GuiControl, Text, %ctrl1%, % %ctrl1%_L != 0 && currentValue(ctrl1) ;!%ctrl1%_L ? %ctrl1%_R : %ctrl1%_L
    sleep, 10
	try GuiControlGet, %ctrl1%
	%ctrl1%_I := badEntry(ctrl1, RegExMatch(%ctrl1%, %ctrl1%_pattern))
    ;change(editable, changes, 0)
	;change(editable, changes, %ctrl1%_L != 0 && !%ctrl1%_L ? %ctrl1%_R != %ctrl1% : %ctrl1%_L != %ctrl1%) ;--- new
    change(editable, changes, %ctrl1%_R != %ctrl1%) ;--- new
	;debug(editable " ::::::::::::::::: " (%ctrl1%_R != %ctrl1%), A_LineNumber)
	;debug("editable == " editable)  ;TU BYŁ KONFLIKT EDITABLE PRZY KLIKANIU W INNY EDIT BEZ POTWIERDZENIA

    if (%ctrl1% != %ctrl1%_E)
      Send, {End}
        
    ;if (ctrl1 = "eTRADER_ED01") {
    ;  if (%ctrl1%_I) 
    ;    disableAll()
    ;  else
    ;    enableAll()
    ;  Sleep, 100 ;NEW ZBEDNE
    ;}
    
    ;errval := 0
    ;debug(errval,"errval")
; }
  ;ControlFocus, %BTNLOAD%, A
Return

tab_change:
  ;tabchanging := 1  ;potrzebne tylko do <window activate> click freeze bug
  prevtab := CurrentTab

  Gui, Submit, NoHide
  nexttab := CurrentTab
  ;debug(">tab_change from " prevtab " to " nexttab, A_LineNumber)
  
  if (prevtab != nexttab)
    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Tab, %CurrentTab%
  if (nexttab = 4)
  {
	if (!Cyfry_SRB13) {
		debug(">>refreshing sliders", A_LineNumber)
		SetTimer, refresh_range, -20
	}
	GoSub, ahk_checkbooks
    ;GoSub, repaint_range
	;WinSet, Redraw, , A	
  }
  if (nexttab = 2)
	GoSub, ahk_update
	
  ;SetTimer, end_tab_changing, -50
Return

/*
end_tab_changing:
	;tabchanging := 0 
	Gui, Submit, NoHide
	nexttab := CurrentTab
    debug(">tab_change confirm " prevtab " to " nexttab, A_LineNumber)
Return
*/

refresh_range:
  GoSub, repaint_range
  WinSet, Redraw, , ahk_id %hWin% ;A	
Return

export_name:
Return

trigger_login:
Return

trigger_reload:
Return

export_pass:
Return

update_import_buttons:
  debug(">update_import_buttons", A_LineNumber)
/*
 *	<update qsync link i imports check>
*/
	GuiControl, Hide, Yellow_CloudBtnED04
	anyScriptExist := InStr(FileExist(CloudBtnED04_L), "D") && checkScriptsExist(CloudBtnED04_L)
	isAnyFullLink := checkImportFullLinks()

	;	if (CloudBtnED04_L != CloudBtnED04_D)  ;;w init_cloud_folder bylo _R !=
	;	{
	;		CloudBtnED04_I := badEntry("CloudBtnED04", 0) ;czerwona ramka
		;}
		;else if (isAnyFullLink)
		if (!RESTART)
		{
			GuiControl, Text, CloudBtnED04, % CloudBtnED04_sL ? addSlash(CloudBtnED04_sL) : CloudBtnED04_L ? addSlash(CloudBtnED04_L) : CloudBtnED04_D
			lastValue := CloudBtnED04_L ? CloudBtnED04_L : CloudBtnED04_D
			change(04, changes, lastValue != CloudBtnED04_R)
				
			Loop % DIR_SCRIPTS.Count()    ;;sortujemy wymagane skrypty
			{
				ictrl := BTN_IMPORTS[A_Index]
				GuiControl, Text, %ictrl%, % %ictrl%_sL ? %ictrl%_sL : %ictrl%_L ? %ictrl%_L : %ictrl%_D
				
				StringRight, ctrlno, ictrl, 2
				lastValue := %ictrl%_L ? %ictrl%_L : %ictrl%_D
				change(ctrlno, changes, lastValue != %ictrl%_R)
			}
		}
		
		if (anyScriptExist)
		{
			CloudBtnED04_I := badEntry("CloudBtnED04", 1)	
			RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Qsync, %CloudBtnED04_L%
			
		}
		else
		{
			;if (isAnyFullLink)
			;{
			;	CloudBtnED04_I := badEntry("CloudBtnED04", 1)	
			;	GuiControl, Show, Yellow_CloudBtnED04
			;}
			;else
			;{
				if (CloudBtnED04_L && CloudBtnED04_D != CloudBtnED04_L)
					CloudBtnED04_I := badEntry("CloudBtnED04", 0)
				else
				{
					CloudBtnED04_I := badEntry("CloudBtnED04", 1)
					GuiControl, Show, Yellow_CloudBtnED04
				}
					
				For _, ctrl in BTN_IMPORTS
				{
					hide(ctrl "_BTNUpdate")
					%ctrl%_I := badEntry(ctrl, 1)
					GuiControl, Hide, YellowB_%ctrl%
					GuiControl, Hide, YellowI_%ctrl%	
					bitUnset(deprecated, ctrlnr - 4)
				}
				if (!isAnyFullLink)
					disableGroup("Imports_")
				return
			;}
		}
		enableGroup("Imports_")
		GoSub, ahk_update

	
Return


read_import_links:
  debug(">read_import_links " (manual_confirming ? "--> confirming" : (manual_parsing ? "--> parsing" : "")), A_LineNumber)
  
  ;CloudBtnED04_R := CloudBtnED04_D 
	;importy
	;CloudBtnED04_R := CloudBtnED04_D ;;cloud przed cloud_init
;jezeli nie ma luzem katalogu ogówlnego sprawdzić autohotkey\czy jakis skrypt istnieje z default 

;IMPORT LINKS JUZ PRZY SPRAWDZANIU CZY POPRAWNY SKRYPT/PRZESTARZAŁY
	if (manual_parsing) {
		GoSub, manual_input
		return
	} else if (manual_confirming) {
		if (importz)
			GoSub, manual_confirm
		return
	}	
	
	CloudBtnED04_L := ;CloudBtnED04_D   ;;0
	CloudBtnED04_sL :=
			
	Imports_apiED05_sL :=
	Imports_bookED06_sL :=
	Imports_chartED07_sL :=
	Imports_symED08_sL :=

	Imports_apiED05_L := ;Imports_apiED05_D  ;;importy
	Imports_bookED06_L := ;Imports_bookED06_D
	Imports_chartED07_L := ;Imports_chartED07_D
	Imports_symED08_L := ;Imports_symED08_D
	
	Imports_apiSW05_L := ;Imports_apiSW05_D  ;;switche
	Imports_bookSW06_L := ;Imports_bookSW06_D
	Imports_chartSW07_L := ;Imports_chartSW07_D
	Imports_symSW08_L := ;Imports_symSW08_D  
	

	;CHK_IMPORTS := ["Imports_bookSW06_R", "Imports_chartSW07_R", "Imports_symSW08_R"] ;;switche
	
	;ciekawe: skrypt daje sam z siebie priorytet na odkomentowane, tak jak mialoby byc
	
manual_input:
	;pos := RegExMatch(scriptBuffer, "im`nJO)^\s*;*\s*#Include\s+([^;\n]*)", OutputVar)  
	pos := 1
	importz := []
	commented := []
	noext := []
	Loop {
		pos := RegExMatch(scriptBuffer, "i`nm)^[[:blank:]]*(;*)[[:blank:]]*\#Include[[:blank:]]+([^;\n\r]+)", OutputVar, pos)
		if (pos++ <> 0)  ;;spoko, do inkrementacji nie dochodzi gdy false
		{
			;debug(" #include " OutputVar2 (OutputVar1 ? " (commented)" : "") )
			importz.Push(parsePath(OutputVar2))
			if (OutputVar1)
				commented[A_Index] := 1
		}
	} Until pos = 1
	
	;defaultOK := 0

	positions := []
	defaultDir :=
	badDirIdx :=
	expectedAHKs := 
	commonPaths := {}
	api_position :=
		
	; debug("importz length ? " importz.length(), A_LineNumber)
	
	For sfile in DIR_SCRIPTS ;_, 
	{
		expectedAHKs .= ";" sfile ;ripPath(StrSplit(sfile, "|")[2])
	}
	
	For _, importedLink in importz  ;;dwie pętle liniowe, unikamy zagnieżdżeń redukując koszt
	{

		fext  := ripPath(importedLink, 3)
		if (fext)
			fdir  := ripPath(importedLink, 2)
		fname := ripPath(importedLink)

		;if (!fext && (commented[A_Index] || defaultOK))
		;	continue
				
		if (!fext)  ;; sprawdz czy import nie jest domyslnym katalogiem
		{
			fdir  := addSlash(importedLink)
			
			noext[A_Index] := 1  ;;zaznacza czy import pod danym indexem jest ścieżką do katalogu
			;if (checkScriptsExist(fdir)) 
			;{
				;positions[1] := A_Index
			if (!commented[A_Index] && checkScriptsExist(fdir))
				defaultDir := fdir
			else if (!badDirIdx)
				badDirIdx := A_Index

				;defaultOK := 1
			;}
			;else if	(!defaultDir)  ;przypisz i tak, w razie nie znalezienia będzie w czerwonej ramce
			;{
				;positions[1] := A_Index
				;defaultDir := fdir
		    ;}

			continue
		}

		else if (fname && InStr(expectedAHKs,fname))  ;; znajdz wszystkie wymagane skrypty
		{
			;debug("[> " fname " IS VALID FILE", A_LineNumber)
			;StringUpper, scriptvar, ripPath(fname, 4)  ;;wydobądź index danego skryptu //wiem, pojebane
			scriptvar := "DIR_" RegExReplace(fname, "i)(^[[:alpha:]]+).+", "$U1")
			;msgbox % scriptvar " index: " DIR_SCRIPTS[%scriptvar%]  ; StrSplit(DIR_SCRIPTS[fname],"|")[1]
			scriptIdx := DIR_SCRIPTS[%scriptvar%]
						
			if (positions[scriptIdx] && !commented[positions[scriptIdx]])
			{
				commented[A_Index] := 1
				continue
			}
			positions[scriptIdx] := A_Index

			;update paths
;			if (!manual_parsing)
;			try {
;				ictrl := BTN_IMPORTS[scriptIdx]
;				%ictrl%_R := importedLink
;				%ictrl%_sR := buttonPath(importedLink)
;			}
			
			;potrzebne by upewnic sie ze jest odkomentowane
			if (scriptIdx == 1)
				api_position := A_Index
;			else
			;import checkbox
;			{ 
;				if (!manual_parsing)
;				try {
;					chkbox := CHK_IMPORTS[scriptIdx-1]
;					%chkbox% := !commented[A_Index]
;				}
;			}
			
			;zliczaj najpopularniejsze sciezki (wskażą domyślny katalog w razie potrzeby)
			if (!defaultDir && RegExMatch(importedLink, "i)^[A-Z]:\\"))
			{
			  needle := "i)^([A-Z]:\\.*?)" RegExReplace(%scriptvar%, "(\\)", "\\")
			  result := RegExReplace(importedLink, needle, "$1", replaceCount)
			  if (replaceCount) ; && checkScriptsExist(defaultDir))
			  {
			    commonPaths[result] := commonPaths[result] ? commonPaths[result]+1 : 1
			  }
			}
		/*  ;;rezygnujemy z ripowania katalogu z linkow (narazie, pozniej zliczymy)			
			;jezeli to dlugi link i !defaultOK, i zawiera default, rippuj go i do zmiennej i defaultOK bez sprawdzania!
			if (!defaultOK && !commented[A_Index] && RegExMatch(importedLink, "i)^[A-Z]:\\"))
			{
			  needle := "i)^([A-Z]:\\.*?)" RegExReplace(%scriptvar%, "(\\)", "\\")
			  defaultDir := RegExReplace(importedLink, needle, "$1", replaceCount)
			  if (replaceCount && checkScriptsExist(defaultDir))
			  {
  			    ;debug("[> DIR RIP :: " defaultDir, A_LineNumber)  ;sprawdzic bez pierwszego importu
			    defaultOK := 1
			  }
			}
		*/
		}
	}
	
	;wymuś api-start.ahk włączony
	if (api_position && commented[api_position])
	{
		commented[api_position] := 0
		debug("[> uncommenting api-start.ahk")
	}
	
	;jezeli brak katalogu domyslnego, spróbuj wyluskac
	if (!defaultDir && commonPaths)
	{
		mostCommon :=
		
		For path, count in commonPaths
		{
			if (!mostCommon || count > commonPaths[mostCommon])
				mostCommon := path
		}
		
		if (commonPaths[mostCommon] > 1)
		{
			defaultDir := mostCommon
			debug("[> ripping default dir ::: " defaultDir)
		}
	}

	tmpImportz := []
	if (!manual_parsing)
		validImportz := []
	
manual_confirm:	
	if (defaultDir)
	{
		if (!manual_parsing) {
			CloudBtnED04_L := remSlash(defaultDir)
			CloudBtnED04_sL := buttonPath(remSlash(defaultDir))
			if (RESTART)
			{
				CloudBtnED04_R := CloudBtnED04_L
				CloudBtnED04_sR := CloudBtnED04_sL
			}
			
		}
		if (!manual_confirming)
		{
			tmpImportz.Push("#Include " defaultDir)
			debug(" #Include " defaultDir)
			;debug("[> pushing def::: " defaultDir)
		}
	}
	else if (badDirIdx) ;&& !manual_confirming)
	{
		if (!manual_parsing && !commented[badDirIdx]) {
			tmpDir := remSlash(importz[badDirIdx])
			CloudBtnED04_L := tmpDir
			CloudBtnED04_sL := buttonPath(tmpDir)
			if (RESTART)
			{
				CloudBtnED04_R := CloudBtnED04_L
				CloudBtnED04_sR := CloudBtnED04_sL			
			}
		}
		if (!manual_confirming)
		{
			tmpDir := addSlash(importz[badDirIdx])
			if (checkScriptsExist(tmpDir))
				commented[badDirIdx] := 0
			tmpImportz.Push((commented[badDirIdx] ? ";" : "") "#Include " tmpDir)
			debug((commented[badDirIdx] ? "[" : " ") "#Include " tmpDir (commented[badDirIdx] ? "]  commented" : ""))
		}
	}
	
	Loop % DIR_SCRIPTS.Count()    ;;sortujemy wymagane skrypty
	{
	  ;idx := A_Index + 1
		;if (!manual_parsing)
		;{
			ictrl := BTN_IMPORTS[A_Index]
			
			if (positions[A_Index])
			{

				pushPath := importz[positions[A_Index]]
				cutted := StrSplit(expectedAHKs,";")[A_Index+1]

				if (defaultDir && pushPath = defaultDir cutted)
				{
					;; obcinamy full link, jezeli jest w domyślnej ścieżce
					if (!manual_confirming)
					{
						debug(importz[positions[A_Index]] " <<<<<<< " cutted, A_LineNumber)
						importz[positions[A_Index]] := cutted
					}
					if (!manual_parsing) {
						%ictrl%_L := cutted
						%ictrl%_sL := cutted
						;debug(%ictrl%_L " ::<----:: " cutted)
					
						if (RESTART)
						{
							%ictrl%_R := %ictrl%_L
							%ictrl%_sR := %ictrl%_sL
						}
					}
				}
				else if (!manual_parsing)
				{
					%ictrl%_L := pushPath
					%ictrl%_sL := buttonPath(pushPath)
					;debug(%ictrl%_L " ::<----:: " pushPath)	
				
					if (RESTART)
					{
						%ictrl%_R := %ictrl%_L
						%ictrl%_sR := %ictrl%_sL					
					}
				}

				if (!manual_parsing && A_Index > 1)  ;api-start.ahk pomijamy
				{
					chkbox := regexReplace(ictrl, "ED", "SW")

					;chkbox := CHK_IMPORTS[A_Index]
					;btnc := %chkbox%_R
					;debug("checkbox::" btnc "  checked ? " !commented[positions[A_Index]], A_LineNumber)
					%chkbox%_L := !commented[positions[A_Index]]	
					if (RESTART)
						%chkbox%_R := %chkbox%_L
					else
						GuiControl, , %chkbox%, % %chkbox%_L
				}
			}
			else if (!manual_parsing && A_Index > 1)
			{
				chkbox := regexReplace(ictrl, "ED", "SW")

				;chkbox := CHK_IMPORTS[A_Index]
				;btnc := %chkbox%_R
				;debug("checkbox::" btnc "  checked ? " !commented[positions[A_Index]], A_LineNumber)
				%chkbox%_L := !commented[positions[A_Index]]	
				if (RESTART)
					%chkbox%_R := %chkbox%_L
				else
					GuiControl, , %chkbox%, 0
			
				; GuiControlGet, enabled, Enabled, %ctrl%
				; StringRight, ctrlnr, ctrl, 2

				; GuiControlGet, ischecked ,, % regexReplace(ctrl, "ED", "SW")
			}
		;}
		if (!manual_confirming && positions[A_Index])
		{
			tmpImportz.Push((commented[positions[A_Index]] ? ";" : "") "#Include " importz[positions[A_Index]])
			debug((commented[positions[A_Index]] ? "[" : " ") "#Include " importz[positions[A_Index]] (commented[positions[A_Index]] ? "]  commented" : ""))
			;debug("[> pushing:: " A_Index ": " importz[positions[A_Index]] (commented[positions[A_Index]] ? " (commented)" : ""))
		}
	}
	
	if (manual_confirming)
	{
		importz :=
		return
	}
	;validImportz.Push("")
	validPosition :=

	For _, pointer in positions
	{
		validPosition .= ";" pointer
	}

	For _, otherLink in importz    ;;załączamy pozostałe importy
	{
	    otherLink := RTrim(otherLink, OmitChars := "\")
		if (InStr(validPosition, A_Index) || InStr(defaultDir, otherLink) || (noext[A_Index] && commented[A_Index]) || (badDirIdx && badDirIdx = A_Index))
		   continue
		 
		needle := "i)^(" RegExReplace(defaultDir, "(\\)", "\\") ")"
		tmpLink := RegExReplace(otherLink, needle, "", replaceCount)
		if (replaceCount)
			otherLink := tmpLink

	    tmpImportz.Push((commented[A_Index] ? ";" : "") "#Include " otherLink)
		debug((commented[A_Index] ? "[" : " ") "#Include " otherLink (commented[A_Index] ? "]  commented" : ""))
		;debug("[> pushing other: " otherLink (commented[A_Index] ? " (commented)" : ""))
	}

	;if (manual_parsing)
	;{
	;	if (EditorGuiCreated && WinExist(APPNAME ":  #include list ahk_class AutoHotkeyGUI"))  ; )APPNAME ":  #include list 
	;	{
	;		parseStuff := listArray(tmpImportz)
	;		GuiControl, , EditorBox, % parseStuff
	;	}
	;}
	;else
	
	if (manual_parsing)
		parseStuff := listArray(tmpImportz)
	else 
	{
		validImportz := tmpImportz
		importz :=
	}

	tmpImportz := 

	return	
	/*
manual_confirm:

	entries := 1
	extm := ripPath(validImportz[1], 3)
	if (extm)
	{
		entries++
		
	}
	
	
	validImportz[1]
	{
		if A_Index = 1
		extm := ripPath(importedLink, 3)
		
		if entries = 4
	}
	*/
return


manual_imports:
  debug(">manual_imports", A_LineNumber)

	GoSub, off_messages
	
    if !EditorGuiCreated {
		WinGetPos, x, y, WinW, WinH, ahk_id %hWin% ;A
		x_ebox := x + (WinW - EBOX_W)/2 + EBOX_XOFF
		y_ebox := y + (WinH - EBOX_H)/2 + EBOX_YOFF	
		x_btn  := EBOX_W - 190 -20
		w_edit := EBOX_W - 20
		Gui, EditorBox: +Owner1
		Gui, EditorBox: add, Text, r1 w200, edytuj wpisy ręcznie:
		;parseStuff := listArray(validImportz)
		Gui, EditorBox: add, Edit, -E0x200 -Wrap r10 w%w_edit% vEditorBox geditor_change, ;% parseStuff ;% Default
        Gui, EditorBox: add, Button, w90 x%x_btn% y+15 vEditorBoxCancel gEditorBoxCancel, Anuluj  ;&Cancel
        Gui, EditorBox: add, Button, w90 x+10 vEditorBoxOK gEditorBoxOK , Zatwierdź  ;, % ">>  Parsuj   " ;&OK
        EditorGuiCreated := true
		parsed := 1
	}
	
	Gui, 1: +Disabled
	Gui, EditorBox:Default
	GuiControl, , EditorBox, % parseStuff := listArray(validImportz)
	Gui, EditorBox: Show,  x%x_ebox% y%y_ebox% w%EBOX_W% h%EBOX_H%,% APPNAME ":  #include list"
	Send ^{Home}
	return

	EditorBoxOK:
	if (!parsed)
	{
		manual_parsing := 1
		disable("EditorBoxCancel")
		disable("EditorBoxOK")
		tmpBuffer := scriptBuffer
		scriptBuffer := changedStuff ;parseStuff
		GoSub, read_import_links
		GuiControl, , EditorBox, % parseStuff ;;parseStuff changed in read_import_links
		scriptBuffer := tmpBuffer
		manual_parsing := 0
		tmpBuffer := 
		GuiControl,, EditorBoxOK, Zatwierdź
		enable("EditorBoxCancel")
		enable("EditorBoxOK")
		parsed := 1
	}
	else
	{
		;GuiControl,, EditorBoxOK, % ">>  Parsuj   "
		;parsed := 0
		Gui, 1:Default
		
		manual_confirming := 1
		GoSub, read_import_links
		manual_confirming := 0
		;Gui, 1:Default
		
		GoSub, update_import_buttons
		;GoSub, ahk_update
		;enableGroup("Imports_")
		if (changedStuff)
			parseStuff := changedStuff
		GoSub, GuiEditorOK
	}

	return  

GuiEditorOK:
	EditorBoxGuiClose:
    EditorBoxGuiEscape:
    EditorBoxCancel:
	Gui, 1:Default
	Gui, 1: -Disabled
	GoSub, on_messages
    Gui, EditorBox: Cancel
	
    return	
	

/*
Name = Edit Text
Gui, 3: Add, Edit, x10 y10 w500 h65 vNT
Gui, 3: Add, Button, x10  y90 gLable, Start
Gui, 3: Add, Button, x140 y90 gCancel, Cancel
Gui, 3: Show, Center h120 w550, %Name%
Return
Esc::Gui, 3: Cancel

3GuiClose:
Cancel:
Gui, 3: Cancel
return

Lable:
Gui, 3: Submit, NoHide
MsgBox, 262208, , %NT%
Gui, 3: Cancel
Return
*/

	;MsgBox % EditorBox("Edytuj wpisy ręcznie:", "", APPNAME ": #include list")
  
return

editor_change:
	debug(">editor_change", A_LineNumber)
	GuiControlGet, changedStuff,, EditorBox, Text  ;;tu ok
	if (changedStuff != parseStuff)
	{
		;debug("> > changed ? true")
		GuiControl,, EditorBoxOK, % ">>  Parsuj   "
		;msgbox % "parsed:" parseStuff
		;msgbox % "changed:" changedStuff
		parsed := 0
	}
	else
	{
		;debug("> > changed ? false")
		GuiControl,, EditorBoxOK, Zatwierdź
		parsed := 1
	}
return

get_pattern_file:
	if (FileExist(PPRO8_PATTERN := CloudBtnED04_L "\PPRO8 Trader.ahk") || FileExist(PPRO8_PATTERN := CloudBtnED04_L "\PPRO8.ahk"))
		debug(">szablon PPRO8  :::  " ripPath(PPRO8_PATTERN), A_LineNumber)
	else
		debug(">szablon PPRO8  :::  brak", A_LineNumber)
return

read_defaults:
  debug(">read_defaults", A_LineNumber)
;zliczac ile nie bylo ani w skrypcie ani w szablonie -- ostrzezenie
;zamienic wszystkie = na :=
;parseInt bez cudzyslowi or w cudzyslowach

	if (PPRO8_PATTERN)
	{
		pfile := FileOpen(PPRO8_PATTERN, "rw-wd", "UTF-8")
		if IsObject(pfile)
		{
			patternBuffer := pfile.Read()
		}
		pfile.Close()
	}
	
	;;eTRADER_ED01_R := eTRADER_ED01_D	;;to gdzie indziej
	
	Trader_loginED02_R := Trader_loginED02_D
	Trader_logADR03_R := Trader_logADR03_D
	Trader_autologinSW01_R := Trader_autologinSW01_D
	Trader_reloadSW02_R := Trader_reloadSW02_D
	
	pos := RegExMatch(scriptBuffer, "ims)::(\pL+)::(?:([\pL\.]+@[\w\.]+)|(?:.*?^\s*Send(?:Input|Play)\PL+)([\pL\.]+@[\w\.]+))", OutputVar)
	if (pos) {
		login := OutputVar1 OutputVar2 OutputVar3
		if (login != LOGIN_PATTERN)
		{
			debug("-- login  <<=  " login)
			Trader_loginED02_R := login
		}
		Trader_logADR03_R := Min(StrLen(OutputVar1), 4)
		Trader_autologinSW01_R := 1
		Trader_reloadSW02_R := !OutputVar2
	}
	else
		Trader_autologinSW01_R := 0
	;;;; to samo zrobic z szablonu??? dla innych

	Trader_passED03_R := Trader_passED03_D
	Trader_pasADR04_R := Trader_pasADR04_D

	pos := RegExMatch(scriptBuffer, "::([^:\{]+)::([^:\{]+)\{(?i)enter}", OutputVar)
	if (pos && login != LOGIN_PATTERN) {
		password := OutputVar1 OutputVar2
		debug("-- pass  <<=  " password)
		Trader_passED03_R := password
		Trader_pasADR04_R := Min(StrLen(OutputVar1), 4)
	}

	
	;zmienne skryptowe
	For ctrlVar, scriptVar in SCRIPT_VARS
	{
		%ctrlVar%_R := %ctrlVar%_D
		if ((scriptValue := getVar(scriptVar)) != "")
			%ctrlVar%_R := scriptValue
	}
    
	return
	
	;stare/nowe chartzoom btns 
	;if chartzoom_imported_and_active  --- konwersja

 /*	
    i_position := 107      ; pozycja pierwszej ikony w pikselach (na wykresach prosperowskich)
    i_top := 36            ; poziom ikon w pikselach
    i_pointer := 3         ; kolejność ikony "CrossCursor" (pointera) od lewej
    i_plus := 4            ; kolejność lupy (+)
*/
	
	;gdzy imi.e nazwisko -- wyjeb
/*	
BigCross    := 40        ;; cross wyjścia dla edka
SmallCross  := 3         ;; cross wejścia dla edka
SubCross    := 3         ;; cross dla spółek poniżej dolara
HandCross   := 3         ;; cross zlecenia z ręki (api)
HalfCross   := 3         ;; cross wychodzenia połową (dla "special" nieistotne)
EntryCents  := 1         ;; powyzej/ponizej ilu centow postawic edka

defaultBuy  :=  "F4"     ;; operacje domyślne wykorzystywane do zleceń z ręki
defaultSell :=  "F8"
;specialBuy  := "+F4"    ;; operacje bezcenowe, jak np. Parallel-2D Market (zalecany do wychodzenia częścią!)
;specialSell := "+F8"    ;; ncsa nasdaq/nyse byx   buy/sell->short parallel-2D market day

polowki := "defaultdefault"     ;; operacja wychodzenia częścią akcji opcje: default/special
half_out   := "/"        ;; przycisk wychodzenia połową          (+shift :: edek)
one_out    := ","        ;; przycisk wychodzenia jedną/trzecią   (+shift :: edek)
third_out  := "."        ;; przycisk wychodzenia dwoma/trzecimi  (+shift :: edek)

limit_price_first := 0   ;; w okienku order focus na limit price
warnings := 1            ;; w razie bledow api pokazuj je w tooltipie
debuglogs := 0           ;; w razie problemow zrzuc wiecej logow na ramdisk


;----------------------------------------------------------- ustawienia booktabs.ahk
order_tab_reversed := 1  ;; kierunek taba w okienku order
updown_orders := 0       ;; strzalka góra/dół jako wejścia long/short (korzysta z defalutBuy/Sell i HandCross)
                         ;; shift + strzałka góra/dół (korzysta z specialBuy/Sell)

book_scroll := 1         ;; czy scroll myszki na booku ma operować sizem

jump_size := 50          ;; alt + numpad+/-  (zmiana "Override Lot Size" o podany skok)
jump_kmod := "!"         ;; modyfikator dla numpad+/- -> "!" alt; "^" ctrl; "+" shift; "#" win; lub 0 brak
equalizer := 0           ;; czy blokować zrównywanie size na booku po zmianie lot size
fast_size := 0           ;; czy zmiana size'u przez numpad ma działać bez ctrl (a cyfry z alt)

cyfry := 0               ;; jeżeli 1, cyfry klawiatury przenoszą na booki
                         ;; jeżeli 2, cyfry klawiatury ustawiają "Override Lot Size"
                         ;; jeżeli 0, wyłączone, ale win + cyfra dalej działa)
ctrl_tab := 1            ;; jeżeli chcesz tabować po bookach -> 1
mysz_mid := 1            ;; srodkowy myszy wysyla okienko w tlo


;--------------(można usunąć dla sierrowców)--------------- ustawienia chartzoom.ahk
i_position := 110        ;; pozycja pierwszej ikony w pikselach od lewej (na wykresach prosperowskich, wyznacz punkt w środku pierwszej ikony)
i_top := 40              ;; poziom ikon w pikselach od góry (wyznacz punkt w środku linii ikon)
i_pointer := 3           ;; kolejność ikony "CrossCursor" (pointera) od lewej
i_plus := 4              ;; kolejność lupy (+)

*/
;/////INCLUDY/////////////////////////////////////////////////////////////////////////////////

/*
#Include C:\Users\Trader\TH Cloud\Programy\AutoHotKey\   ;;<-zweryfikuj czy Trader
#Include ramdisk_api\api\API-start.ahk
#Include skrypty\booktabs.ahk
;#Include skrypty\chartzoom.ahk      ;;<-dla wykresow ppro8
#Include Symbols\Symbols.ahk
*/

/*
;/////autologin, autopass, inne///////////////////////////////////////////////////////////////

#IfWinActive (Unlock\s)?PPro8.*

#Hotstring B0 O0 k-1 *                                         ;;<-autologin
::imi::                                                        ;;popraw wyzwalacz imie (3 litery)
  SendInput, e.nazwisko@traderhouse.pl{tab}RedArt123{enter}    ;;reszta loginu + hasło
  reloading()                                                  ;;funkcja na dole skryptu
return
::Red::Art123{enter}                                           ;;hasło (do kłódki)

#IfWinActive ^(Chart\sData.*|[A-Z]+\.[A-Z]+(\.[A-Z]+)?\s\(\d+\))
NumPadDot::.
,::.

reloading:                                                     ;;przeladowanie skryptu przy wlaczaniu ppro8
  WinWait, ^.+\s-\sLive\strading\s-\sPPro8\s.+
  Reload
  reloading() {
    SetTimer, reloading, -1
  }
return
*/

return


init_cloud_folder:
  debug("init_cloud_folder", A_LineNumber)
/*
 *	<uruchamianie | tworzenie nowego configa>  ///po enableALl
 *		sprawdź czy lokalizacja istnieje heurystycznie i ze skryptu (priorytet ma link ze skryptu)
 *		cloud button -> usuń ramki czerwoną i żółtą		
 *
*/
  RegRead, Q_PATH, HKEY_CURRENT_USER, Software\TraderHouse\script, Qsync
  if (CloudBtnED04_R != CloudBtnED04_D && InStr(FileExist(CloudBtnED04_R), "D") && checkScriptsExist(CloudBtnED04_R))
  {
	if (CloudBtnED04_R != Q_PATH) {
		debug("Q_PATH := " CloudBtnED04_R, A_LineNumber)
		;RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Qsync, CloudBtnED04_R ;w ahk_founded
		Q_PATH := CloudBtnED04_R
	}
	;CREATE_NEW := 1  ;nie trzeba updatować
  } 
  else if (Q_PATH && checkScriptsExist(Q_PATH))
  {
    ;OK
  }
  else {
	EnvGet, vUserProfile, USERPROFILE

	Q_PATH :=
    For each, path in cloudpath ; Loop, %PPRO%
    {
       if (InStr(FileExist(qpath := vUserProfile "\" path "\Programy\AutoHotKey"), "D") && checkScriptsExist(qpath)) {
			Q_PATH := qpath
			break
       }
    }
	if (!Q_PATH) {
		RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Qsync, 
		GoSub, update_import_buttons
		return
	}
  }
	
/*	
  if (!CREATE_NEW && !askCloudUpdate()) ;brak zgody na update cloud    ;JEDNAK DOBRA ŚCIEŻKA JEST KRYTYCZNA, NIE PYTAJ
  {
    ;czerwona ramka tylko gdy odblok
	CloudBtnED04_I := badEntry("CloudBtnED04", 0) ;czerwona ramka
	
	;checkscriptsexist??
	;JEŻELI CLOUD JEST _D A ISTNIEJA JAKIES ŚCIEŻKI IMPORTÓW_R ŻÓŁTA RAMKA
	;JEZELI ISTNIEJE JAKIS IMPORT DOMYŚLNY LUB ZE SCIEZKI ŻÓŁTA RAMKA I ODBLOKUJ
	;INACZEJ CZERWONA CZERWONA RAMKA
	return	
  } 
*/
	
  Q_PATH := remSlash(Q_PATH)  ;StrLen(Q_PATH) > 32 ? shortenPath(Q_PATH, 29) : Q_PATH
  
  CloudBtnED04_R := Q_PATH
  CloudBtnED04_sR := buttonPath(Q_PATH)
  
  GoSub, ahk_founded
Return

relink_cloud_folder:
  debug("relink_cloud_folder", A_LineNumber)
/*
 *	<btn click>
 *		sprawdź czy lokalizacja istnieje heurystycznie i ze skryptu
 *		spytaj o lokalizację, nie zezwolić na lokalizację jeżeli nie wykryto żadnych importów
 *		dla upartych gdy zły wybór dodatkowy confirm "ponów próbę", "abort", "cancel"
 *		ok -> przejdź dalej z wpisaniem do rejestru
 *		abort -> odblokować importy, napis wybierz folder w cloud btn, żółta ramka, nie wpisuj do rejestru
 *		cancel -> return
 *
*/
  Gui +OwnDialogs  ; Forces user to dismiss the following dialog before using main window.
  EnvGet, vUserProfile, USERPROFILE
  
  RegRead, qpath, HKEY_CURRENT_USER, Software\TraderHouse\script, Qsync
  if !InStr(FileExist(qpath), "D")  
  {
	For each, path in cloudpath ; Loop, %PPRO%
	{
	   if InStr(FileExist(qpath := vUserProfile "\" path), "D") {
		  if InStr(FileExist(qpath "\Programy\AutoHotKey"), "D") {
			qpath := qpath "\Programy\AutoHotKey"
			break
		  }
	   }
	}
  }
  if !InStr(FileExist(qpath), "D")  ; nie wykryto qsync, sprawdz pierwszy import ze skryptu
  {
	if (CloudBtnED04_R != CloudBtnED04_D && InStr(FileExist(CloudBtnED04_R), "D"))
		qpath := CloudBtnED04_R
	else
		qpath := vUserProfile
  }
  Loop {
    FileSelectFolder, Folder, *%qpath%, 4, Select a folder to read:
    if not Folder  ; The user canceled the dialog.
		return
    if (InStr(FileExist(Folder), "D")) { ; Check if any expected import script exists

		if checkScriptsExist(Folder)
			break
	
		SplitPath, Folder, dir 
		if (dir = "Programy") {
		  if InStr(FileExist(Folder "\AutoHotKey"), "D") {
			Folder := Folder "\AutoHotKey"
		  }
		}
		else if hasString(cloudpath, dir) {
		  if InStr(FileExist(Folder "\Programy\AutoHotKey"), "D") {
			Folder := Folder "\Programy\AutoHotKey"
		  }
		}

		if checkScriptsExist(Folder)
			break	
			
		;iter := 0
		if (count, regexReplace(Folder, "(\\)", "\\", count)) > 1
		{ 
		;again:
		;sprawdź czy nie został wybrany wewnętrzny folder (2 poziomy max)
			Folder := directoryPop(Folder, count)
			;msgbox % Folder
			
			if checkScriptsExist(Folder)
				break
			;if (--count > 1 && ++iter < 3)
			;	GoSub, again  ;;wymaga returna? blad ahk
		}
		if (--count) > 1
		{ 
			Folder := directoryPop(Folder, count)
			;msgbox % Folder
			
			if checkScriptsExist(Folder)
				break
		}
		
		
		MsgBox, % 4096+256+48+2, %Folder%, Podany folder nie zawiera wymaganych skryptów
		IfMsgBox, Abort
		{	
			return
		}
		else IfMsgBox, Ignore
		{
			CloudBtnED04_L :=     ;gdy jest val, bierz z val, inaczej wartosc prosto z controlki
			CloudBtnED04_sL :=
			/*
			GuiControl, Text, CloudBtnED04, % addSlash(CloudBtnED04_D)
			GuiControl, Show, Yellow_CloudBtnED04
			enableGroup("Imports_")
			change(04, changes, 1) ;; chyba pominac wykrycie zmiany
			CloudBtnED04_I := badEntry("CloudBtnED04", CloudBtnED04_D != CloudBtnED04_R)			
			
			GoSub, ahk_update
			*/
			GoSub, update_import_buttons
			return
		}
	}
  }
  
  GuiControl, Hide, Yellow_CloudBtnED04
  Q_PATH := remSlash(Folder)
  S_PATH := buttonPath(remSlash(Q_PATH))  ;StrLen(Q_PATH) > 32 ? shortenPath(Q_PATH, 29) : Q_PATH
      
ahk_founded:
  debug(">ahk_founded", A_LineNumber)
  ; Check if the last character of the folder name is a backslash, which happens for root
  ; directories such as C:\. If it is, remove it to prevent a double-backslash later on.
;  StringRight, LastChar, Q_PATH, 1
;  if (LastChar = "\")
;	StringTrimRight, Q_PATH, Q_PATH, 1  ; Remove the trailing backslash.
	
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Qsync, %Q_PATH%

  CloudBtnED04_L := Q_PATH 
  CloudBtnED04_sL := S_PATH

  GuiControl, Text, CloudBtnED04, % addSlash(S_PATH)
  change(04, changes, Q_PATH != CloudBtnED04_R)
  
  CloudBtnED04_I := badEntry("CloudBtnED04", 1) 
  enableGroup("Imports_") 
 ; ```````````````````````````````````````````````````````````````````````````````````````
  
;  GoSub, import_defaults   WYJEBAC TO DO RESETING
  
  ;sprawdzic kazdy import osobno -najpierw import z ahk - pozniej w qpath (luzem i /skrypty /ramdisk_api /api) , umozliwic wybor przez fileselect
  Q_PATH :=
  S_PTAH := 
  
ahk_update:
  if (updating)
	return
  debug(">ahk_update", A_LineNumber) ;<-- [wymagania] importy odsłonięte, cloud_btn sprawdzony, odpowiednia ramka (yellow/red) zapewniona
  updating := 1
  
  ;; SPRAWDŹ CZY ISTNIEJĄ JAKIEŚ PEŁNE ŚCIEŻKI
	;;--> JEŻELI TAK, ODBLOKUJ, JEŻELI CLOUD PATH == _D -> ŻÓŁTA RAMKA (na imporcie)
	;;--> DLA PEŁNYCH ŚCIEŻEK BADENTRY PATHEXIST, CHECK UPDATE I IKONY
	;;--> DLA DOMYŚLNYCH BADENTRY SCRIPTEXIST

  GoSub, ahk_checkcharts
	
  For each, ctrl in BTN_IMPORTS
  {
	;JEZELI DISABLED -- NIE SPRAWDZAJ
	GuiControlGet, enabled, Enabled, %ctrl%
	StringRight, ctrlnr, ctrl, 2

	GuiControlGet, ischecked ,, % regexReplace(ctrl, "ED", "SW")
	;debug("ctrl " ctrl " ischecked " ischecked " enabled " enabled)
	if (!ischecked && enabled)
	{
		disableImportButton(ctrl, ctrlnr)
		enabled := 0
	}
	else if (ischecked && !enabled)
	{
		enable(ctrl)
		enabled := 1
	}

	if (!enabled)
		continue

	link := currentValue(ctrl)  ;%ctrl%_L ? %ctrl%_L : %ctrl%_R
	default := %ctrl%_D
	defaultPath := CloudBtnED04_L "\" default   ;(CloudBtnED04_L ? CloudBtnED04_L : CloudBtnED04_R) "\" default
	linkExist := FileExist(link) 
	defaultExist := FileExist(defaultPath) 
	;debug("link " link)
	;debug("default " default)
	;debug("defaultPath " defaultPath)
	;debug("CloudBtnED04_L " CloudBtnED04_L)
	;debug("CloudBtnED04_R " CloudBtnED04_R)
	if (!linkExist && link != default || link = default && !defaultExist)   ;bez roznicy czy full path czy link == default /* default == link && !defaultExist || default != link && */ 
	{
		hide(ctrl "_BTNUpdate")
		GuiControl, Hide, YellowB_%ctrl%
		GuiControl, Hide, YellowI_%ctrl%	
		bitUnset(deprecated, ctrlnr - 4)
		%ctrl%_I := badEntry(ctrl, 0)
	}
	else
	;if (default != link)
	{
		%ctrl%_I := badEntry(ctrl, 1)
		if (!defaultExist)
		{
			hide(ctrl "_BTNUpdate")
			GuiControl, Hide, YellowI_%ctrl%		
			bitUnset(deprecated, ctrlnr - 4)
			%ctrl%_I := "brak połączenia z plikiem na qsync"
			GuiControl, Show, YellowB_%ctrl%
			;GuiControl, Show, YellowI_%ctrl%
		}
		else
		if (checkScriptUpdate(link, defaultPath))
		{
			%ctrl%_I := "skrypt jest nieaktualny"
			show(ctrl "_BTNUpdate")
			GuiControl, Show, YellowB_%ctrl%
			GuiControl, Show, YellowI_%ctrl%
			bitSet(deprecated, ctrlnr - 4)
		}
		else
		{
			hide(ctrl "_BTNUpdate")
			GuiControl, Hide, YellowB_%ctrl%
			GuiControl, Hide, YellowI_%ctrl%		
			bitUnset(deprecated, ctrlnr - 4)
			;%ctrl%_I := badEntry(ctrl, 1)
		}
		Sleep, 20
	}
  }  
  ;WinSet, Redraw, , A	
  
  ;SetTimer, stop_updating, -500  ;-100

  GoSub, ahk_checkbooks
  ;AHK_UPDATED := 1
  
  updating := 0
Return


relink_import:
  debug("relink_import", A_LineNumber)
  

	  
  if (deprecated != 0x0)
  {
	;StringRight, ctrlno, A_GuiControl, 1
	;if ctrlno is not number
	;  return

	;ctrlno -= 4    ;;;------------------------check after gui modification
	btnWarrning := bitGet(deprecated, ctrlno)
	;bitUnset(deprecated, ctrlno)
	;tooltip % ctrlno . " ||| " . deprecated . " ||| " . btnWarrning

	if btnWarrning
    {
		ctrlwrn = YellowI_%A_GuiControl%
		;ControlGet, vis, Visible , , "YellowI_Imports_bookED06"
		;msg(%vis%)
		;GuiControl, Hide, %ctrlwrn%
		;GuiControl, Show, %ctrlwrn%
		;GuiControl, +Redraw, %ctrlwrn%
		GuiControl, MoveDraw, %ctrlwrn%
	}
  }

 
  if (CloudBtnED04_L != CloudBtnED04_D)
  {
    debug(CloudBtnED04_L " != " CloudBtnED04_D)
	ipath := CloudBtnED04_L
  }
  else
	RegRead, ipath, HKEY_CURRENT_USER, Software\TraderHouse\script, Qsync
  
  cpath := ipath
  ;;;; split filename 
  link := currentValue(A_GuiControl)  ;"%A_GuiControl%_L ? %A_GuiControl%_L : %A_GuiControl%_R
  fname := ripPath(link)
  def := %A_GuiControl%_D
  defPath :=
  dirPath :=
	  
  if (ipath) {
	  defPath := ipath "\" def   ;(CloudBtnED04_L ? CloudBtnED04_L : CloudBtnED04_R) "\" def
	  dirPath := ipath "\" fname
	  
	  ;;priorytet przy wybieraniu na skrypty z qsync // bedzie wkurzac ale jebać
	  if FileExist(defPath)
		ipath := defPath
	  else if FileExist(dirPath)
		ipath := defPath
	  else
		GoSub, userprofile_path
  }
  else
	GoSub, userprofile_path
	
  GoSub, import_path_ready
  
userprofile_path:
	if (!InStr(FileExist(ipath), "D"))
	{
	  ;EnvGet, vUserProfile, DESKTOP
	  ipath := A_Desktop  ;vUserProfile            ;;sprawdzic czy userprofile nie konczy sie na "\"
	}
	ipath := ipath "\" fname  
  return

import_path_ready:

  Gui +OwnDialogs  ; Forces user to dismiss the following dialog before using main window.

  Loop {
    FileSelectFile, vScriptFile, 1, %ipath%, Select %fname%:, TH Script (*.ahk)
    if not vScriptFile  ; The user canceled the dialog.
		return
	debug("vScriptFile " ripPath(vScriptFile) " def " def) 
	if (ripPath(vScriptFile) != fname)
	{
		MsgBox ,4096, Ograniczenie, Plik musi mieć nazwę %fname%.
		continue
	}
    if FileExist(vScriptFile) { ; Check if any expected import script exists

		%A_GuiControl%_L := vScriptFile
		%A_GuiControl%_sL :=
  
		;StringCaseSense
		if (cpath "\" def = vScriptFile)  ;inStr("|" cpath "\" def "|", vScriptFile)
		{
			debug("skracam link --> wybrano domyślny skrypt", A_LineNumber)
			%A_GuiControl%_L := def
		}

		if (StrLen(%A_GuiControl%_L) > 32)
		{
			%A_GuiControl%_sL := shortenPath(%A_GuiControl%_L, 29)
		}
		
		GuiControl, Text, %A_GuiControl%, % %A_GuiControl%_sL ? %A_GuiControl%_sL : %A_GuiControl%_L
		
		StringRight, ctrlno, A_GuiControl, 2
		
		debug("changing " ctrlno " to " (%A_GuiControl%_L != %A_GuiControl%_R))
		change(ctrlno, changes, %A_GuiControl%_L != %A_GuiControl%_R)

		GoSub, ahk_update
	}

	
	
	return
	/*
		if checkScriptsExist(Folder)
			break
	
		SplitPath, Folder, dir 
		if (dir = "Programy") {
		  if InStr(FileExist(Folder "\AutoHotKey"), "D") {
			Folder := Folder "\AutoHotKey"
		  }
		}
		else if hasString(cloudpath, dir) {
		  if InStr(FileExist(Folder "\Programy\AutoHotKey"), "D") {
			Folder := Folder "\Programy\AutoHotKey"
		  }
		}

		if checkScriptsExist(Folder)
			break	
			
		;iter := 0
		if (count, regexReplace(Folder, "(\\)", "\\", count)) > 1
		{ 
		;again:
		;sprawdź czy nie został wybrany wewnętrzny folder (2 poziomy max)
			Folder := directoryPop(Folder, count)
			;msgbox % Folder
			
			if checkScriptsExist(Folder)
				break
			;if (--count > 1 && ++iter < 3)
			;	GoSub, again  ;;wymaga returna? blad ahk
		}
		if (--count) > 1
		{ 
			Folder := directoryPop(Folder, count)
			;msgbox % Folder
			
			if checkScriptsExist(Folder)
				break
		}
		
		
		MsgBox, % 4096+256+48+2, %Folder%, Podany folder nie zawiera wymaganych skryptów
		IfMsgBox, Abort
		{	
			return
		}
		else IfMsgBox, Ignore
		{
			CloudBtnED04_L :=     ;gdy jest val, bierz z val, inaczej wartosc prosto z controlki
			CloudBtnED04_sL :=
			GuiControl, Text, CloudBtnED04, %CloudBtnED04_D%
			GuiControl, Show, Yellow_CloudBtnED04
			enableGroup("Imports_")
			change(04, changes, 1) ;; chyba pominac wykrycie zmiany
			CloudBtnED04_I := badEntry("CloudBtnED04", CloudBtnED04_D != CloudBtnED04_R)			
			
			GoSub, ahk_update
			return
		}
		*/
	}
  ;}
  /*
  GuiControl, Hide, Yellow_CloudBtnED04
  Q_PATH := Folder
  S_PATH := StrLen(Q_PATH) > 32 ? shortenPath(Q_PATH, 29) : Q_PATH
      
ahk_founded:
  debug(">ahk_founded", A_LineNumber)
  ; Check if the last character of the folder name is a backslash, which happens for root
  ; directories such as C:\. If it is, remove it to prevent a double-backslash later on.
  StringRight, LastChar, Q_PATH, 1
  if (LastChar = "\")
	StringTrimRight, Q_PATH, Q_PATH, 1  ; Remove the trailing backslash.
	
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\TraderHouse\script, Qsync, %Q_PATH%
  enableGroup("Imports_") 

  CloudBtnED04_L := Q_PATH 
  CloudBtnED04_sL := S_PATH

  GuiControl, Text, CloudBtnED04, %S_PATH%

  change(04, changes, Q_PATH != CloudBtnED04_R)
  ;debug(04 " ::::::::::::::::: " (Q_PATH != CloudBtnED04_R), A_LineNumber)
  CloudBtnED04_I := badEntry("CloudBtnED04", 1) 
 ; ```````````````````````````````````````````````````````````````````````````````````````
  
  if (RESTART) && (FileExist(PPRO8_PATTERN := CloudBtnED04_L "\PPRO8 Trader.ahk") || FileExist(PPRO8_PATTERN := CloudBtnED04_L "\PPRO8.ahk"))
	debug(">szablon PPRO8  :::  " ripPath(PPRO8_PATTERN), A_LineNumber)
;  GoSub, import_defaults   WYJEBAC TO DO RESETING
  */
  
  GoSub, ahk_update
return


checkScriptsExist(dir)
{
	global DIR_SCRIPTS
	For script in DIR_SCRIPTS ; Loop, %PPRO%  ;_, 
	{
	   if FileExist(addSlash(dir) script)
		  return 1
	}
	return 0
}

checkImportFullLinks()
{
	global BTN_IMPORTS
	For each, link in BTN_IMPORTS ; Loop, %PPRO%
	{
	   lVal := %link%_L ;? %link%_L : %link%_R
	   if (lVal && lVal != %link%_D)
		  return 1
	}
	return 0
}

checkScriptUpdate(script, default)
{
	if (script == default || !FileExist(script) || !FileExist(default))
		return 0

	verS := getVer(script)
	verD := getVer(default)

	if (!verS || !verD || verS == verD)
		return 0

	debug(">update ready :: " script, A_LineNumber)
	return 1
}

getVer(script_file = 0)
{
	global scriptBuffer
	if !script_file
	{
		buffer := scriptBuffer
	}
	else
	{
		file := FileOpen(script_file, "rw-wd", "UTF-8")
		if !IsObject(file)
		{
			file.Close()
			return
		}
		
		buffer := file.Read()
		file.Close()
	}
	
	needle := "i)ver\.?\s*([\d\.]+)"
	RegExMatch(buffer, needle, ver)
	
	debug("returning_version " ver)
	;debug("buffer " buffer)
	return ver1
}

buttonPath(path, max := 32)
{
	return StrLen(path) > max ? shortenPath(path, max-3) : path
}

shortenPath(path, len)
{
	pos := StrLen(path)-InStr(path, "\",, (StrLen(path)-len))+1
	needle := "^([A-Z]:\\)?.+(.{" pos "})$"
	return RegExReplace(path, needle,"$1...$2")
}

directoryPop(path, count := 1)
{
	pos := StrLen(path)-InStr(path, "\",,,count)+1
	needle := "^([A-Z]:\\?.+)(.{" pos "})$"
	return RegExReplace(path, needle,"$1")
}

ripPath(InputVar, mod := 1) ; 1 name, 2 dir, 3 ext, 4 noext, 5 drive
{
	;InputVar := RegExReplace(InputVar, "(\\{2,})", "\")
	SplitPath, InputVar, out1, out2, out3, out4, out5
	return out%mod%
}

parsePath(InputVar)
{
	return Trim(RegExReplace(InputVar, "(\\{2,})", "\"))
}

addSlash(InputVar)
{
	StringRight, LastChar, InputVar, 1
	return InputVar . (LastChar != "\" ? "\" : "")
}

remSlash(InputVar)
{
	StringRight, LastChar, InputVar, 1
	if (LastChar = "\")
		StringTrimRight, InputVar, InputVar, 1  ; Remove the trailing backslash.
	return InputVar
}
	
askCloudUpdate()
{
	MsgBox, % 4096+32+4, %APPNAME%, Czy updatować ścieżkę qsync do AutoHotKey?
	IfMsgBox, Yes
	{	
		return 1
	}
	return 0
}


select_chart_icon:
  cbtn := "1"
  cctrl = Charts_CrossED09
  GoSub, select_icon
  GoSub, grab_check
Return

select_zoom_icon:
  cbtn := "2"
  cctrl = Charts_ZoomED10
  GoSub, select_icon
  GoSub, grab_check  
Return

select_icon:
  if (!selecting_icon)
  {
    selecting_icon := 1
    grabScreenArea()
  }
  else
  {
    selecting_icon := 0
    GoSub, stop_selecting
    ;sendevent {ESC}
   ; $LButton::
  }
Return


#If selecting_icon
$LButton::WM_LBUTTONUP()
$RButton::WM_RBUTTONDOWN()
#If

update_script:  ;;aktualizuj symbols panel z wykluczeniami -> dla wojtka
Return

bind_key:
Return

rebind_btn:
	;msgbox, listview
	Send, {F2}
Return

trigger_ops:
Return

trigger_mod:
GuiControlGet, lotmod,, %A_GuiControl%, Text
modif := lotmod = "-" ? "" : "[" lotmod "] + "
GuiControl,, Lot_txt5, %modif%[numpad+/-]%lotjumptxt%
GoSub, switch_check
Return

trigger_cyfry:
Gui, Submit, NoHide
;GuiControlGet, Cyfry_LRSW13
if (Cyfry_LRB13)
  lotjumptxt := "  lub cyfry"
else
  lotjumptxt := ""
if (Cyfry_SRB13)
  ctrl_hide("Slider_")
else
  ctrl_show("Slider_")

GuiControl,, Lot_txt5, %modif%[numpad+/-]%lotjumptxt%
GoSub, switch_check
Return

apply_changes:
	;checkbox/pytanie czy zrobic kopie zapas
	;przy updacie wersji dodatkowe potwierdzenie
	;przy bledach block i skok do taba + focus
  debug("apply_changes", A_LineNumber)
  canceled := 1  ;przepisane z reset_ (?)
  errval := 0    ;-ii-
  /*
  WinGet, ActiveControlList, ControlList, A
  Loop, Parse, ActiveControlList, `n
  {
    ;TUTAJ POPRAWIC  %control%  UMOZLIWIC RESETOWANIE ZMIENNEJ GDY NOWA WARTOSC == ""
    ;GUICONTROLGET NIE UPDATUJE WARTOSCI PO ZMIANIE!! (gdzies tam bylo ze trzeba refresh, przy radio? jakies rollout)
    ;PO RESECIE RESET NIE WYGASA
    GuiControlGet, control, Name, %A_LoopField%
	StringRight, ctrlno, control, 2
    if ctrlno is number
	{
		if (RegExMatch(control, "[A-Za-z_]{3,}RB\d{2}"))
		{
			; else if RegExMatch(control, "[A-Za-z_]{3,}RB\d{2}")
			RadioGroup := RegExReplace(control, "([A-Za-z]{3,}_)[A-Za-z_]{0,}RB\d{2}","$1RB")
			if (inStr(radiobag, RadioGroup))
				continue
			radiobag := radiobag "|" RadioGroup
			if (%RadioGroup%_L != "" && %RadioGroup%_R != %RadioGroup%_L)
			{
				resetVal := %RadioGroup%_R 
				iter := 0
				For each, radio in %RadioGroup%
				{
					iter++
					GuiControl, , %radio%, % iter = resetVal
					if (iter = resetVal)
						debug("-- " RadioGroup " <-- " resetVal)
				}
				%RadioGroup%_L := iter
				change(ctrlno, switches, 0) ;--- new
				if (RadioGroup = "Cyfry_RB")
					GoSub, trigger_cyfry
			}
		}
		else if ((%control% != "" && %control%_R != ""  || control = "Trader_passED03") && ((%control%_S && %control%_S != %control%) || (%control%_R != %control%))) ;jezeli reset skrocony jak url
		{
		  reset_val := %control%_S ? %control%_S : %control%_R

		  debug("-- " control "  " %control% " <-- " %control%_R)
		  if RegExMatch(control, "[A-Za-z_]{3,}ED\d{2}")
		  {
			GuiControl, , %control%, %reset_val% ;% %control%_S ? %control%_S : %control%_R  new Text
			change(ctrlno, changes, 0) ;--- new
			if (StrLen(%control%_E) && (reset_val = %control%_E))
			{
			  Gui, Font, cSilver
			  GuiControl, Font, %control%		
			  %control%_I := badEntry(control, 1, ctrlno)  ; TUTAJ DAWAC RAMKE I PRZY INNYCH ERRCHECK, JEZELI _E NIE BYLA WARTOSCIA POCZATKOWA, RESETOWALNA... W INNYCH PUSTA? JAK ERRCHECK ZACHOWUJE SIE DO PUSTYCH, BO PRZY ZALADOWANIU PUSTE TEZ MUSZA BYC ERROR
			}      
			else
			  %control%_I := badEntry(control, RegExMatch(reset_val, %control%_pattern), ctrlno) ;tu reset_val, bo inaczej %control% trzeba odswiezyc po zmianie
		  }
		  else if RegExMatch(control, "[A-Za-z_]{3,}SW\d{2}")
		  {
			GuiControl, , %control%, %reset_val%
			change(ctrlno, switches, 0) ;--- new
		  }
		  else if RegExMatch(control, "[A-Za-z_]{3,}DR\d{2}")
		  {
			GuiControl, ChooseString, %control%, %reset_val% ;% %control%_S ? %control%_S : %control%_R  new Text
			change(ctrlno, switches, 0) ;--- new
		  }
		  %control%_L := reset_val	  
		}
	}
  }
*/
Return

GuiContextMenu:
  ;Tooltip, odpalone menu!!!
Return

GuiClose:
	;if errors or modified
	;%nowy skrypt nie skonfigurowany, %wycofać zmiany?
	file.Close()
 	ExitApp
Return

ExitApp() {
  global file, file_name
	file.Close()
}

reset_changes:
if !RESTART {
	MsgBox, % 4096+256+32+4, %APPNAME%, Wszystkie zmiany zostaną zresetowane`n-> kontynuować?
	IfMsgBox, Yes
		answer := 1
	else
		answer := 0
}
if RESTART || answer
{
  debug("reset_changes", A_LineNumber)
  confirmed := 0
  canceled := 0
  resetting := 1
  importssw := 0
  ;canceled := 1
  errval := 0
  ;editing := 0
  Sleep, 100
  editing := 1
  radiobag := 
  
  WinGet, ActiveControlList, ControlList, ahk_id %hWin% ;A
  Loop, Parse, ActiveControlList, `n
  {
    GuiControlGet, control, Name, %A_LoopField%
	GuiControlGet, controlvar,, % control  ;;controlvar potrzebne zeby odczytac wartosc z buttonow
	
	if (RegExMatch(control, "^(Red_|Yellow|Binds_special)") || (!StrLen(controlvar) /*&& (RESTART ? !%control%_D : !%control%_R)*/))
		continue	
	StringRight, ctrlno, control, 2
    if ctrlno is number
	{
		;debug("??>>> " control "  " %control% " <-- " (RESTART ? %control%_D : %control%_R))
		if RESTART
			%control%_L := %control%_sL := %control%_sR ;:= ""
		if (RegExMatch(control, "[A-Za-z_]{3,}RB\d{2}"))
		{
			; else if RegExMatch(control, "[A-Za-z_]{3,}RB\d{2}")
			RadioGroup := RegExReplace(control, "([A-Za-z]{3,}_)[A-Za-z_]{0,}RB\d{2}","$1RB")
			if (inStr(radiobag, RadioGroup))
				continue
			radiobag := radiobag "|" RadioGroup
			if (RESTART || %RadioGroup%_L != "" && %RadioGroup%_R != %RadioGroup%_L)
			{
				resetVal := RESTART ? %RadioGroup%_R := %RadioGroup%_D : %RadioGroup%_R
				iter := 0
				For each, radio in %RadioGroup%
				{
					iter++
					GuiControl, , %radio%, % iter = resetVal
					if (iter = resetVal)
						debug("-- " RadioGroup " <-- " resetVal)
				}
				%RadioGroup%_L := iter
				change(ctrlno, switches, 0) ;--- new
				if (RadioGroup = "Cyfry_RB")
					GoSub, trigger_cyfry
			}
		} ;(%control% != "" && %control%_R != ""  || control = "Trader_passED03") &&*/ 
		else if (RESTART || (%control%_sR && %control%_sR != controlvar) || (!%control%_sR && %control%_R != controlvar)) ;jezeli reset skrocony jak url
		{
		  ;reset_val := RESTART ? %control%_R := %control%_D : (%control%_sR ? %control%_sR : %control%_R)
		  /*
		  if (RESTART) 
		  {
			reset_val := %control%_L := %control%_R ;:= %control%_D
			;if (control != "CloudBtnED04")
			;	%control%_sR :=
			%control%_sL := %control%_sR ;:= 
		  }
		  else 
		  */
		  if (%control%_sR)
		  {
			if (control = "CloudBtnED04" && CloudBtnED04_R = CloudBtnED04_D)
			{
				%control%_sL := %control%_sR :=
			}
			else
			{
				debug("-- " control "_L <-- " %control%_R)
				%control%_sL := %control%_sR
				%control%_L := %control%_R
				reset_val := %control%_sR
			}
			
			if (control = "CloudBtnED04")
			{
				reset_val := addSlash(reset_val)
				importssw := 1
			}
		  }
		  else
		  {
			reset_val := %control%_L := %control%_R
		  }
	
  		  debug("-- " control "  " %control% " <-- " reset_val)

		  if RegExMatch(control, "[A-Za-z_]{3,}ED\d{2}")
		  {
			GuiControl, , %control%, %reset_val% ;% %control%_S ? %control%_S : %control%_R  new Text
			change(ctrlno, changes, 0) ;--- new
			
			if InStr("04|05|06|07|08",ctrlno)
				importssw := 1
			
			if (StrLen(%control%_E) && (reset_val = %control%_E))
			{
			  Gui, Font, cSilver
			  GuiControl, Font, %control%		
			  if !RESTART
				%control%_I := badEntry(control, 1, ctrlno)  ; TUTAJ DAWAC RAMKE I PRZY INNYCH ERRCHECK, JEZELI _E NIE BYLA WARTOSCIA POCZATKOWA, RESETOWALNA... W INNYCH PUSTA? JAK ERRCHECK ZACHOWUJE SIE DO PUSTYCH, BO PRZY ZALADOWANIU PUSTE TEZ MUSZA BYC ERROR
			}      
			else {
			  if (StrLen(%control%_E)) {
				  Gui, Font, cDefault
				  GuiControl, Font, %control%	
			  }
			  if !RESTART
				%control%_I := badEntry(control, RegExMatch(reset_val, %control%_pattern), ctrlno) ;tu reset_val, bo inaczej %control% trzeba odswiezyc po zmianie
 		    }
			if (control = "CloudBtnED04") {
				importssw := 1
			/*
			  if (reset_val = %control%_D) { ; AND NO VALID IMPORTS  ;;-------------i zadnego linku
				GuiControl, Hide, Yellow_CloudBtnED04
				disableGroup("Imports_")
			  }
			*/
			}
		  }
		  else if RegExMatch(control, "[A-Za-z_]{3,}SW\d{2}")
		  {
			GuiControl, , %control%, %reset_val%
			change(ctrlno, switches, 0) ;--- new
			
			if InStr("05|06|07|08",ctrlno)
				importssw := 1
			
			if (control = "Imports_chartSW07") {
				if (!reset_val)
				  charts_check()
				else {
				  cbtn := "1"
				  GoSub, set_last_bitmap   
				  GUI_visibility("Charts", "show")
				}
			}			
		  }
		  else if RegExMatch(control, "[A-Za-z_]{3,}DR\d{2}")
		  {
			GuiControl, ChooseString, %control%, %reset_val% ;% %control%_S ? %control%_S : %control%_R  new Text
			change(ctrlno, switches, 0) ;--- new
		  }
		  ;%control%_L := reset_val	   ; _L JEST NIEISTOTNY DLA BUTTONÓW chyba
		}
	}
  }
  if importssw
  {
	if (!RESTART)
		GoSub, update_import_buttons
	;if (importsEnabled())
	;	GoSub, ahk_update
	else if (CurrentTab = 4)
		GoSub, ahk_checkbooks
  }
  debug("<changes> : : : " changes, A_LineNumber)
  debug("<switches> : : : " switches, A_LineNumber)
  debug("<warnings> : : : " warnings, A_LineNumber)
  
     
  ;if (%eTRADER_ED01%_I) 
  ;  disableAll()
  ;else
  ;  enableAll()
  ;Sleep, 100 ;NEW ZBEDNE
  
  editing := 0
  resetting := 0
}
Return

#If WinActive(APPNAME)
^R::
  debug("clear")
  Reload
Return

TAB::
  Send {TAB}
  if (importsEnabled()) && (deprecated <> 0x0)
  {
		GUI_visibility("YellowI_", "MoveDraw")
  }
Return

+TAB::
  Send +{TAB}
  if (importsEnabled()) && (deprecated <> 0x0)
  {
		GUI_visibility("YellowI_", "MoveDraw")  
  }
Return
#If

/*
ESC::
	MsgBox, 4388,, Opuścić edytor i porzucić zmiany?
	IfMsgBox Yes
	{
			file.Close()
			ExitApp
	}
	Send {Dupa}
return
*/


setTrader(oldVar = "") {
		global eTRADER_ED01_R, scriptBuffer, full_path, path_only, file_name, file, traderCorrected, hWin ;, changes
		IfWinExist, ahk_id %hWin% ;A ;Editor  ;;wtf, gubi bycie glownym gui
		WinGetPos, x, y, w, ;, ahk_id %hWin%;, Editor ;, h czemu Gui:1 nie jest juz default??
		debug("x = " x " y = " y)
		Loop {
			InputBox, OutputVar, %file_name%, Wprowadź 8-literowe ID tradera.,, 250 , 120, w/2-124+x, 89+y   ;117+y
			If !ErrorLevel
			{
				If RegExMatch(OutputVar, "^\s*[A-Za-z]{8}\s*$")
					break
			}
			else
			{
			  ;GuiControlGet, enabled, Enabled, "eTRADER_ED01"
				;if (enabled)
				;GuiControl, Enable, eTRADER_ED01  ;%func%("eTRADER_ED01")
				GuiControl, Text, eTRADER_ED01, %oldVar%          
				eTRADER_ED01_I := badEntry("eTRADER_ED01", -1)              ;;;czy po wpisaniu przeladowywuje? bo nie odblokowuje
				eTRADER_ED01_R := oldVar
				debug("eTRADER_ED01_R <--- " eTRADER_ED01_R, A_LineNumber)
				return
			}
		}
		StringUpper, OutputVar, % Trim(OutputVar, " `t")
		
		eTRADER_ED01_R := eTRADER_ED01_L := OutputVar
		debug("eTRADER_ED01_R_L <--- " OutputVar, A_LineNumber)
		GuiControl, Text, eTRADER_ED01, %OutputVar%

		ReplaceCount :=
		
		;automatyczny update TRADERA (??) trochę inwazyjne
		try {
			idsize := 8 - StrLen(oldVar)
			needle := "TRADER\s*:?=\s*\""?\S*""?\s{" idsize "}"
			scriptBuffer := RegExReplace(scriptBuffer, needle, "TRADER := """ OutputVar """", ReplaceCount)
			tmp_file := path_only RegExReplace(file_name, ".ahk", ".tmp")
			debug("updating trader to " OutputVar, A_LineNumber)
			FileAppend %scriptBuffer%, %tmp_file%
			file.Close()
			FileMove %tmp_file%, %full_path%, 1
			file := FileOpen(full_path, "rw-wd", "UTF-8")
		}
	
		;bitSet(changes, 1)
		eTRADER_ED01_I := badEntry("eTRADER_ED01", 1)
		;GuiControl, Enable, eTRADER_ED01
		enable("LastBtn")
		
		if (!ReplaceCount)
			traderCorrected := 1
			
		return OutputVar
}

getVar(var, pattern = 1) {
	global scriptBuffer, patternBuffer, VAR_REVERSE
	needle := var "\s*:?=\s*(\S+)"
	pos := RegExMatch(pattern = 2 ? patternBuffer : scriptBuffer, needle, result)
	scriptValue := pos ? Trim(result1,"""") : -1
	
	if (scriptValue = -1)
	{
		if (pattern = 1)
		{
			scriptValue := getVar(var, 2)
			if (scriptValue = -1)
			{
				debug("-- " var "  <<=  [brak]")
				return "" ;-1
			}
		}
		else scriptValue := ""
	}
	
	if (scriptValue) && InStr(VAR_REVERSE,var)  ; != -1
	{
		scriptValue := !scriptValue
		debug("-- " var "  <<=  " scriptValue)	
	}
	
	return scriptValue
}

disableAll() {
  enableAll(0)
}

enableAll(enabling = 1) {
  global UNLOCKED
  UNLOCKED := enabling
  debug(enabling ? "<<enabling>>" : "<<disabling>>", A_LineNumber)
  ;msgbox % enabling ? "<<enabling>>" : "<<disabling>>"
	func := enabling ? "enable" : "disable"
	%func%("eTRADER_ED01")
	%func%Group("Trader_")
	;GuiControl, Font, Trader_loginED02		
	;GuiControl, Text, Trader_loginED02,
	%func%("CloudBtnED04")
	%func%("RawBtn")
	if (!enabling)
		%func%Group("Imports_")
	%func%Group("Charts_")
	;showGroup("Charts_")
	%func%Group("Cross_")
	%func%Group("Half_")
	%func%Group("Def_")
	%func%Group("Spec_")
	%func%Group("Adv_")
	%func%Group("Tab_")
	%func%Group("UD_")
	%func%Group("Cyfry_")
	GuiControlGet, Cyfry_SRB13
	if (func = "enable" && Cyfry_LRB13)
		ctrl_show("Slider_")
	else
		ctrl_hide("Slider_")
	%func%Group("Lot_")
	%func%Group("Mysz_")
	%func%Group("Order_")
	%func%Group("Binds_")
	if (!enabling)
		%func%("ResetBtn", 1)
	%func%("LastBtn", 1)
	
  ;if !enabling
  ;{
	;debug("[>enable all init cloud folder")
	;GoSub, init_cloud_folder
  ;}

}

change(ctrlno, ByRef bitbase, setting) {
	global
	If setting > 0
	{
		bitSet(bitbase, ctrlno)
		enable("ResetBtn")
		enable("LastBtn")
		if (sc_status = ACTIVE)
			GuiControl, Text, LastBtn, Załaduj Zmiany
		else
			GuiControl, Text, LastBtn, % "Załaduj i uruchom "

	}
	else 
	{
		bitUnset(bitbase, ctrlno)
		if ((switches = 0x0) && (changes = 0x0))  ;bitbase 
		{
			disable("ResetBtn")
			if !(wrongVersion||(sc_status = INACTIVE))
				disable("LastBtn")
			if (sc_status = INACTIVE && !traderCorrected)
				GuiControl, Text, LastBtn, % "Uruchom	 "
		}
	}
}

show(ctrl) {
	GuiControl, Show, %ctrl%
}

hide(ctrl) {
	GuiControl, Hide, %ctrl%
}

scriptStatus(status) {
	global ; changes, switches, sc_status, ACTIVE, INACTIVE, SCRIPT_ERROR, ImportScriptBtn_T

	If (status = ACTIVE)
	{
		GuiControl, Hide, Red_i
		GuiControl, Hide, Red_b
		GuiControl, Hide, Blue_i
		GuiControl, Hide, Blue_b
		GuiControl, Show, Green_i
		GuiControl, Show, Green_b
		GuiControl, Text, LastBtn, Załaduj Zmiany
		;ImportScriptBtn_T := "skrypt uruchomiony"
		sc_status := ACTIVE   ;scriptError := 0	inactive := 0
		if (changes = 0x0 && switches = 0x0 && !wrongVersion)
			disable("LastBtn")
	}
	else if (status = INACTIVE)
	{
		GuiControl, Hide, Green_i
		GuiControl, Hide, Green_b
		GuiControl, Hide, Red_i
		GuiControl, Hide, Red_b
		GuiControl, Show, Blue_i
		GuiControl, Show, Blue_b
		GuiControl, Text, LastBtn, % (changes <> 0x0 || switches <> 0x0 || traderCorrected) ? "Załaduj i uruchom " : "Uruchom  "
		;ImportScriptBtn_T := "skrypt nieaktywny"
		sc_status := INACTIVE   ;scriptError := 0	inactive := 1
		enable("LastBtn")
	}
	else if (status = SCRIPT_ERROR)
	{
		GuiControl, Hide, Green_i
		GuiControl, Hide, Green_b
		GuiControl, Hide, Blue_i
		GuiControl, Hide, Blue_b
		GuiControl, Show, Red_i
		GuiControl, Show, Red_b
		GuiControl, Text, LastBtn, Załaduj Zmiany
		;disable all   <---------------------------------------------------------------------------------------------
		;ImportScriptBtn_T := ""
		sc_status := SCRIPT_ERROR   ;scriptError := 1 ;inactive := 0
		if (changes = 0x0 && switches = 0x0 && !wrongVersion)
			disable("LastBtn")

	}
	else   ;; nie uzywany po pierwszym wlaczeniu
	{
		GuiControl, Hide, Green_i
		GuiControl, Hide, Green_b
		GuiControl, Hide, Red_i
		GuiControl, Hide, Red_b
		GuiControl, Hide, Blue_i
		GuiControl, Hide, Blue_b
		GuiControl, Text, LastBtn, Załaduj Zmiany
		;ImportScriptBtn_T := ""
		sc_status := 0   ;scriptError := 0	inactive := 0
		if (changes = 0x0 && switches = 0x0 && !wrongVersion)
			disable("LastBtn")
	}
}

currentValue(control) {
   return %control%_L ? %control%_L : %control%_R
}

badEntry(control, flag, num="") {
	global warnings
	if num is number
		ctrlno := num
	else
		StringRight, ctrlno, control, 2


	If flag > 0
	{
		bitUnset(warnings, ctrlno)
		GuiControl, Hide, Red_%control%
		return
	}
	else
	{
		bitSet(warnings, ctrlno)
		GuiControlGet, enabled, Enabled, %control%
		if (enabled)
		{
		  GuiControl, Show, Red_%control%
		}
		return %control%_itt
	}
}

/*
checkEntry(control, num="") {
	global warnings
	if num is number
		ctrlno := num
	else
		StringRight, ctrlno, control, 2
	if bitGet(warnings, ctrlno)
		GuiControl, Show, Red_%control%
		
	debug("<warnings> : : : " warnings " : : trader wrong ? " bitGet(warnings, ctrlno), A_LineNumber)
}
*/

enable(ctrl, force = 0) {
	global UNLOCKED ;eTRADER_ED01_L, eTRADER_ED01_R
	;debug(" enabling ==> " ctrl "  ED01_L ? " eTRADER_ED01_L "  ED01_R ? " eTRADER_ED01_R, A_LineNumber)
	if !force && InStr("ResetBtnLastBtn",ctrl) && !UNLOCKED  ;!eTRADER_ED01_L
		return
	GuiControl, Enable, %ctrl%
}

disable(ctrl) {
	GuiControl, Disable, %ctrl%
}

hideGroup(group_name) {
	GUI_visibility(group_name, "hide")
}

showGroup(group_name) {
	GUI_visibility(group_name, "show")
}

disableGroup(group_name) {
	GUI_visibility(group_name, "disable")
}

enableGroup(group_name) {
	GUI_visibility(group_name, "enable")
}

GUI_visibility(element, action) {
  global hWin
  WinGet, ActiveControlList, ControlList, ahk_id %hWin% ;A
  ;isapiactive := 1

  Loop, Parse, ActiveControlList, `n
  {

    GuiControlGet, controll, Name, %A_LoopField%
	; if (action = "enable" && element = "Imports_" && InStr(controll, "Imports_") = 1)
	; {
	  ; debug(action " > [" element "] " controll)
	; }

	if InStr(controll, element) = 1
	{
		if (action = "enable" && element = "Imports_")
		{
		  StringRight, editable, controll, 4

		  if RegExMatch(editable, "ED\d{2}")
		  {
			GuiControlGet, ischecked ,, % regexReplace(controll, "ED", "SW")
			if (!ischecked) ; || (editable = "ED06" && !isapiactive))  ;tu jeżeli wyłączać booktabs razem z api
			{
				;if (editable = "ED05")
				;	isapiactive := 0
				continue
			}
			
		  }
		  else if (editable = "SW05") ;RegExMatch(editable, "SW05") ;api-start.ahk obowiązkowy
				continue

		  ;else if (RegExMatch(editable, "SW06") && !isapiactive)
			;	continue
		}
		;if (action = "enable")
			;debug(action " :::: " control, A_LineNumber)
		
		GuiControl, %action%, %controll%
    }
  }
}
Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BindList:
if (A_GuiControl <> "Binds_list")
    return

	;	Tooltip, %A_GuiEvent%
if (A_GuiEvent = "I") {
		;Tooltip, ErrorLevel: %ErrorLevel%
		If InStr("Cc",ErrorLevel, true) { ;https://autohotkey.com/docs/commands/ListView.htm#notify
			checkboxing := 1
			SetTimer, decheck, -100
			LV_Modify(A_EventInfo, "Select")
			;If InStr("C",ErrorLevel, true)
				
			;Send, {ESC}
			return
		}
}
else if (A_GuiEvent = "Normal") {
    ;dupa := LV_SubItemHitTest(HLV)
    ;Tooltip, Column is %dupa%
}
else if (A_GuiEvent = "A") ;(A_GuiEvent = "DoubleClick")   (A_GuiEvent = "Normal") || 
{
		col := LV_SubItemHitTest(HLV)
		if (col = 1)
			Send {F2}
}
else if (A_GuiEvent = "e")
{
		;Tooltip, edycja udana row number %A_EventInfo%. Text: "%RowText%"
		;Tooltip, 
}
else if (A_GuiEvent = "RightClick")
{
		;Menu, context, ToggleEnable
		;Menu, context, Show
}
else if (A_GuiEvent = "C")
{
		if GetKeyState("RButton")
			SetTimer, show_menu, -1
}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

decheck:
	checkboxing := 0
return

show_menu:
	if (!checkboxing)
		Menu, context, Show
return

create_cmenu:
 menu, context, add ; separator
 menu, context, add, Notepad
 menu, context, add, Calculator
 menu, context, add, Section3
 menu, context, add, Section4
 menu, context, add, Section5
return



Notepad:
   Run, Notepad.exe
Return


Calculator:
   Run, Calc
Return


Section3:
   msgbox, You selected 3
Return


Section4:
   msgbox, You selected 4
Return


Section5:
   msgbox, You selected 5
Return


checkScriptRunning(instant = 0) {
	global ; full_path, file_name, sc_status, exclude, REG_PATH, APPNAME, APPFULLNAME, SCRIPT_ERROR, ACTIVE, INACTIVE
	
	tmm := A_TitleMatchMode
  SetTitleMatchMode, 2
	scriptHWND := WinExist(full_path " ahk_class AutoHotkey")
	_otherHWND  := WinExist("\" file_name " ahk_class AutoHotkey")

	if ((!scriptHWND && (sc_status <> SCRIPT_ERROR)) || ((sc_status = SCRIPT_ERROR) && _otherHWND)) ; && _otherHWND != scriptHWND))
	{
		if (_otherHWND || sc_status = SCRIPT_ERROR)
		{
  		SetTitleMatchMode, RegEx
			;WinClose, ahk_id %scriptHWND% ???
			WinGetTitle, outVar, % "i)\\\Q" file_name "\E"
			if (scriptHWND)
			{
				;REG_PATH := full_path
				;GoSub, register_script
				;REG_PATH :=
				;SetTitleMatchMode, %tmm%
			;	return 1				
        MsgBox, % 4096+48, %APPFULLNAME%, Wykryto działający skrypt ale plik przeniesiono lub usunięto.`nImportuj go z nowej ścieżki. ;`n`nJeżeli go usunięto, odzyskanie z pamięci`njest nie możliwe.
        SetTitleMatchMode, RegEx
        WinGetTitle, outVar, % "i)\\\Q" file_name "\E"
        scriptHWND := ""
        exclude := "\Q" outVar "\E"      
        GoSub, exit_sr
        return
			}
			MsgBox, % 4096+48+4, %APPFULLNAME%, % (instant ? "Uruchomiono skrypt" : "Twój skrypt działa" ) " z nowej lokalizacji.`n`n-> zatwierdzić nową ścieżkę?"
			IfMsgBox, Yes
			{
				RegExMatch(outVar, "i)(.+\\[^\\]+\.ahk)", pathFound)
				REG_PATH := pathFound1
				;scriptStatus(ACTIVE)    ;;active juz stad
				GoSub, register_script
				REG_PATH :=
				SetTitleMatchMode, %tmm%
				return 1
			}
			else
			{
				scriptHWND := ""
				exclude := "\Q" outVar "\E"
			}
		}
		else if (_otherHWND)  ;& !scriptHWND
		{
			;WinActivate, %APPNAME% 
			MsgBox, % 4096+48+4, %APPFULLNAME%, % (instant ? "Uruchomiono skrypt" : "Wykryty skrypt działa" ) " z nieznanej ścieżki!`n`n-> przeładować go z poprawnej lokalizacji?"
			IfMsgBox, Yes
			{
				WinClose, ahk_id %_otherHWND%
				run, %full_path%
				WinWait %full_path%,, 4
				scriptHWND := WinExist(full_path " ahk_class AutoHotkey")
			}
			else
			{
				SetTitleMatchMode, RegEx
				WinGetTitle, outVar, % "i)\\\Q" file_name "\E"				
				scriptHWND := ""
				exclude := "\Q" outVar "\E"
			}
		}
	}
;	else if (scriptHWND && (sc_status = SCRIPT_ERROR))
;	{
;		MsgBox, % 4096+48, %APPFULLNAME%, Wykryto działający skrypt ale plik przeniesiono lub usunięto.`nImportuj go z nowej ścieżki. ;`n`nJeżeli go usunięto, odzyskanie z pamięci`njest nie możliwe.
;		SetTitleMatchMode, RegEx
;		WinGetTitle, outVar, % "i)\\\Q" file_name "\E"
;		scriptHWND := ""
;		exclude := "\Q" outVar "\E"
;	}

exit_sr:
	if (scriptHWND)
	{
		scriptStatus(ACTIVE)
		sleep, 100
		scriptUnsuspend(scriptHWND)
	}
	else if (sc_status <> SCRIPT_ERROR)
		scriptStatus(INACTIVE)
		
	WinSet, Redraw, , %APPNAME%
	SetTitleMatchMode, %tmm%
	return !(!scriptHWND)
}

/*	
	;WinGetTitle, outVar, PPRO8_new.ahk
	;RegExMatch(outVar, "i)(.+\\[^\\]+\.ahk)", pathFound)
	;If (scriptHWND)
	;	msgbox, [%full_path%] [%pathFound1%]
	
  If (scriptHWND)
	{
		scriptStatus(ACTIVE)
		ScriptSuspend(scriptHWND)
	}
	else
	{
		scriptStatus(INACTIVE)
	}
*/


watch_script_open:
	SetTitleMatchMode, RegEx
	needle := "i)\\\Q" file_name "\E|\\_reset\.ahk"
WinWait, %needle%,,, %exclude%              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	WinGetTitle, vscript, % StrSplit(needle, "|")[1]
	if (!vscript)             ;;reset triggered
	{	
		exclude :=
		sleep 1000
		GoSub, % (sc_status = INACTIVE ? "watch_script_open" : "watch_script_close")   ;;prawie dziala, moze zalegac z poprzedniego
		return
	}
	if (!checkScriptRunning(1))
	{
		exclude := "\Q" vscript "\E"
		GoSub, watch_script_open
		return
	}
watch_script_close:
	SetTitleMatchMode, RegEx
	needle := "i)\Q" full_path "\E"
WinWaitClose, %needle%                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  clones := WinExist("\" file_name " ahk_class AutoHotkey")
	WinClose, ahk_id %clones%
	scriptStatus(INACTIVE)
	GoSub, watch_script_open
Return


addons:
	;Gui, Submit, NoHide
	GuiControlGet, pressed,, AddonsBtn, Value
	if (pressed)
		Menu, AddonsList, Show, -3, 432
	else
		GuiControl,, AddonsBtn, 0
Return

restore_windows:
	dhw := A_DetectHiddenWindows
	DetectHiddenWindows Off
	GroupAdd, AllWindows
	WinRestore, ahk_group AllWindows
	DetectHiddenWindows %dhw%
	GuiControl,, AddonsBtn, 0
Return

kill_prosper:
	MsgBox, % 4096+256+48+4, %APPNAME%, Prosper zostanie siłowo zamknięty (!)`n-> kontynuować?
	IfMsgBox, Yes
	{
		PPRO := ["PPro8.exe","CDSD.exe","StockWindow.exe","TimeOfSale.exe","Logger.exe","IPMD.exe","PProApi.exe","Messages.exe","HistoryLog.exe","ChartWindow.exe","Summary.exe","QuoteBoard.exe"]
		For each, proc in PPRO ; Loop, %PPRO%
		{
			Runwait, taskkill /im %proc% /t /f  ;Process,Close,%proc%
		}
	}
	GuiControl,, AddonsBtn, 0
Return

/*
WinWait(winText="", timeOut="") {
    static break
    break := !winText
;   (timeOut) && t1 := A_TickCount

    Loop
        Sleep -1
    Until (WinExist(winText) && state := "exist")
        || (break && state := "break")
 ;       || (t1 && A_TickCount-t1 >= timeOut && state := "timeout")

    return ;state
}
*/

AddonsMenu()
{
	Global AddonsList
	Menu, AddonsList, Add, % "  Przywróć okna", restore_windows            
	try Menu, AddonsList, Icon, % "  Przywróć okna", shell32.dll, 250   ;;88vs91
	Menu, AddonsList, Add, % "  Zabij Prospera", kill_prosper
	try Menu, AddonsList, Icon, % "  Zabij Prospera", imageres.dll, 162    
}


grabScreenArea()
{
;sometimes this helps to ensure more consistent results when switching from one window to another
  global ;selecting_icon, iconready

  ;mierzyc dopiero poza buttonem (zmiana ikony)
  
  selecting_icon=1
  widthToScan=30
  heightToScan=30
  Hotkey, ESC, grab_hovered, On
  
  OnMessage(0x200,"WM_MOUSEMOVESELECTING")
  OnMessage(0x201,"") 
  OnMessage(0x204,"") 
  ;OnMessage(0x202,"WM_LBUTTONUP")
  ;OnMessage(0x204,"WM_RBUTTONDOWN")
  iconready=0
	cursor1:=DllCall( "LoadCursor","UInt","","Int",32515)
	cursor2:=DllCall( "LoadCursor","UInt","","Int",32512)  
  ;DllCall("SetCursor","UInt",cursor1)
  
  Cursors = 32512,32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651
  Loop, Parse, Cursors, `,
  {
    DllCall( "SetSystemCursor", Uint, cursor1, Int, A_Loopfield )
  }  
  
  coord :=
  ;pToken:=Gdip_Startup()
  
  pCrossh := Gdip_CreateBitmapFromFile(crosshair)
  ;hCrossh := Gdip_CreateHBITMAPFromBitmap(pCrossh)
  
  hovering := 1
  
  CoordMode, Mouse, Screen
  Loop
  {
    if (hovering)
      GoSub, skip_hover
  
   ;figuring out what region we will scan (the area around the mouse)
   MouseGetPos, cX, cY, winID
   topLeftX := cX - (widthToScan / 2)
   topLeftY := cY - (heightToScan / 2)

   ;update coords txt
   CoordMode Mouse, Screen
   MouseGetPos, cX, cY, winID
   WinGet proc, ProcessName, ahk_id %winID%
   ;GuiControlGet, coord,, %cctrl%, Text
    
    
   if (proc = "ChartWindow.exe") {  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MIGOTANIE
     WinGetPos x, y, , , ahk_id %winID%
     crd := cX-x "," cY-y
     if (coord != crd)
       Tooltip % coord := crd
      ;GuiControl, Text, %cctrl%, %crd%
     
   }
   else if (coord != "") {
     Tooltip,
     coord :=
    ;GuiControl, Text, %cctrl%,
   }

   ;dest=%A_ScriptDir%\img\
   ;filenameJpg=%dest%mousegrab.jpg


   ;take a screenshot of the specified area
   ;pToken:=Gdip_Startup()
   pScreen:=Gdip_BitmapFromScreen(topLeftX "|" topLeftY "|" widthToScan "|" heightToScan)  ; Gdip_CreateBitmapFromFile(folder_a "\" ColorChoice ".png")
   ;Gdip_SaveBitmapToFile(pBitmap, filenameJpg, jpegQuality)
   ;Gdip_Shutdown(pToken)
   
   ;SetImage won't take pBitmap
 ;  hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)

   canvas := Gdip_CreateBitmap(widthToScan,heightToScan)  ;create a new bitmap with the width of both windows
   g := Gdip_GraphicsFromImage(canvas)   

   Gdip_DrawImage(g, pScreen, 0, 0, widthToScan, heightToScan)
   Gdip_DrawImage(g, pCrossh, 0, 0, widthToScan, heightToScan)
   
   hBitmap := Gdip_CreateHBITMAPFromBitmap(canvas)
   ;hpControl is the hwnd of the picture control, hBitmap is the image from the disk
   ;This is what actually puts the image into the picture control.
   ;SetImage(Charts_icon, hBitmap)  <----working
   ;SetImage(Charts_crosshair, hCrossh)   
   Ext_Image(btnC%cbtn%, hBitmap)

skip_hover:   
   Sleep, 100 ;15 min = 900000
   ;chartbtn1=%dest%mousegrab.jpg
   ;GuiControl, -Redraw, Charts_icon
   ;GuiControl,, Charts_icon, %chartbtn1%
   ;GuiControl, +Redraw, Charts_icon
   
   continue
grab_hovered:
   GoSub, set_last_bitmap
   GoSub, stop_selecting
   return
  } until (iconready)
}

stop_selecting:
   Hotkey, ESC, Off
   ;OnMessage(0x202,"")
   ;OnMessage(0x204,"")
   ;Free memory
   DeleteObject(hBitmap)
   ;DeleteObject(hCrossh)
   Gdip_DisposeImage(pBitmap)   
   Gdip_DisposeImage(pScreen)   
   Gdip_DisposeImage(pCrossh)   
   ;Gdip_Shutdown(pToken)
   OnMessage(0x200,"WM_MOUSEMOVE") 
   OnMessage(0x201,"WM_MOUSEMOVE") 
   OnMessage(0x204,"WM_MOUSEMOVE") 
   iconready=1
   ;DllCall("SetCursor","UInt",cursor2)
   SPI_SETCURSORS := 0x57
   DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 ) ; Reload the system cursors   
   selecting_icon=0
Return

set_last_bitmap:
   p2Bitmap := charts_set(cbtn) ;Gdip_CreateBitmapFromFile(FileExist(chartbtn%cbtn%) ? chartbtn%cbtn% : crossoff)
   h2Bitmap := Gdip_CreateHBITMAPFromBitmap(Gdip_CropImage(p2Bitmap, 5, 4, 20, 21))

   Ext_Image(btnC%cbtn%, h2Bitmap)     
   ;new -- update both icons
   other := 3 - cbtn

   p2Bitmap := charts_set(other) ;Gdip_CreateBitmapFromFile(FileExist(chartbtn%cbtn%) ? chartbtn%cbtn% : crossoff)
   h2Bitmap := Gdip_CreateHBITMAPFromBitmap(Gdip_CropImage(p2Bitmap, 5, 4, 20, 21))
   
;   Gdip_DrawImage(g, pBitmap, 0, 0, widthToScan, heightToScan)
;   Gdip_DrawImage(g, pCrossh, 0, 0, widthToScan, heightToScan)
;   hBitmap := Gdip_CreateHBITMAPFromBitmap(canvas)
   
   Ext_Image(btnC%other%, h2Bitmap)   
   ;SetImage(Charts_icon, hBitmap)  ;<---working
    
   DeleteObject(h2Bitmap)
   Gdip_DisposeImage(p2Bitmap)   
Return


focuscheck:
	GuiControlGet, ctrl1, FocusV 
	Loop
	{
		Sleep, 100
		GuiControlGet, ctrl2, FocusV 
		if (ctrl2 != ctrl1)
			break
	}
  Sleep, 50
  if (importsEnabled()) && (deprecated <> 0x0)
  {
		GUI_visibility("YellowI_", "MoveDraw")  
  }
Return


WM_MOUSEMOVESELECTING(btn, lparam, msgx) {
  global
  ctrl := A_GuiControl
  
  activebtn := (cbtn = "1" ? "Charts_Cross_Btn" : "Charts_Zoom_Btn")

  if (!btnOut && ctrl != activebtn)
    btnOut := 1
  
  if (ctrl = activebtn) {
    hovering := 1
    if (btnOut) {
      GoSub, set_last_bitmap 
      btnOut := 0
    }
  }
  else
    hovering := 0
}

/*
WM_NOTIFY(wP,lP) {
 static NM_Click := -2, lastTime := 0
 ;debug(">>WM_NOTIFY wP:" wP " lP:" lP A_GuiControl, A_LineNumber)
 If (NumGet(0+lP,(A_PtrSize ? A_PtrSize:4)*2,"Int") = NM_Click) {
  ;If (A_TickCount - lastTime < 500) {  ;DoubleClick
   SetTimer, confirm_tab, -200
  ;}
  ;lastTime := A_TickCount
 }
}

confirm_tab:
  ; Gui, Submit, NoHide
   GuiControlGet, name,,CurrentTab
   debug("You Clicked tab " name)
Return
*/

WM_MOUSEMOVE(btn, lparam, msgx) {  ;0x200 mousemove 0x201 lbuttondown 0x204 rbuttondown
	global ;loaded, TT5s, logb4
  
  ctrl := A_GuiControl
  MouseGetPos,,,,m_ctrl
	
  if (msgx = 0x201) {
	;if (m_ctrl = TABCTRL) ;&& (!enabled)
	;{
		;GuiControl, Enable, CurrentTab
;		IfWinActive, tablayer
			;Gui, 7:Hide
	;}
  
    if (importsEnabled()) && (deprecated <> 0x0)   ;; check import scripts up to date warrning
    {
        GUI_visibility("YellowI_", "MoveDraw")  
	}

    if ctrl {
      if InStr(">" . ctrl, ">Imports_") {
        ;GuiControl, MoveDraw, %ctrl%     
        SetTimer, focuscheck, -1
      }
      if InStr("Slider_Slider1Slider_Slider2", ctrl)
        SL_LBUTTONDOWN()
    }
  }

	cursor1:=DllCall( "LoadCursor","UInt","","Int",32649)
	cursor2:=DllCall( "LoadCursor","UInt","","Int",32512)

	if (btn > 0)
	{
		if (ctrl != "AddonsBtn")
			GuiControl,, AddonsBtn, 0
		else if (btn > 1)
			GuiControl,, AddonsBtn, 0


    try GuiControlGet, %ctrl%
    if (StrLen(%ctrl%_E) && (%ctrl% = %ctrl%_E))  ;;!logb4 && ctrl == "Trader_loginED02")
    {
      GuiControl, Font, %ctrl%		
      GuiControl, Text, %ctrl%,
    }      
	}
		
	GUIControlGet, enabled, Enabled, %m_ctrl% ;ControlGet, enabled, Enabled,, %m_ctrl%
	If InStr(m_ctrl,"Button") && (ctrl) && (enabled) ;60  ;If (ctrl = "LastBtn")
	{
		loaded:=1
		DllCall("SetCursor","UInt",cursor1)
		;Tooltip, %m_ctrl% %ctrl%
	}
	Else If (loaded = 1)
	{
		DllCall("SetCursor","UInt",cursor2)
		loaded:=0
	}

	static CurrControl, PrevControl, _T
	CurrControl := ctrl
	If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
	{
			ToolTip  ; Turn off any previous tooltip.
			SetTimer, DisplayToolTip, 1000
			PrevControl := CurrControl
	}
	return
	
DisplayToolTip:
	SetTimer, DisplayToolTip, Off
	if %CurrControl%_I
		ToolTip % %CurrControl%_I
	else
		ToolTip % %CurrControl%_T
	If InStr(TT5s,CurrControl)
			SetTimer, RemoveToolTip, -6000
	else
			SetTimer, RemoveToolTip, -3500
	return

	RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
	return
}

Tooltip(msg, duration) {
  Tooltip % msg
  dur := duration * -1000
  SetTimer, RemoveToolTip, %dur%
}

WM_MOVE() {
  global APPNAME
	WinGetTitle, title, A
	If (title != APPNAME)
		return
	WinGetPos, mx, my
	If (mx < -10000 || my < -10000)
		return
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\TraderHouse\script, WinX, %mx%
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\TraderHouse\script, WinY, %my%
	;RegRead, WinX, HKEY_CURRENT_USER, Software\TraderHouse\script, WinX
	;RegRead, WinY, HKEY_CURRENT_USER, Software\TraderHouse\script, WinY
	;WinX := WinX << 32 >> 32
	;WinY := WinY << 32 >> 32
	;Tooltip % "[" mx " " my "] [" WinX " " WinY "]" 
}

WM_ACTIVATE(lparam)
{
	global tabchanging, LAYER_XOFF, LAYER_YOFF
	;disable("CurrentTab")
	;debug(">wm_activate " lparam)
	if (WinActive()) {  ;lparam  "ahk_id " hWin APPNAME
		debug("<window activate>", A_LineNumber)
		;GuiControl, Enable, CurrentTab
		Sleep, 20
		Gui, 7:Hide
		OnMessage(0x201,"") 
		Gui, 1:Default  ;%hWin%
	}
	else
	{
		WinGetPos, x, y
		x_layer := x + LAYER_XOFF
		y_layer := y + LAYER_YOFF
		Gui, 7:Show, x%x_layer% y%y_layer% NoActivate,
		;Winset, AlwaysOnTop, Off
		OnMessage(0x201,"WM_LAYERCLICK") 
		Gui, 1:Default
		if (SHOWLAYER)
			debug(">>>>>> showing layer", A_LineNumber)
		;WinGet, style, Style, ahk_id %hWin%
		;Transform, result, BitAnd, %style%, 0x10000000 ; 0x10000000 is WS_VISIBLE. 
		
		;debug("x = " x "  y = " y)
	}

	SetTimer, activation_check, -200  ;-100
}

activation_check:
	if (importsEnabled())
		GoSub, ahk_update
	else
		GoSub, ahk_checkbooks
Return

reenalbe_tabs:
	enable("CurrentTab")
Return

importsEnabled()
{
	global CurrentTab
	if (CurrentTab = 2)
	{
		GuiControlGet, enabled, Enabled, Imports_group
		return enabled
	}
	else
		return 0
}

WM_FOCUS()  ;;po restarcie nie przechodzi do data_check <--- ale WM_FOCUS nie jest winien
{ 
  global hintCtrl, editing ;, ctrl1


  ;GuiControlGet, tabsenabled, Enabled, CurrentTab
  ;if !tabsenabled
;	enable("CurrentTab")
  /*
  If (!A_CaretX) {
    editing := 0     ;;---new
    Tooltip, edit out
  }
  else {
    editing := 1     ;;---new
    Tooltip, edit In
  }
  */
 
;  GuiControlGet, ctrlhwnd, Focus  ;Retrieves the control identifier (ClassNN) for the control that currently has keyboard focus.
;  If InStr(ctrlhwnd, "Edit") {
    ;editing := 1     ;;---new
    ;Send, {END}
    ;Send, ^a
;    GuiControlGet, ctrl1, FocusV   ;new, to bylo niepotrzebne? czasem blokuje data_check i wariuje input focus
;    debug("focus " ctrl1, A_LineNumber)
;    errval := !!(%ctrl1%_I)
;    if (errval) {
;      debug("err3", A_LineNumber)
;      GoSub, errcheck    
;    }
    ;ctrl1 = ctrlname
    ;GoSub, data_check
;  }
;  else
;  {
;    errval := 0
    ;debug("focus not edit", A_LineNumber)
;    editing := 0
    ;inputing := 0
;  }

  GuiControlGet, ctrlname, FocusV  ; Retrieves the name of the focused control's associated variable.

  ;Tooltip % %ctrlname%_L
 ; if (ctrlname = hintCtrl)
 ;   return
 ; else
  if InStr("Slider_Slider1Slider_Slider2", ctrlname)
  {
    SL_COMMAND(ctrlname)  
    return
  }
  try GuiControlGet, %ctrlname%
  if (StrLen(%ctrlname%_E) && (%ctrlname% = %ctrlname%_E))  ;;!logb4 && A_GuiControl == "Trader_loginED02")
  {
    ;debug("E pattern", A_LineNumber)
    Send {Home}
    hintCtrl := ctrlname
  }
}

WM_LAYERCLICK(wParam, lParam)
{
	global hWin
    ;X := lParam & 0xFFFF
    ;Y := lParam >> 16
	WinActivate , ahk_id %hWin%
}

WM_LBUTTONUP() {
  global
  ;debug(">wm_lbuttonup", A_LineNumber)
  ;msg("left button up")
  ;pBitmap := Gdip_CreateBitmapFromFile(chartbtn1)
  CoordMode Mouse, Screen
  MouseGetPos, cX, cY, winID
  WinGet proc, ProcessName, ahk_id %winID%
  
  if (proc != "ChartWindow.exe") {
    GoSub, stop_selecting    
    selecting_icon := 0
    MsgBox ,4096,, To nie jest okienko wykresu, kmiocie.
    GoSub, set_last_bitmap
    Tooltip,
    ;%cctrl%_val := %cctrl%_R
    ;GuiControl, Text, %cctrl%,
    return
  }
  
  WinGetPos x, y, , , ahk_id %winID%
  
  iconX := cX-x  ;90 25 45
  iconY := cY-y
  
  if (A_Cursor != "Arrow" || iconX < 90 || iconY < 25 || iconY > 45) {
    ;GoSub, stop_selecting    
    ;selecting_icon := 0
    ;MsgBox, jesteś poza zakresem ikon..
    Tooltip("Wybór poza zakresem ikon...", 2.3)
    ;GoSub, set_last_bitmap
    return
  }
    
  hBitmap := Gdip_CreateHBITMAPFromBitmap(Gdip_CropImage(pScreen, 5, 4, 20, 22))
  Ext_Image(btnC%cbtn%, hBitmap)
  
  ;crd := iconX "," iconY
  Tooltip,
  %cctrl%_L := iconX "," iconY
  ;GuiControl, Text, %cctrl%,
  ;jpegQuality := 100
  ;Gdip_SaveBitmapToFile(pScreen, chartbtn%cbtn%, jpegQuality)
  
  selecting_icon := 0
  GoSub, stop_selecting  
}

WM_RBUTTONDOWN() {
   global
   ;debug(">wm_rbuttondown", A_LineNumber)
   ;pBitmap := Gdip_CreateBitmapFromFile(chartbtn1)
   ;hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
   ;SetImage(Charts_icon, hBitmap)   
   GoSub, set_last_bitmap  
   Tooltip,
   ;%cctrl%_L := %cctrl%_R
   ;GuiControl, Text, %cctrl%,
   selecting_icon := 0
   GoSub, stop_selecting
}

LV_SubitemHitTest(HLV) {
   Static LVM_SUBITEMHITTEST := 0x1039
   VarSetCapacity(POINT, 8, 0)
   DllCall("User32.dll\GetCursorPos", "Ptr", &POINT)                 ; Get the current cursor position in screen coordinates
   DllCall("User32.dll\ScreenToClient", "Ptr", HLV, "Ptr", &POINT)   ; Convert them to client coordinates related to the ListView
   VarSetCapacity(LVHITTESTINFO, 24, 0)                              ; Create a LVHITTESTINFO structure (see below)
   NumPut(NumGet(POINT, 0, "Int"), LVHITTESTINFO, 0, "Int")          ; Store the relative mouse coordinates
   NumPut(NumGet(POINT, 4, "Int"), LVHITTESTINFO, 4, "Int")
   SendMessage, LVM_SUBITEMHITTEST, 0, &LVHITTESTINFO, , ahk_id %HLV%  ; Send a LVM_SUBITEMHITTEST to the ListView
   If (ErrorLevel = -1)                                              ; If no item was found on this position, the return value is -1
      Return 0
   Subitem := NumGet(LVHITTESTINFO, 16, "Int") + 1                   ; Get the corresponding subitem (column)
   Return Subitem
}


LV_Set_Column_Order( _Num_Of_Columns, _New_Column_Order) {
    local colOrder, pos
		LVM_FIRST               := 0x1000
		LVM_REDRAWITEMS         := 21
		LVM_SETCOLUMNORDERARRAY := 58
		LVM_GETCOLUMNORDERARRAY := 59
		
    VarSetCapacity( colOrder, _Num_Of_Columns * 4, 0 )
    Loop, Parse, _New_Column_Order, "|"
		{
        pos := A_Index-1
        NumPut(A_LoopField-1, colOrder, pos*4, "UInt" )
    }
    SendMessage, LVM_FIRST + LVM_SETCOLUMNORDERARRAY, _Num_Of_Columns, &colOrder, SysListView321, A
    ;SendMessage, LVM_FIRST + LVM_REDRAWITEMS, 0, _Num_Of_Columns - 1, SysListView321, A  
		GuiControl, +Redraw, Binds_list
    VarSetCapacity( colOrder, 0 )
}


scriptUnSuspend(scriptHWND, SuspendOn = 1) ;ScriptName   BLAD: ZALADOWAC SKRYP ZE ZLEJ SCIEZKI, NIE, RELOAD, TAK -> BLEDNIE WYKRYWA ZE SUSPENDED
{
    ; Get the HWND of the script's main window (which is usually hidden).
    dhw := A_DetectHiddenWindows
    DetectHiddenWindows On
    ;if scriptHWND := WinExist(ScriptName " ahk_class AutoHotkey")    
    {
        ; This constant is defined in the AutoHotkey source code (resource.h):
        static ID_FILE_SUSPEND := 65404

        ; Get the menu bar.
        mainMenu := DllCall("GetMenu", "ptr", scriptHWND)
        ; Get the File menu.
        fileMenu := DllCall("GetSubMenu", "ptr", mainMenu, "int", 0)
        ; Get the state of the menu item.
        state := DllCall("GetMenuState", "ptr", fileMenu, "uint", ID_FILE_SUSPEND, "uint", 0)
        ; Get the checkmark flag.
        isSuspended := state >> 3 & 1
        ; Clean up.
        DllCall("CloseHandle", "ptr", fileMenu)
        DllCall("CloseHandle", "ptr", mainMenu)

				if (isSuspended)  ;;<-- editor addon
				{
				MsgBox, % 4, %file_name%,  Skrypt jest wstrzymany, wznowić go?
					IfMsgBox, Yes
				
        ;if (!SuspendOn != !isSuspended)
            SendMessage 0x111, ID_FILE_SUSPEND,,, ahk_id %scriptHWND%
        ; Otherwise, it's already in the right state.
				}
    }
    DetectHiddenWindows %dhw%
}

/*
EditorBox(Text:="", Default:="", Caption:="Editor"){
    static
    ButtonOK:=ButtonCancel:= false
    if !EditorBoxGui{
        Gui, EditorBox: add, Text, r1 w600  , % Text
        Gui, EditorBox: add, Edit, r10 w600 vEditorBox, % Default
        Gui, EditorBox: add, Button, w60 gEditorBoxOK , &OK
        Gui, EditorBox: add, Button, w60 x+10 gEditorBoxCancel, &Cancel
        EditorBoxGui := true
    }
    GuiControl,EditorBox:, EditorBox, % Default
    Gui, EditorBox: Show,, % Caption
    SendMessage, 0xB1, 0, -1, Edit1, A
    while !(ButtonOK||ButtonCancel)
        continue
    if ButtonCancel
        return
    Gui, EditorBox: Submit, NoHide
    Gui, EditorBox: Cancel
    return EditorBox
    ;----------------------
    EditorBoxOK:
    ButtonOK:= true
    return
    ;---------------------- 
    EditorBoxGuiEscape:
    EditorBoxCancel:
    ButtonCancel:= true
    Gui, EditorBox: Cancel
    return
}
*/

bitSet(ByRef num, pos) {
	num |= (1 << pos-1)
}

bitUnset(ByRef num, pos) {
	num &= ~(1 << pos-1)
}

bitGet(ByRef num, pos) {
  return (num >> pos-1) & 1
}

msg(txt) {
	msgbox ,4096,, %txt%, 1.35
}

hasString(haystack, needle) {
    if(!isObject(haystack))
        return false
    if(haystack.Length()==0)
        return false
    for k,v in haystack
        if(v==needle)
            return true
    return false
}

printArray(strArray, delimiter:= ", ")
{
  str := ""
  for i, v in strArray
  {
	;debug("listing " i ": " v)
    str .= delimiter . v
  }
  return substr(str, StrLen(delimiter)+1)
}

listArray( strArray )
{
  return printArray(strArray, "`n")
}



/*
 Function:  Image
			Adds image to the Button control.

 Parameters:
			HButton	- Handle to the button.
			Image	- Path to the .BMP file or image handle. First pixel signifies transparency color.
			Width	- Width of the image, if omitted, current control width will be used.
			Height	- Height of the image, if omitted, current control height will be used.

 Returns:
		Bitmap handle.
 
 */
Ext_Image(HButton, Image, Width="", Height=""){ 
    static BM_SETIMAGE=247, IMAGE_ICON=2, BS_BITMAP=0x80, IMAGE_BITMAP=0, LR_LOADFROMFILE=16, LR_LOADTRANSPARENT=0x20

	if (Width = "" || Height = "") {
		ControlGetPos, , ,W,H, ,ahk_id %hButton%
		ifEqual, Width,, SetEnv, Width, % W-8
		ifEqual, Height,,SetEnv, Height, % H-8
	}

	if Image is not integer 
	{
		if (!hBitmap := DllCall("LoadImage", "UInt", 0, "Str", Image, "UInt", 0, "Int", Width, "Int", Height, "UInt", LR_LOADFROMFILE | LR_LOADTRANSPARENT, "UInt"))
			return 0
	} else
    hBitmap := Image  ;---new enter
    
    WinSet, Style, +%BS_BITMAP%, ahk_id %hButton% 
    SendMessage, BM_SETIMAGE, IMAGE_BITMAP, hBitmap, , ahk_id %hButton%
	return hBitmap
}


Gdip_CropImage(pBitmap, x, y, w, h)
{
   pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
   Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
   Gdip_DeleteGraphics(G2)
   return pBitmap2
}


;importy
;["CloudBtnED04", "Imports_apiED05", "Imports_bookED06", "Imports_chartED07", "Imports_symED08", "Imports_apiSW05", "Imports_bookSW06", "Imports_chartSW07", "Imports_symSW08"] 

;ustawienia charts, czy istnieja, "12,12"  obliczyć ze skryptu, updatowac szablon, zrobic konwersje przy zapisywaniu, poprawic chartzoom zeby rozpoznawal obie
;["Charts_CrossED09", "Charts_ZoomED10"]


;buttons  'wykrywać czy ;;;; i ignorować lub pozbyć się
;["Half_one_outED18", "Half_half_outED19", "Half_third_outED20", "Def_BuyED21", "Def_SellED22", "Spec_BuyED23", "Spec_SellED24", "Adv_warningsSW10", "Adv_debuglogsSW11"]
;HalfCross, one_out, half_out, third_out, defaultBuy, defaultSell, specialBuy, specialSell

;buttons keystrings
;Binds_longED26, Binds_shortED27, Binds_biglongED28, Binds_bigshortED29, Binds_buyhandED30, Binds_sellhandED31
;HOME::GoSub, buy_small
;END::GoSub, sell_small
;PgUp::GoSub, buy_big
;PgDn::GoSub, sell_big

;radio buttons
;polowki := "default"     ;; operacja wychodzenia częścią akcji opcje: default/special
;Half_RB_R := Half_RB_D := 1
;Half_RB := ["Half_defaultRB09", "Half_specialRB09"]

;cyfry := 0
;Cyfry_RB_R := Cyfry_RB_D := 1
;Cyfry_RB := ["Cyfry_SRB13", "Cyfry_BRB13", "Cyfry_LRB13"]

;Lot_RB_R := Lot_RB_D := 1

;----------------
;EntryCents
;updown_orders

;----------------

/*
; changes / warnings bits
;
; Identyfikator    00000000 00000000 00000000 00000001  0x1          01
; Login            00000000 00000000 00000000 00000010  0x2          02
; Hasło            00000000 00000000 00000000 00000100  0x4          03
; Cloud Folder     00000000 00000000 00000000 00001000  0x8          04
; API script       00000000 00000000 00000000 00010000  0x10         05
; Booktabs script  00000000 00000000 00000000 00100000  0x20         06
; Chartzoom script 00000000 00000000 00000000 01000000  0x40         07
; Symbols script   00000000 00000000 00000000 10000000  0x80         08
; Chart ED1        00000000 00000000 00000001 00000000  0x100        09
; Chart ED2        00000000 00000000 00000010 00000000  0x200        10
; Chart ED3        00000000 00000000 00000100 00000000  0x400        11----------------- off
; Chart ED4        00000000 00000000 00001000 00000000  0x800        12----------------- off
; Cross out        00000000 00000000 00010000 00000000  0x1000       13
; Cross in         00000000 00000000 00100000 00000000  0x2000       14
; Cross sub        00000000 00000000 01000000 00000000  0x4000       15
; Cross hand       00000000 00000000 10000000 00000000  0x8000       16
; Cross half       00000000 00000001 00000000 00000000  0x10000      17
; Key one/third    00000000 00000010 00000000 00000000  0x20000      18
; Key half         00000000 00000100 00000000 00000000  0x40000      19
; Key two/third    00000000 00001000 00000000 00000000  0x80000      20
; Key Def Long     00000000 00010000 00000000 00000000  0x100000     21
; Key Def Short    00000000 00100000 00000000 00000000  0x200000     22
; Key Spec Buy     00000000 01000000 00000000 00000000  0x400000     23
; Key Spec Sell    00000000 10000000 00000000 00000000  0x800000     24
; Lot Size Jump    00000001 00000000 00000000 00000000  0x1000000    25
; API Long         00000010 00000000 00000000 00000000  0x2000000    26
; API Short        00000100 00000000 00000000 00000000  0x4000000    27
; API Big Long     00001000 00000000 00000000 00000000  0x8000000    28
; API Big Short    00010000 00000000 00000000 00000000  0x10000000   29
; API Buy Hand     00100000 00000000 00000000 00000000  0x20000000   30
; API Sell Hand    01000000 00000000 00000000 00000000  0x40000000   31 
; Bind List        10000000 00000000 00000000 00000000  0x80000000   32  <--?
;
; switches
;
; Autologin        00000000 00000000 00000000 00000001  0x1          01
; Reload           00000000 00000000 00000000 00000010  0x2          02
; Login activation 00000000 00000000 00000000 00000100  0x4          03
; Pass  activation 00000000 00000000 00000000 00001000  0x8          04
; Api link         00000000 00000000 00000000 00010000  0x10         05
; Booktabs link    00000000 00000000 00000000 00100000  0x20         06
; Symbols link     00000000 00000000 00000000 01000000  0x40         07
; Chartzoom link   00000000 00000000 00000000 10000000  0x80         08
; Operacje         00000000 00000000 00000001 00000000  0x100        09
; Warnings msg     00000000 00000000 00000010 00000000  0x200        10
; Debug logs       00000000 00000000 00000100 00000000  0x400        11
; Tabowanie        00000000 00000000 00001000 00000000  0x800        12
; Cyfry            00000000 00000000 00010000 00000000  0x1000       13
; Slider Left      00000000 00000000 00100000 00000000  0x2000       14
; Slider Right     00000000 00000000 01000000 00000000  0x4000       15
; Equalizer        00000000 00000000 10000000 00000000  0x8000       16
; Fast size        00000000 00000001 00000000 00000000  0x10000      17
; Modyfikator      00000000 00000010 00000000 00000000  0x20000      18
; Limit focus      00000000 00000100 00000000 00000000  0x40000      19
; Tab reverse      00000000 00001000 00000000 00000000  0x80000      20
; Book scroll      00000000 00010000 00000000 00000000  0x100000     21
; Mysz mid         00000000 00100000 00000000 00000000  0x200000     22
; Special Keybinds 00000000 01000000 00000000 00000000  0x400000     23
*/


