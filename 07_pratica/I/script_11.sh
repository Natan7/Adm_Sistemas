#!/bin/bash

echo "Script 11"

HORA=$(date +%H)
if [ $HORA -lt 12 ]
then
	echo Bom dia
elif [ $HORA -lt 18 ]; then
	echo Boa tarde
else
	echo Boa noite
fi
echo
