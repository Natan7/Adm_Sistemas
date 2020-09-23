#!/bin/bash

echo "Script 13"
if [ ! -d casa ]; then
	mkdir casa ; cd casa ; touch casa1 casa2 casa3
fi
for original in *; do
	resultado=$(echo $original | tr '[:lower:]' '[:upper:]')
	if [ ! -e $resultado ]; then
	mv $original $resultado
	fi
done
echo
