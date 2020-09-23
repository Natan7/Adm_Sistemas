#!/bin/bash

echo "Script e)"
readline () {
	echo "readline..."
	msg=""
	if [ $# -gt 0 ]; then
		msg="$*: "
	fi
	str=""
	while [ -z $str ]; do
		echo -n $msg
		read str
		echo $str
	done
	STR=$str
}
readline "Teste"
echo "Lido: " $STR
echo
