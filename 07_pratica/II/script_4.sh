#!/bin/bash
echo -n "String: "
read s
echo $s
p=""
for i in $s ; do
if [ -z $p ]; then
p=$i; echo "Primeiro: $p"
fi
done
echo "Ultimo: $i"
