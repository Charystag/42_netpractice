#!/usr/bin/bash

:<<-'DOC'
	This function takes a string representing an IP address with bytes in decimal
	base and outputs it in binary base.
	Example:
	Input : 127.0.0.1
	Output : 01111111.00000000.00000000.00000001
	DOC
conv_address(){
	base_address="$1"
	if [ "$1" == "" ] ; then echo "Please provide an ip address" ; return 1 ; fi
	if [ "$2" == "" ] ; then base_in=10 ; else base_in="$2" ; fi
	if [ "$3" == "" ] ; then base_out=2 ; else base_out="$3" ; fi
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
}

:<<-'DOC'
	Takes a subnet mask of the form /x with x between 0 and 32 and outputs the binary
	representation of the mask.
	Example:
	Input : /28
	Output : 11111111.11111111.11111111.11110000
	DOC
mask_to_bin(){
	err_string="Please provide a mask of the form /x with -1<x<33"
	if [ "$1" == "" ] ; then echo "$err_string" ; return 1 ; fi
	mask_size="$1"
	length=$((${#1}-1))
	if [ "$length" -lt 1 ] ; then echo "$err_string" ; return 1 ; fi
	mask=""
	declare -i i=0
	while [ "$i" -lt "32" ]
	do
		if [ "$i" -lt "${mask_size:1:$length}" ] ; then dig='1' ; else dig='0' ; fi
		mask="$mask""$dig"
		(( ++i ))
		if [ $((i % 8)) -eq '0' ] && [ "$i" -ne "32" ] ; then mask="$mask"'.' ; fi
	done
	echo "$mask"
}

main(){
	if [ "$1" == "" ] ; then echo "Please provide data to convert" ; exit 1 ; fi
	data="$1"
	if [ "${data:0:1}" == "/" ] ; then mask_to_bin "$data" ; else conv_address "$data" ; fi
}

main "$1"

:<<'COMMENT'
IFS='.' read -ra bonjour <<< "$1"
cat <<< "$1"
echo $1
echo "${bonjour[@]}"
COMMENT
