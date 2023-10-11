#!/usr/bin/bash
utils="mask_to_bin.sh utils.sh"
IFS=" " read -ra util <<< "$utils"
for i in "${util[@]}" ; do source "$i" ; done


:<<-'GET_RANGE'
	Gets the range of ip addresses covered using a given subnet mask
	First the function compares until the end of the subnet mask and
	it then construct the min and max ranges from this subnet mask.
	It then prints the min and max ranges on standard output
	GET_RANGE
get_range(){
	a_prompt="Please provide an ip address in decimal format
Example: 124.213.128.219 or 01111111.01111011.11010101.11111000"
	m_prompt="Please enter a subnet mask in decimal, binary or CIDR format
Example: 255.255.255.128 or 11111111.11111111.11111111.11110000 or /32"
	if [ "$2" = "" ]
	then
		user_input "$a_prompt" address 
		user_input "$m_prompt" mask
	else
		mask="$2"
		address="$1"
	fi
	if [ "${mask:0:1}" = "/" ] ; then mask="$(mask_to_bin $mask)" ; fi
	to_binary "address" "mask"
	if [ "$ret_val" -eq "1" ] ; then echo "Nan provided" ; return ; fi
	if [ "${#address}" -ne "${#mask}" ] ; then echo "error: len(ip) != len(mask)" ; ret_val=1 ; 
	echo "ip : $address" ; echo "mask : $mask" ; return ; fi
	declare -i i=0
	while [ "$i" -lt "${#address}" ]
	do
		if [ "${mask:$i:1}" = "1" ]
		then min_range="$min_range""${address:$i:1}" ; max_range="$max_range""${address:$i:1}"
		elif [ "${mask:$i:1}" = "0" ] ; then min_range="$min_range"0 ; max_range="$max_range"1
		elif [ "${mask:$i:1}" = "." ] ; then min_range="$min_range""." ; max_range="$max_range""."
		fi
		((++i))
	done
	echo "This is the min range : $(conv_address $min_range 2 10)"
	echo "This is the max range : $(conv_address $max_range 2 10)"
	ret_val=0
}
