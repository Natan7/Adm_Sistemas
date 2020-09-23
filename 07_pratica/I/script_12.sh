#!/bin/bash

echo "Script 12"
echo -n "Deseja limpar a tela: "
read RESPOSTA
if [ ${RESPOSTA} = S -o ${RESPOSTA} = s ]; then
	clear
fi
echo
