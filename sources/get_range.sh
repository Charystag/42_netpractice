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
