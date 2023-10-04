#!/usr/bin/bash

:<<-'IS_BINARY'
	Function that takes a string as an input and checks that for each digit
	it is strictly between 0 and 1
	IS_BINARY
is_binary(){
}

:<<-'CONV_ADDRESS'
	This function takes a string representing an IP address with bytes in decimal
	base and outputs it in binary base.
	Example:
	Input : 127.0.0.1
	Output : 01111111.00000000.00000000.00000001
	CONV_ADDRESS
conv_address(){
	prompt="Please provide an ip address"
	err_string="Invalid ip address provided"
	echo "$prompt"
	read -r base_address
	if [ "$prompt" = "" ] ; then echo "Please provide an ip address" ; return 1 ; fi
	#if [ "$2" = "" ] ; then base_in=10 ; else base_in="$2" ; fi
	#if [ "$3" = "" ] ; then base_out=2 ; else base_out="$3" ; fi
	base_in=10;base_out=2
	IFS='.' read -ra address <<< "$base_address"
	if [ "${#address[@]}" -lt 1 ] ; then echo "No ip address found" ; return 2 ; fi
	declare -i i=0
	while [ "$i" -lt $((${#address[@]} - 1)) ]
	do
		# shellcheck disable=SC2046
		printf "%.8d." $(echo "ibase=$base_in;obase=$base_out;${address[$i]}" | bc)
		((++i))
	done
	# shellcheck disable=SC2046
	printf "%.8d\n" $(echo "ibase=$base_in;obase=$base_out;${address[$i]}" | bc)
	echo "back to main menu" ; choice
}

:<<-'MASK_TO_BIN'
	Takes a subnet mask of the form /x with x between 0 and 32 and outputs the binary
	representation of the mask.
	Example:
	Input : /28
	Output : 11111111.11111111.11111111.11110000
	MASK_TO_BIN
#Takes a mask (in CIDR) format or binary format and converts it to the other format
mask_to_bin(){
	prompt="Please provide a mask of the form /x with -1<x<33"
	err_string="Invalid mask provided"
	mask_string="$1"
	echo "$mask_string"
	echo "$1" >salut
	if [ "$1" = "" ] ; then echo "$prompt" ; read -r mask_string ; fi
	if [ "$mask_string" = "" ] || [ "${mask_string:0:1}" != "/" ] ; then echo "$err_string" ; return 1 ; fi
	length=$((${#mask_string}-1))
	if [ "$length" -lt 1 ] ; then echo "$err_string" ; return 1 ; fi
	mask=""
	declare -i i=0
	while [ "$i" -lt "32" ]
	do
		if [ "$i" -lt "${mask_string:1:$length}" ] ; then dig='1' ; else dig='0' ; fi
		mask="$mask""$dig"
		(( ++i ))
		if [ $((i % 8)) -eq '0' ] && [ "$i" -ne "32" ] ; then mask="$mask"'.' ; fi
	done
	echo "$mask" >salut
}

:<<-'LAUNCH_FUNCTION'
	Launches the right function (according to main menu options) and brings the user back
	to the main menu
	LAUNCH_FUNCTION
launch_function(){
	param="$1"
	if [ "$param" = "1" ] ; then mask_to_bin
	elif [ "$param" = "2" ] ; then echo "Need to implement"
	else conv_address ; fi
	echo "Back to main menu"
	choice
}

:<<-'GET_RANGE'
	Gets the range of ip addresses covered using a given subnet mask
	First the function compares until the end of the subnet mask and
	it then construct the min and max ranges from this subnet mask.
	It then prints the min and max ranges on standard output
	GET_RANGE
get_range(){
	a_prompt="Please provide an ip address"
	m_prompt="Please enter a subnet mask"
	if [ "$2" = "" ]
	then
		user_input "$a_prompt" address 
		user_input "$m_prompt" mask
	else
		mask="$2"
		address="$1"
	fi
	echo bonjour
	echo "This is the address len : ${#address}"
	if [ "${mask:0:1}" = "/" ] ; then echo "mask before is : $mask" ; mask="$(mask_to_bin $mask)" ; echo "mask is : $mask" ; fi
	if [ "${#address}" -ne "${#mask}" ] ; then echo "error: len(ip) != len(mask)" ; return 1 ; fi
	declare -i i=0
	echo "This is i : $i"
	while [ "$i" -lt "${#address}" ]
	do
		echo "This is i : $i"
		if [ "${mask:$i:1}" = "1" ]
		then min_range="$min_range""${address:$i:1}" ; max_range="$max_range""${address:$i:1}"
		elif [ "${mask:$i:1}" = "0" ] ; then min_range="$min_range"0 ; max_range="$max_range"1
		elif [ "${mask:$i:1}" = "." ] ; then min_range="$min_range""." ; max_range="$max_range""."
		else echo "error : unrecognized character in ip" ; return 1
		fi
		((++i))
	done
	echo "This is the min range : $min_range"
	echo "This is the max range : $max_range"
}

:<<-'MENU'
	Prints the main menu of the program
	MENU
menu(){
	printf "%-12b%b\n" "[1]" "For mask conversion from /x to binary"
	printf "%-12b%b\n" "[2]" "For mask conversion from binary to /x"
	printf "%-12b%b\n" "[3]" "For ip conversion from decimal to binary"
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
		case "$user_choice" in ( [123] ) break ;; 
			[q] ) echo "Exiting..." ; exit 0 ;;
			* ) echo "Please select a true option" ;; esac
	done
	if [ "$user_choice" -eq "1" ] ; then launch_function "1"
	elif [ "$user_choice" -eq "2" ] ; then launch_function "2"
	else launch_function "3" ; fi
}

:<<-'USER_INPUT'
	Allows to prompt something to the user and to read one line of input from
	the user 
	USER_INPUT
user_input(){
	if [ "$2" = "" ] ; then echo "Function usage: user_input prompt var" ; return 1 ; fi
	declare -n ref="$2"
	echo "$1"
	read -r ref
}

main(){
	choice
}

#main
get_range "$@"


:<<'COMMENT'
IFS='.' read -ra bonjour <<< "$1"
cat <<< "$1"
echo $1
echo "${bonjour[@]}"
COMMENT
