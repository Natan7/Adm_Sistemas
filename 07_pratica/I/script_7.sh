#!/bin/bash

echo "Script 7"
arq=$1
i=0
echo " ------------- Inicio do arquivo. ------------- "
cat $arq | while read LINE
do
	i=$((i+1))
	echo "Linha $i: $LINE"
done
echo " ------------- Final do arquivo. ------------- "
echo
