#!/usr/bin/bash

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
	echo "$mask"
}
