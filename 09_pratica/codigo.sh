#!/bin/bash

SUCCESS=0        
ERROR=1

LAST_LOGGINS=$(last -s -$2days -t today | head -n -2) #retorna todos os logins desde $2 dias atrás até hoje

if [ -n "$LAST_LOGGINS" ]
then
	echo "OK. Users found"
else 
	echo "No users logged in in the determined period"
	exit $ERROR
fi

L=$(grep "^UID_MIN" /etc/login.defs)
L1=$(grep "^UID_MAX" /etc/login.defs)

USERS=$(awk -F':' -v "min=${L##UID_MIN}" -v "max=${L1##UID_MAX}" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | awk -F':' '{ print $1}') #retorna apenas os nomes dos usuários normais. Sem considerar usuários do sistema

case "$1" in
	-block )
		for user in $USERS
		do
			if [[ $LAST_LOGGINS =~ .^${user}.* ]]
			then 
				echo "NOT BLOCKING USER ${user}"
			else
				echo "BLOCKING USER ${user}" # Os usuarios que não estiverem na lista do LAST_LOGGINS serão bloqueados
				sudo passwd -lock ${user}
			fi
		done
	;;
	-remove )
		for user in $USERS
		do
			if [[ $LAST_LOGGINS =~ .^${user}.* ]]
			then 
				echo "NOT REMOVING USER ${user}"
			else
				echo "BACKING UP FILES FROM /home/${user}" # Os usuarios que não estiverem na lista do LAST_LOGGINS serão removidos do sistema
			fi
		done
	
	;;
	*)
		echo "ERROR, try -block [days] or -remove [days] options"
		exit $ERROR
	;;
esac

exit $SUCCESS
