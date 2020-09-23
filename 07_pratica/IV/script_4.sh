#!/bin/bash

echo "Script d)"
for((i=0; i<=5;i++ )) ;do
	num[i]=$(( 1 + 20 * $RANDOM / 2**15 ))
done
for((i=0; i <5; i++ )); do
	for((j=0; j<5; j++ )); do
		if [ ${num[i]} -lt ${num[j]} ] ; then
			x=${num[i]}
			num[i]=${num[j]}
			num[j]=$x
		fi
	done
done
for((i=0; i<=5; i++)) ;do
	echo "Numero: $i ${num[i]}"
done
echo
