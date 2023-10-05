#!/usr/bin/bash

:<<-'IS_BINARY'
	Function that takes a string as an input and checks that for each digit
	it is strictly between 0 and 1
	IS_BINARY
is_binary(){
	if [ "$1" = "" ]
	then echo "Please provide a number/address to analyse" ; read -r number
	else number="$1" ; fi
	if [ "$number" = "" ] ; then echo "Stop messin' with me bruv" ; exit 1 ; fi
	declare -i i=0
	while [ $i -lt "${#number}" ]
	do
		case "${number:$i:1}" in ( [12.] ) (( ++i )) ;;	
			*) return 0 ;;
		esac
	done
	return 1
}


# shellcheck disable=SC2034 # Referenced variable used in function to store
# user input
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
