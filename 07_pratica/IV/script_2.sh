#!/bin/bash

echo "Script b)"
i=0
while [ $i -le 5 ]; do
	num[i]=$RANDOM
	echo "Número : $i ${num[i]}"
	i=$(( $i + 1 ))
done
echo
