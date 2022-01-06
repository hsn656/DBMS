#!/bin/bash


printWithBoarder "Creating Datebase"

printWithBoarder "Avilable Databases: " "ls ./databases"


echo "===================================="

read -p "Enter new DB name? " dbname

if  isValidName "$dbname"
then
	if [ -d ./databases/$dbname  ]
		then
		printFailure "DB with the name \"$dbname\" already exists"
		menuMessage
		read answer	
		menuBack $answer
		echo -n "creating a new Db .. "
		waitAndClear
		. ./DBScripts/createDB.sh
	else
		mkdir ./databases/$dbname
		mkdir ./databases/$dbname/.tmptable
		sleep .7
		echo -n "creating a new Db .. "
		printSuccessful "\nDB with name \"$dbname\" has been created successfully"
		menuMessage
		read answer
		menuBack $answer
		waitAndClear
		. ./DBScripts/createDB.sh
	fi
else
	menuMessage
	read answer	
	menuBack $answer
	echo -n "creating a new Db .. "
	waitAndClear
	. ./DBScripts/createDB.sh
fi

