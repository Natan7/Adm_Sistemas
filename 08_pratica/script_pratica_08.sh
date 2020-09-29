#!/bin/bash

<<COMMENT1
Script realiza a listagem dos usuários do sistema de acordo com o tipo de
parâmetro que é passado. A listagem default deve exibir o usuário, o UID e o nome
completo de cada usuário do sistema (campos 1, 3 e 5), a partir do arquivo /etc/passwd.:
COMMENT1

SUCCESS=0        
ERROR=1  

if [ "$#" == 0 ] # -z -> No argument supplied
then
	echo "DEFAULT"
	command="getent passwd | awk -F "":"" '{print\$1,\$3,\$5}'"
	#command="awk -F "":"" '{print\$1,\$3,\$5}' /etc/passwd"
	echo "COMMAND: $command"
	echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
	eval $command
	exit $SUCCESS
fi

for argument in "$@"  # $@ all arguments passed in
do
	case "$1" in
		-all )
			echo "ALL"
			command="getent passwd | awk -F "":"" '{print\$1,\$3,\$5}'"
			echo "COMMAND: $command"
			echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
			eval $command
			exit $SUCCESS
		;;
        	-human )
			echo "HUMAN"
			uid_max=$(cat /etc/login.defs | grep -E "^UID_MAX" | grep -o '[0-9]*')
			command="getent passwd {1000..$uid_max} | awk -F "":"" '{print\$1,\$3,\$5}'"
			echo "COMMAND: $command"
			echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
			eval $command
			exit $SUCCESS
        	;;
	        *)
			echo "Erro, try [-all or -human]"
			exit $ERROR
	        ;;
    	esac 
done;

#echo "COMMAND: $command"
#echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
#eval $command
exit $SUCCESS
