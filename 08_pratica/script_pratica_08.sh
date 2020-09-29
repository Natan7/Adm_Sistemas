#!/bin/bash

<<COMMENT1
Script realiza a listagem dos usuários do sistema de acordo com o tipo de
parâmetro que é passado. A listagem default deve exibir o usuário, o UID e o nome
completo de cada usuário do sistema (campos 1, 3 e 5), a partir do arquivo /etc/passwd.:
COMMENT1

SUCCESS=0        
ERROR=1  
command=""

if [ "$#" == 0 ] # -z -> No argument supplied
then
	command="getent passwd | awk -F "":"" '{print\$1,\$3,\$5}'"	# Default mode
	#command="awk -F "":"" '{print\$1,\$3,\$5}' /etc/passwd"
	eval $command
	exit $SUCCESS
fi

for argument in "$@"  # $@ all arguments passed in
do
	case "$1" in
		-all )
			command="getent passwd | awk -F "":"" '{print\$1,\$3,\$5}'"
		;;
        	-human )
			uid_max=$(cat /etc/login.defs | grep -E "^UID_MAX" | grep -o '[0-9]*')		 # get UID_MAX
			command="getent passwd {1000..$uid_max} | awk -F "":"" '{print\$1,\$3,\$5}'"
        	;;
	        *)
			echo "Error, try [-all or -human]"
			exit $ERROR
	        ;;
	esac
	case "$2" in
		-active )
			echo "ACTIVE"								# depuring code
			user_names=$(w | passwd -S | grep P | awk '{print $1}')
			command="${command} | grep ${user_names}"
			echo "COMMAND: $command"						# depuring code
			echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"	# depuring code
			eval $command
			exit $SUCCESS
		;;
		-nonactive )
			echo "NON-ACTIVE"							# depuring code
			user_names=$(w | passwd -S | grep LK | awk '{print $1}')
			command="${command} | grep ${user_names}"
			echo "COMMAND: $command"						# depuring code
			echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"	# depuring code
			eval $command
			exit $SUCCESS
		;;
		-order )
			echo "ORDER" 								# depuring code
			command="${command} | sort"
			echo "COMMAND: $command"						# depuring code
			echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"	# depuring code
			eval $command
			exit $SUCCESS
		;;
	        *)
			echo "Error, try -active or -nonactive"
			exit $ERROR
	        ;;
    	esac
	case "$3" in
		-order )
			echo "ORDER" 								# depuring code
			command="${command} | sort"
			echo "COMMAND: $command"						# depuring code
			echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"	# depuring code
			eval $command
			exit $SUCCESS
		;;
	        *)
			echo "Error, try -active or -nonactive"
			exit $ERROR
	        ;;
    	esac
done;

#echo "COMMAND FINAL: $command"						# depuring code
#echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"	# depuring code
#eval $command								
exit $SUCCESS
