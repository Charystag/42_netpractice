#!/usr/bin/bash
# shellcheck source=/dev/null
utils="mask_to_bin.sh conv_address.sh get_range.sh"
IFS=" " read -ra util <<< "$utils"
for i in "${util[@]}" ; do source "$i" ; done

:<<-'LAUNCH_FUNCTION'
	Launches the right function (according to main menu options) and brings the user back
	to the main menu
	LAUNCH_FUNCTION
launch_function(){
	param="$1"
	case "$param" in ( [1] ) mask_to_bin ;;
					[2] ) echo "Need to implement" ;;
					[3] ) conv_address ;;
					[4] ) conv_address '' "2" "10" ;;
					[5] ) get_range ;;
	esac
	echo "Back to main menu"
}

:<<-'MENU'
	Prints the main menu of the program
	MENU
menu(){
	printf "%-12b%b\n" "[1]" "For mask conversion from /x to binary"
	printf "%-12b%b\n" "[2]" "For mask conversion from binary to /x"
	printf "%-12b%b\n" "[3]" "For ip conversion from decimal to binary"
	printf "%-12b%b\n" "[4]" "For ip conversion from binary to decimal"
	printf "%-12b%b\n" "[5]" "To compute a range of ip addresses"
	printf "%-12b%b\n" "[q]" "To exit the program"
}

:<<-'CHOICE'
	Allows the user to choose their prefered option and to launch the right
	function
	CHOICE
choice(){
	#menu
	printf "%b\n" "Please choose a conversion option"
	while true
	do 
		menu
		read -rn 1 user_choice ; echo
		case "$user_choice" in ( [1-5] ) launch_function "$user_choice" ;; 
			[q] ) echo "Exiting..." ; exit 0 ;;
			* ) echo "Please select a true option" ;; esac
	done
}
