#!/bin/bash
if [ $# -eq 1 ]
	then
	if [ -d ./databases/$1 ]
		then
		echo "DB already exists"
	else
		mkdir ./databases/$1
		echo "Creation successfull"
		echo "1 DB with name $1 has been created"
	fi
else
	echo "invalid input; only enter one argument"
fi
