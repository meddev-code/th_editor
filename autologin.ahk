;--------------------------- autologin, autopass, inne
#IfWinActive (Unlock\s)?PPro8.*

#Hotstring B0 O0 k-1 *                                         ;;autologin
::imi::e.nazwisko@traderhouse.pl{tab}RedArt123{enter}          ;;<- popraw imie.nazwisko (pierwsze litery aktywuj� reszte)
::Red::Art123{enter}                                           ;;has�o (do k��dki)

#IfWinActive ^(Chart\sData.*|[A-Z]+\.[A-Z]+(\.[A-Z]+)?\s\(\d+\))
NumPadDot::.
,::.