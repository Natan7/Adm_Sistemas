#!/bin/bash

echo "Script 6"
inicio=1
fim=10
while [ $inicio -lt $fim ]
do
	echo "Valor inicial é menor que o final: $inicio $fim"
	inicio=$((inicio+1))
done
echo "Valor inicial é igual ao valor final: $inicio $fim"
echo
