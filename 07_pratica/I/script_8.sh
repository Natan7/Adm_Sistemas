#!/bin/bash

echo "Script 8"
if [ -f $1 ]; then
	echo "Arquivo encontrado"
else
	echo "Arquivo nao encontrado"
fi
if [ -d $1 ]; then
	echo "Diretorio existe"
else
	echo "Diretorio nao existe ou nao encontrado"
fi
echo
