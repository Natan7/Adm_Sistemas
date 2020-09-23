#!/bin/bash

echo "Script d)"
f () {
	echo "$FUNCNAME : Y= $Y"
	X=77
	Y=88
	echo "$FUNCNAME : X= $X"
	echo "$FUNCNAME : Y= $Y"
}

Y=66
echo "Y= $Y"
f
echo "X= $X"
echo "Y= $Y"
echo
