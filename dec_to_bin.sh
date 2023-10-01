#!/usr/bin/bash
conv_address(){
	base_address="$1"
	if [ "$1" == "" ] ; then echo "Please provide an ip address" ; return 1 ; fi
	if [ "$2" == "" ] ; then base_in=10 ; else base_in="$2" ; fi
	if [ "$3" == "" ] ; then base_out=2 ; else base_out="$3" ; fi
	IFS='.' read -ra address <<< "$base_address"
	declare -i i=0
	if [ "${#address[@]}" -lt 1 ] ; then echo "No ip address found" ; return 2 ; fi
	while [ "$i" -lt $((${#address[@]} - 1)) ]
	do
		# shellcheck disable=SC2046
		printf "%.8d." $(echo "ibase=$base_in;obase=$base_out;${address[$i]}" | bc)
		((++i))
	done
	# shellcheck disable=SC2046
	printf "%.8d\n" $(echo "ibase=$base_in;obase=$base_out;${address[$i]}" | bc)
}

conv_address "$1" "$2" "$3"
:<<'COMMENT'
IFS='.' read -ra bonjour <<< "$1"
cat <<< "$1"
echo $1
echo "${bonjour[@]}"
COMMENT
