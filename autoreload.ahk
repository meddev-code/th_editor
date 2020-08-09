;--------------------------- autologin, autopass, inne
#IfWinActive (Unlock\s)?PPro8.*

#Hotstring B0 O0 k-1 *                                         ;;<-autologin
::imi::                                                        ;;popraw wyzwalacz imie (3 litery)
  SendInput, e.nazwisko@traderhouse.pl{tab}RedArt123{enter}    ;;reszta loginu + has³o
  reloading()                                                  ;;funkcja na dole skryptu
return
::Red::Art123{enter}                                           ;;has³o (do k³ódki)

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