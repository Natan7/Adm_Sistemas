#!/bin/bash

<<COMMENT1
Script realiza a listagem dos usuários do sistema de acordo com o tipo de
parâmetro que é passado. A listagem default deve exibir o usuário, o UID e o nome
completo de cada usuário do sistema (campos 1, 3 e 5), a partir do arquivo /etc/passwd.:
COMMENT1

SUCCESS=0        
ERROR=1  

if [ $# -gt "7" ]; then
	echo "Error. A lot arguments ($#)"
	exit $ERROR
fi

option=$1	# if -all or -human
situation=$2	# if -active or -nonactive
order=$3
group=$4
dir=$5
out=$6
file_name=$7
command=""

echo "Listagem dos usuários do sistema"

if [ -z "$option" ] || [ $option == "-all" ]	# -z -> No argument supplied
then
	echo "ALL or default"
	command="awk -F "":"" '{print\$1,\$3,\$5}' | getent passwd"
	#command="awk -F "":"" '{print\$1,\$3,\$5}' /etc/passwd"
elif [ $option == "-human" ]
then
	echo "HUMAN"
	uid_max=$(cat /etc/login.defs | grep -E "^UID_MAX" | grep -o '[0-9]*')
	command="awk -F "":"" '{print\$1,\$3,\$5}' /etc/passwd | getent passwd {1000..$uid_max}"
	#command="getent passwd {1000..6000} | awk -F "":"" {print\$1,\$3,\$5}"
elif [ -n $option ]
then
	echo "Erro, try [-all or -human]"
	exit $ERROR
fi


if [ -z "$situation" ]
then
	echo "COMMAND: $command"
#	$command
	eval "$command"
	exit $SUCCESS
elif [ $situation == "-active" ]
then
	echo "active"
	exit $SUCCESS
elif [ $situation == "-nonactive" ]
then
	echo "nonactive"
	exit $SUCCESS
elif [ -n $situation ]
then
	echo "Erro, try [-active or -active]"
	exit $ERROR
fi

echo "COMMAND: $command"
#eval $command
exit $SUCCESS
