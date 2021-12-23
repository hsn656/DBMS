#!/bin/bash
ls


if [ $# -eq 1 ]
	then
	if [ -d $1 ]
		then
		echo "invalid operation as name already exist"
	else
		mv ~/project/data/$1
else
	echo "invalid input; only enter one argument"
fi
