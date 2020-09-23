#!/bin/bash

echo "Script b)"
echo -n "String: "
read s
echo $s
echo ${s:5}
echo ${s:5:3}
n=${#s}
if [ $(( n % 2 )) -eq 1 ]; then
	m=$(( n / 2 ))
echo ${s:$m:1}
fi
echo
