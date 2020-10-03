#!/bin/bash

SUCCESS=0        
ERROR=1

LAST=$(last -s -$2days -t today) #retorna todos os logins desde $2 dias atrás até hoje

L=$(grep "^UID_MIN" /etc/login.defs)
L1=$(grep "^UID_MAX" /etc/login.defs)

USERS=$(awk -F':' -v "min=${L##UID_MIN}" -v "max=${L1##UID_MAX}" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | awk -F':' '{ print $1}') #retorna apenas os nomes dos usuários normais. Sem considerar usuários do sistema

case "$1" in
	-block )
	
	;;
	-remove )
	
	;;
	*)
		echo "ERROR, try -block [days] or -remove [days] options"
		exit $ERROR
	;;
esac
