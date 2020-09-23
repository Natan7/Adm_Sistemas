#!/bin/bash

echo "Script c)"
echo -n "String: "
read s
echo $s
s1=${s/a/x} ; echo $s1
s1=${s//a/y} ; echo $s1
echo
