#!/usr/bin/bash

:<<-'MASK_TO_BIN'
	Takes a subnet mask of the form /x with x between 0 and 32 and outputs the binary
	representation of the mask.
	Example:
	Input : /28
	Output : 11111111.11111111.11111111.11110000
	MASK_TO_BIN
mask_to_bin(){
	prompt="Please provide a mask of the form /x with x in [0..32]
Example: /25"
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

:<<-'BIN_TO_MASK'
	Takes a subnet mask of the form x.y.z.t with x,y,z,t in [0..255] and outputs it in
	CIDR format
	Example:
	Input : 11111111.11111111.11111111.11110000
	Output : /28
	BIN_TO_MASK
bin_to_mask(){
	prompt="Please provide a mask of the form x.y.z.t with x,y,z,t in [0.255]
Example: 255.255.252.0"
	err_string="Invalid mask provided"
	mask_string="$1"
	if [ "$1" = "" ] ; then user_input "$prompt" "mask_string" ; fi
	is_binary "$mask_string"
	if [ "$mask_string" = "" -o "$ret_val" -eq 2 ]
	then echo "$err_string" ; ret_val=1 ; return ; fi
	if [ "$ret_val" -eq 0 ] ; then mask_string=`conv_address "$mask_string" 10 2` ; fi
	declare -i i=0
	declare -i mask_len=0
	echo "mask string is : $mask_string"
	while [ "$i" -lt "${#mask_string}" ] 
	do
		tmp="${mask_string:$i:1}"
		if [ "$tmp" = "0" ] ; then break ;
		elif [ "$tmp" = "1" ] ; then (( ++mask_len )) ; fi
		(( ++i ))
	done
	echo "/$mask_len"
}
