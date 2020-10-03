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
user_argument=$FALSE
command=""

if [ "$#" == 0 ]											# No argument supplied
then
	command="getent passwd | awk -F "":"" '{print\$1,\$3,\$5}'"					# Default mode
	eval $command
	exit $SUCCESS
fi

case "$1" in
	-all )
		command="getent passwd | awk -F "":"" '{print\$1,\$3,\$5}'"
		eval $command > .temp
	;;
       	-human )
		uid_max=$(cat /etc/login.defs | grep -E "^UID_MAX" | grep -o '[0-9]*')			# get UID_MAX
		command="getent passwd {1000..$uid_max} | awk -F "":"" '{print\$1,\$3,\$5}'"
		eval $command > .temp
       	;;
	-user )
		user_argument=$TRUE
	;;
        *)
		echo "Error, try -all or -human"
		exit $ERROR
        ;;
esac
case "$2" in
	-active )
		#users_names=$(w | passwd -S | grep P | awk '{print $1}')
		users_names=$(passwd -S -a|awk '$2 ~ /P/ {print $1}')
		if [ -n "$users_names" ]								# -n -> Variavel is not NULL
		then
			[ -e .temp ] && rm .temp							# clean up
			for user in $users_names
			do
				eval $command | grep ${user} >> .temp
			done
			#command="${command} | grep -i ${users_names}"
		else
			echo "Not have active users in this time."
			exit $SUCCESS				
		fi
	;;
	-nonactive )
		#users_names=$(w | passwd -S | grep LK | awk '{print $1}')
		users_names=$(passwd -S -a|awk '$2 ~ /L/ {print $1}')
		if [ -n "$users_names" ]								# -n -> Variavel is not NULL
		then
			[ -e .temp ] && rm .temp							# clean up
			for user in $users_names
			do
				eval $command | grep ${user} >> .temp
			done
			#command="${command} | grep -i ${users_names}"
		else
			echo "Not have nonactive users in this time."
			exit $SUCCESS				
		fi
	;;
	-order )
		command="${command} | sort"
		eval $command > .temp
	;;
	-out )
		command="${command} > "
		out=$TRUE;
	;;
	*)
		if [ $user_argument == $TRUE ]
		then
			if [ -z $2 ]									# -z -> No argument supplied
			then
				echo "Error, user name not informed"
				exit $ERROR
			fi
	
			user=$2
			find_user=$(getent passwd | awk -F "":"" '{print$1}' | grep -x $user)
			if [ -z "$find_user" ]								# -z -> Variavel is NULL
			then
				echo "User not found"
				exit $SUCCESS
			fi

			command="getent passwd | awk -F "":"" '{print\$1,\$3}' | grep \$user" ################################### check
			is_active=$(passwd -S -a|awk '$2 ~ /P/ {print $1}' | grep -x $user)	
			is_nonactive=$(passwd -S -a|awk '$2 ~ /L/ {print $1}' | grep -x $user)	
			if [ -n "$is_active" ]
			then
				command="${command} | awk '{\$3=\"Active_User\"; print}'"
			elif [ -n "$is_nonactive" ]
			then
				command="${command} | awk '{\$3=\"Nonactive_User\"; print}'"				
			fi
			#command="getent passwd | awk -F "":"" '{print\$1,\$3}' | grep \$user" #### check 
			#is_active=$(w | passwd -S | grep P | awk '{print $1}' | grep -x $user) #######
#			if [ -n "$is_active" ]		# -n -> Variavel is not NULL
#			then
#				command="${command} | awk '{\$3=\"Active_User\"; print}'"
#			else
#				command="${command} | awk '{\$3=\"Nonactive_User\"; print}'"				
#			fi

			get_group_list=$(groups $user | awk -F ": " '{print $2}')
			command="${command} | awk '{\$4=\"${get_group_list}\"; print}'"

			eval $command > .temp
			cat .temp
			[ -e .temp ] && rm .temp
			exit $SUCCESS

		elif [ -n "$2" ]
		then
			echo "Error, try -active or -nonactive"
			exit $ERROR
		fi
        ;;
esac
case "$3" in
	-order )
		[ -e .temp_aux ] && rm .temp_aux
		cat .temp | sort > .temp_aux
		cat .temp_aux > .temp
		[ -e .temp_aux ] && rm .temp_aux
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
		[ -e .temp_aux ] && rm .temp_aux
		cat .temp > .temp_aux
		[ -e .temp ] && rm .temp								# clean up

		#get_users="${command} | awk '{print\$1}'"
		get_users=$(cat .temp_aux | awk '{print$1}')
		for user in $get_users
		do
			get_groups_list=$(groups $user | awk -F ": " '{print $2}')
			#command="${command} | awk '{\$4=\"${get_groups_list}\"; print}'"
			command="cat .temp_aux | grep $user | awk '{\$4=\"${get_groups_list}\"; print}'"
			eval $command >> .temp
		done
		[ -e .temp_aux ] && rm .temp_aux
	;;
	-order )
		[ -e .temp_aux ] && rm .temp_aux
		cat .temp | sort > .temp_aux
		cat .temp_aux > .temp
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
		[ -e .temp_aux ] && rm .temp_aux
		cat .temp > .temp_aux
		[ -e .temp ] && rm .temp								# clean up

		#get_users="${command} | awk '{print\$1}'"
		get_users=$(cat .temp_aux | awk '{print$1}')
		#users_names=$(eval $get_users)
		number_column=5
		for user in $get_users
		do
			get_dir=$(getent passwd | grep "$user" | awk -F ":" '{print $6}')
			get_dir_info=$(du -sh "$get_dir")

			number_column=$(cat .temp_aux | grep $user | awk '{ FS = ":" } ; { print NF}') 
			number_column=$(($number_column + 1))
			#command="${command} | awk '{\$$number_column=\"${get_dir_info}\"; print}'"
			command="cat .temp_aux | grep $user | awk '{\$$number_column=\"${get_dir_info}\"; print}'"
			eval $command >> .temp
		done
		[ -e .temp_aux ] && rm .temp_aux
	;;
	-out )
		command="${command} > "
		out=$TRUE;
	;;
	-order )
		[ -e .temp_aux ] && rm .temp_aux
		cat .temp | sort > .temp_aux
		cat .temp_aux > .temp
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
	-order )
		[ -e .temp_aux ] && rm .temp_aux
		cat .temp | sort > .temp_aux
		cat .temp_aux > .temp
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
		elif [ -n "$7" ]									# -n -> Variavel is not NULL
		then
			echo "Error, filename not informed"
			exit $ERROR
		fi
	;;
esac

echo "COMMAND FINAL: $command"						# depuring code
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"	# depuring code
cat .temp
[ -e .temp ] && rm .temp
exit $SUCCESS
