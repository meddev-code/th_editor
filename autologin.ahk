;--------------------------- autologin, autopass, inne
#IfWinActive (Unlock\s)?PPro8.*

#Hotstring B0 O0 k-1 *                                         ;;autologin
::imi::e.nazwisko@traderhouse.pl{tab}RedArt123{enter}          ;;<- popraw imie.nazwisko (pierwsze litery aktywuj¹ reszte)
::Red::Art123{enter}                                           ;;has³o (do k³ódki)

#IfWinActive ^(Chart\sData.*|[A-Z]+\.[A-Z]+(\.[A-Z]+)?\s\(\d+\))
NumPadDot::.
,::.