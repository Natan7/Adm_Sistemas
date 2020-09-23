#!/bin/bash

echo "Script c)"
for((i=0; i<=5; i++)); do
	num[i]=$(( 1 + 20 * $RANDOM / 2**15 ))
	echo "Número : $i ${num[i]}"
done
echo
