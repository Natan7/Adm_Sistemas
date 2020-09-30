#!/bin/bash

<<COMMENT1
Script realiza a listagem dos usuários do sistema de acordo com o tipo de
parâmetro que é passado. A listagem default deve exibir o usuário, o UID e o nome
completo de cada usuário do sistema (campos 1, 3 e 5), a partir do arquivo /etc/passwd.:
COMMENT1

SUCCESS=0        
ERROR=1
TRUE=1
FALSE=0

out=$FALSE
command=""

if [ "$#" == 0 ] # -z -> No argument supplied
then
	command="getent passwd | awk -F "":"" '{print\$1,\$3,\$5}'"	# Default mode
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
		-user )
			#implement
		;;
	        *)
			echo "Error, try -all or -human"
			exit $ERROR
	        ;;
	esac
	case "$2" in
		-active )
			users_names=$(w | passwd -S | grep P | awk '{print $1}')
			if [ -n "$users_names" ]
			then
				command="${command} | grep ${users_names}"
			else
				echo "Not have active users in this time."
				exit $SUCCESS				
			fi

		;;
		-nonactive )
			users_names=$(w | passwd -S | grep LK | awk '{print $1}')
			if [ -n "$users_names" ]
			then
				command="${command} | grep ${users_names}"
			else
				echo "Not have nonactive users in this time."
				exit $SUCCESS				
			fi
		;;
		-order )
			command="${command} | sort"
		;;
		-out )
			command="${command} > "
			out=$TRUE;
		;;
	        *)
			if [ -n "$2" ]
			then
				echo "Error, try -active or -nonactive"
				exit $ERROR
			fi
	        ;;
    	esac
	case "$3" in
		-order )
			command="${command} | sort"
		;;
		-dir )
			get_users="${command} | awk '{print\$1}'"
			users_names=$(eval $get_users)
			get_dir=$(getent passwd | grep "$users_names" | awk -F ":" '{print $6}')
			get_dir_info=$(du -sh "$get_dir")
			command="${command} | awk '{\$4=\"${get_dir_info}\"; print}'"
		;;
		-out )
			command="${command} > "
			out=$TRUE;
		;;
	        *)
			if [ $out == $TRUE ]
			then
				command="${command} $3"
				eval $command
				exit $SUCCESS
			elif [ -n "$3" ]
			then
				echo "Error, try -order"
				exit $ERROR
			fi
	        ;;
    	esac
	case "$4" in
		-groups )
			get_users="${command} | awk '{print\$1}'"
			users_names=$(eval $get_users)
			get_groups_list=$(groups $users_names | awk -F ": " '{print $2}')
			command="${command} | awk '{\$4=\"${get_groups_list}\"; print}'"
		;;
		-dir )
			get_users="${command} | awk '{print\$1}'"
			users_names=$(eval $get_users)
			get_dir=$(getent passwd | grep "$users_names" | awk -F ":" '{print $6}')
			get_dir_info=$(du -sh "$get_dir")
			command="${command} | awk '{\$4=\"${get_dir_info}\"; print}'"
		;;
		-order )
			command="${command} | sort"
		;;
		-out )
			command="${command} > "
			out=$TRUE;
		;;
	        *)
			if [ $out == $TRUE ]
			then
				command="${command} $4"
				eval $command
				exit $SUCCESS
			elif [ -n "$4" ]
			then
				echo "Error, try -groups"
				exit $ERROR
			fi	
	        ;;
    	esac
	case "$5" in
		-dir )
			get_users="${command} | awk '{print\$1}'"
			users_names=$(eval $get_users)
			get_dir=$(getent passwd | grep "$users_names" | awk -F ":" '{print $6}')
			get_dir_info=$(du -sh "$get_dir")

			number_column=$(eval $command | awk '{ FS = ":" } ; { print NF}') 
			number_column=$(($number_column + 1))

			command="${command} | awk '{\$$number_column=\"${get_dir_info}\"; print}'"
		;;
		-out )
			command="${command} > "
			out=$TRUE;
		;;
	        *)
			if [ $out == $TRUE ]
			then
				command="${command} $5"
				eval $command
				exit $SUCCESS
			elif [ -n "$5" ]
			then
				echo "Error, try -dir"
				exit $ERROR
			fi
	        ;;
    	esac
	case "$6" in
		-out )
			command="${command} > "
			out=$TRUE;
		;;
	        *)
			if [ $out == $TRUE ]
			then
				command="${command} $6"
				eval $command
				exit $SUCCESS
			elif [ -n "$6" ]
			then
				echo "Error, try -out"
				exit $ERROR
			fi
	        ;;
    	esac
	case "$7" in
	        *)
			if [ $out == $TRUE ]
			then
				command="${command} $7"
			elif [ -n "$7" ]
			then
				echo "Error, filename not informed"
				exit $ERROR
			fi
	        ;;
    	esac
done;

echo "COMMAND FINAL: $command"						# depuring code
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"	# depuring code
eval $command								
exit $SUCCESS
