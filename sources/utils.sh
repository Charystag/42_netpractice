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
			[3-9]) return 0 ;;
			*) return 2 ;;
		esac
	done
	return 1
}

:<<-'TO_BINARY'
	Function that takes a string (representing an ip address or subnet mask)
	as an input and converts it to its binary version.
	If one of the number in input is not a binary number, the function
	returns an error
	TO_BINARY
to_binary(){
	IFS=" " read -ra parameters <<<"$@"
	declare -i i=0
	to_bin=""
	while [ "$i" < "${#parameters[@]}" ] ; do
	is_binary "${parameters[$i]}"
	if [ "$?" -eq 2 ] ; then return 1
	elif [ "$?" -eq 1 ] ; then (( ++i ))
	else declare -n ref="${parameters[$i]}"
	ref="$(conv_address ${parameters[$i]})" ; fi
	done
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
