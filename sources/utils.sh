#!/usr/bin/bash
colors="colorcodes.sh"
. "$colors"

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
		case "${number:$i:1}" in ( [01.] ) (( ++i )) ;;	
			[2-9]) ret_val=0 ; return ;;
			*) ret_val=2 ; return ;;
		esac
	done
	ret_val=1 ; return
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
	while [ "$i" -lt "${#parameters[@]}" ] ; do
	declare -n ref="${parameters[$i]}"
	is_binary "$ref"
	if [ "$ret_val" -eq 2 ] ; then echo "This is the problematic term : $ref" ; ret_val=1 ; return
	elif [ "$ret_val" -eq 1 ] ; then (( ++i ))
	else ref="$(conv_address $ref)" ; fi
	done
	ret_val=0
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

mask_description="The value of the bytes of the subnet mask can be in the follwing set :\n\
- 255(dec) or 11111111(bin) = 8 bits on\n\
- 254(dec) or 11111110(bin) = 7 bits on\n\
- 252(dec) or 11111100(bin) = 6 bits on\n\
- 248(dec) or 11111000(bin) = 5 bits on\n\
- 240(dec) or 11110000(bin) = 4 bits on\n\
- 224(dec) or 11100000(bin) = 3 bits on\n\
- 192(dec) or 11000000(bin) = 2 bits on\n\
- 128(dec) or 10000000(bin) = 1 bit  on\n\
- 0(dec)   or 00000000(bin) = 0 bit  on\n\
"
