#!/bin/bash

SUCCESS=0        
ERROR=1
TRUE=1
FALSE=0

out=$FALSE

LAST_LOGINS=$(last -s -$2days | head -n -2 | cut -d" " -f1) #retorna todos os logins desde $2 dias atrás até hoje

if [ ! -n "$LAST_LOGINS" ]
then
	echo "No users logged in the determined period"
	exit $ERROR
fi

L=$(grep "^UID_MIN" /etc/login.defs)
L1=$(grep "^UID_MAX" /etc/login.defs)

USERS=$(awk -F':' -v "min=${L##UID_MIN}" -v "max=${L1##UID_MAX}" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | awk -F':' '{ print $1}') #retorna apenas os nomes dos usuários normais. Sem considerar usuários do sistema

case "$1" in
	-block )
		for user in $USERS
		do
			COUNTER=0
			for login in $LAST_LOGINS
			do	
				if [  ${login} == ${user} ]
				then	
					COUNTER=$(($COUNTER+1))
					break
				fi
			done
			
			if [ $COUNTER == 0 ]
			then
				echo "BLOCKING USER ${user}" 
				sudo passwd --lock ${user}
			fi
		done
	;;
	-remove )
		
		if [ ! -e /backup_usuarios ]
		then
			sudo mkdir /backup_usuarios
		fi
		
		DATE=$(date -d '' +'%b%d%Y')
		
		for user in $USERS
		do
			COUNTER=0
			for login in $LAST_LOGINS
			do	
				if [  ${login} == ${user} ]
				then	
					COUNTER=$(($COUNTER+1))
					break
				fi
			done
			
			if [ $COUNTER == 0 ]
			then
				echo "BACKING UP FILES FROM /home/${user}" 
				sudo tar -czvf /backup_usuarios/${user}_$DATE.tar.gz /home/${user}/*
				echo "DONE!"
				echo "====="
				echo "Deleting home folder"
				sudo rm -Rf /home/${user}
				echo "DONE!"
				echo "====="
				echo "Deleting user ${user}"
				sudo userdel ${user}
				echo "DONE!"
				echo "====="
			fi
		done	
	;;
	*)
		echo "ERROR, try -block [days] or -remove [days] options"
		exit $ERROR
	;;
esac
case "$2" in
	-out )
		out=$TRUE;
	;;
	*)
	if [ -n "$2" ]	# -n -> Variavel is not NULL
		then
			echo "Error, try -out \"filename\" "
			exit $ERROR
		fi
        ;;
esac
case "$3" in
	*)
		if [ $out == $TRUE ]
		then
			#cat .temp > $3 		# $3 == "filename"
			#[ -e .temp ] && rm .temp	# remove .temp file (if already exist)
			exit $SUCCESS
		elif [ -n "$3" ]	# -n -> Variavel is not NULL
		then
			echo "Error, inform filename"
			exit $ERROR
		fi
        ;;
esac

#[ -e .temp ] && rm .temp	# remove .temp file (if already exist)
exit $SUCCESS
