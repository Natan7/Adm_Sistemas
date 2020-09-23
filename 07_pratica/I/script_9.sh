#!/bin/bash

echo "Script 9"
echo Informe um nome # tente entender o funcionamento do comando case
read NOME
case $NOME in
	Jose*)
	echo "Boa noite Jose."
	;;
	Joao*)
	echo "Boa noite Joao."
	;;
	*)
	echo "Nao te conheco."
	exit 1
	;;
esac
echo
