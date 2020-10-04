#!/bin/bash

SUCCESS=0        
ERROR=1
TRUE=1
FALSE=0

out=$FALSE

LAST_LOGINS=$(last -s -$2days | head -n -2 | cut -d" " -f1) > .temp #retorna todos os logins desde $2 dias atrás até hoje

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
				echo "BLOCKING USER ${user}" >> .temp 
				sudo passwd --lock ${user} >> .temp
			fi
		done
	;;
	-remove )
		
		if [ ! -e /backup_usuarios ]
		then	
			echo "Creating backups directory:" >> .temp
			sudo mkdir /backup_usuarios >> .temp
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
				echo "BACKING UP FILES FROM /home/${user} to /backup_usuarios/${user}_$DATE.tar.gz" >> .temp
				sudo tar -czvf /backup_usuarios/${user}_$DATE.tar.gz -C / home/${user} >> .temp
				echo "DONE!" >> .temp
				echo "=====" >> .temp
				echo "Deleting home folder" >> .temp
				sudo rm -Rf /home/${user} >> .temp
				echo "DONE!" >> .temp
				echo "=====" >> .temp
				echo "Deleting user ${user}" >> .temp
				sudo userdel ${user} >> .temp
				echo "DONE!" >> .temp
				echo "=====" >> .temp
			fi
		done	
	;;
	*)
		echo "ERROR, try -block [days] or -remove [days] options"
		[ -e .temp ] && rm .temp	# remove .temp file (if already exist)
		exit $ERROR
	;;
esac
case "$3" in
	-out )
		out=$TRUE;
	;;
	*)
		if [ -n "$3" ]	# -n -> If variavel is not NULL
		then
			echo "Error, try -out \"filename\" "
			[ -e .temp ] && rm .temp	# remove .temp file (if already exist)
			exit $ERROR
		fi
        ;;
esac
case "$4" in
	*)
		if [ $out == $TRUE -a -n "$4" ]
		then
			cat .temp > "$4" 		# $4 == "filename"
			[ -e .temp ] && rm .temp	# remove .temp file (if already exist)
			exit $SUCCESS			
		elif [ $out == $TRUE -a -z "$4" ]	# -z -> If variavel is NULL
		then
			echo "Error, inform filename"
			[ -e .temp ] && rm .temp	# remove .temp file (if already exist)
			exit $ERROR
		fi
        ;;
esac

[ -e .temp ] && rm .temp	# remove .temp file (if already exist)
exit $SUCCESS
