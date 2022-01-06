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
		echo "Press [y] to go back to main menu or press [n] to create another database : "
		read answer	
		menuBack $answer
		echo -n "creating a new Db .. "
		waitAndClear
		. ./DBScripts/createDB.sh
	else
		mkdir ./databases/$dbname
		sleep .7
		echo -n "creating a new Db .. "
		printSuccessful "1 DB with name \"$dbname\" has been created successfully"
		printInfo "Press [y] to go back to main menu or press [n] to create another database : " 
		read answer
		menuBack $answer
		waitAndClear
		. ./DBScripts/createDB.sh
	fi
else
	echo "Press [y] to go back to main menu or press [n] to create a database : "
	read answer	
	menuBack $answer
	echo -n "creating a new Db .. "
	waitAndClear
	. ./DBScripts/createDB.sh
fi

