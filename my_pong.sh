#!/bin/bash


_prechauff(){
	clear
	local i
	for (( i=3 ; i>0 ; i-- )); do
		tput setaf 2 ; tput bold ;  tput cup "$MH" "$ML" ; echo "$i"
		sleep 1
	done
	tput cup "$MH" "$ML" ; echo "LETS PLAY THE GAME" ; sleep 2
	tput clear ; tput sgr0
}

_menu(){
	printf "





						 	                      ___          ___          ___          ___     
							                     /__/\        /  /\        /__/\        /__/\    
							                    |  |::\      /  /:/_       \  \:\       \  \:\   
							                    |  |:|:\    /  /:/ /\       \  \:\       \  \:\  
							                  __|__|:|\:\  /  /:/ /:/_  _____\__\:\  ___  \  \:\ 
							                 /__/::::| \:\/__/:/ /:/ /\/__/::::::::\/__/\  \__\:\\
							                 \  \:\~~\__\/\  \:\/:/ /:/\  \:\~~\~~\/\  \:\ /  /:/
							                  \  \:\       \  \::/ /:/  \  \:\  ~~~  \  \:\  /:/ 
							                   \  \:\       \  \:\/:/    \  \:\       \  \:\/:/  
							                    \  \:\       \  \::/      \  \:\       \  \::/   
							                     \__\/        \__\/        \__\/        \__\/    
								                                                             
	"

	tput cup "$MH" "$((ML-5))"
	tput setaf 3
	echo "PONG coded by Notfound"
	tput sgr0
	tput cup $((MH+5)) "$ML" ; echo "1. New game"
	tput cup $((MH+6)) "$ML" ; echo "2. Human vs Human"
	tput cup $((MH+7)) "$ML" ; echo "3. Play demo"
	tput cup $((MH+8)) "$ML" ; echo "4. Quit"

	# Set bold mode
	tput bold ; tput rev
	tput cup $((MH+10)) $ML ; read -p "  Please enter your choice  " choice ; tput sgr0
	case "$choice" in
		1)	_start 		;;
		2)	_new_game 	;;
		3)	_demo		;;
		4)	_exit		;;
		*)	_noob		;;
	esac

	sleep 100
	tput clear
	tput sgr0
	tput rc
}

_draw_area() {
	clear
	local a b c
	tput rev
	for ((a=0;a<=L;a++))
	do
		tput cup 0 "$a" ; echo " "
		tput cup $((HT-2)) "$a" ; echo " "
		sleep 0.001
	done
	for ((b=0;b<=HT-2;b++)); do
		tput cup "$b" 0 ; echo " "
		tput cup  "$b" $(($(tput cols)-1)); echo " "
		sleep 0.01
	done
	tput sgr0
	_draw_net

}

_draw_net(){
	for ((c=0;c<=HT-2;c++)); do
		tput cup "$c" "$ML" ; echo "|"
	done
}

_move(){
	MAXH=2;
	MAXB=$((`tput lines`-1))
	tput rev
	tput cup $H 1 ; echo " "
	tput cup $((MH+1)) 2 ; echo " "
	tput cup $((MH+2)) 2 ; echo " "
	tput sgr0


	case "$1" in
		a)	if [[ "$MAXH" -ne "$((MH))" ]]; then
				delete=$((MH+3)) ; tput cup $delete 1 ; echo "      "
				: $((MH--))
			fi ;;
		q)	if [[ "$MAXB" -ne "$((MH+4))" ]]; then
				delete=$((MH-2)) ; tput cup $delete 1 ; echo "       "
				: $((MH++))
			fi ;;
	esac
}

_start(){
	_draw_area
	#DRAW BAR
	tput rev
	tput cup $H 1 ; echo " "
	tput cup $((MH+1)) 2 ; echo " "
	tput cup $((MH+2)) 2 ; echo " "
	tput sgr0

	( _ball ) &
	while true; do
		read -s -r -n1 KEY
		_move "$KEY"
	done
}


_upR(){
	: $((HBALL--))
	: $((LBALL++))
}

_upL(){
	: $((HBALL--))
	: $((LBALL--))
}

_downR(){
	: $((HBALL++))
	: $((LBALL++))
}

_downL(){
	: $((HBALL++))
	: $((LBALL--))
}

_ball(){
	HBALL=$((`tput lines`/2))
	LBALL=$((`tput cols`/2))
#	clear
	time=0.05
	TU=0 ; TD=0 ; TR=0 ; TL=0
	HMAX=1 ; HMIN=$((`tput lines`-3)) ; RMAX=$((`tput cols`-2)) ; LMAX=2 
	while true; do
		if [[ "$TU" -eq "0" && "$TR" -eq "0" ]]; then
			tput cup "$HBALL" "$LBALL" ; tput sgr0 ; echo " "
			#tput cup "$((HBALL+1))" "$((LBALL+1))" ; echo " "
			_upR
			tput cup "$HBALL" "$LBALL" ; echo "☻" ;  sleep $time
			if [[ "$HBALL" -eq "$HMAX" ]]; then TU=1 ; TD=0 ; fi
			if [[ "$LBALL" -eq "$RMAX" ]]; then TR=1 ; TL=0 ; fi
		elif [[ "$TU" -eq "0" && "$TL" -eq "0" ]]; then
			tput cup "$HBALL" "$LBALL" ; tput sgr0 ; echo " "
			_upL
			tput cup "$HBALL" "$LBALL" ; echo "☻" ;  sleep $time
			if [[ "$HBALL" -eq "$HMAX" ]]; then TU=1 ; TD=0 ; fi
			if [[ "$LBALL" -eq "$LMAX" ]]; then TL=1 ; TR=0 ; fi
		elif [[ "$TD" -eq "0" && "$TR" -eq "0" ]]; then
			tput cup "$HBALL" "$LBALL" ; tput sgr0 ; echo " "
			_downR
			tput cup "$HBALL" "$LBALL" ; echo "☻" ;  sleep $time
			if [[ "$HBALL" -eq "$HMIN" ]]; then TD=1 ; TU=0 ; fi
			if [[ "$LBALL" -eq "$RMAX" ]]; then TR=1 ; TL=0 ; fi
		elif [[ "$TD" -eq "0" && "$TL" -eq "0" ]]; then
			tput cup "$HBALL" "$LBALL" ; tput sgr0 ; echo " "
			_downL
			tput cup "$HBALL" "$LBALL" ; echo "☻" ;  sleep $time
			if [[ "$HBALL" -eq "$HMIN" ]]; then TD=1 ; TU=0 ; fi
			if [[ "$LBALL" -eq "$LMAX" ]]; then TL=1 ; TR=0 ; fi
		fi

		#( if [[ "$LBALL" -eq "$((`tput cols`/2))" ]]; then sleep 0.4 ; _draw_net ; fi ) &

	done
}

_leaveClean(){
	clear
	printf "\e[?12l\e[?25h"
	pgrep try.sh |xargs kill -9
}
####################################################
########## PAS DE MAIN, PAS DE CHOCOLAINT ##########
####################################################
# SOME VARIABLES
HT=$(tput lines)
L=$(tput cols)
ML=$((L/2))
MH=$((`tput lines`/2))
#H=$((`tput lines`/2))

# CLEAR THAT FUCKING SCREEN
clear

# HOUSTON, PLZ LAUNCH SOME FUNCTIONS
trap _leaveClean SIGINT
printf "\e[?25l"      # CURSOR IS FOR T4PZ WHO LOST THE GAME
_prechauff
_menu
_draw_area
_start

	#limH=2
	#limB=$((`tput lines`-2))
	#limG=2
	#limD=$((`tput cols`-2))
