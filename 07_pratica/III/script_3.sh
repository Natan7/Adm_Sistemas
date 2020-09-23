#!/bin/bash

echo "Script c)"
say () {
	if [ $# -eq 0 ]; then
		echo "nothing to say"
		return 1
	fi
	echo "I say, " $*
return 0
}
say hello
say hello hello
say "helo hello hello"
say
echo just say `say`
echo
