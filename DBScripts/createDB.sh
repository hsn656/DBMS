#!/bin/bash
printWithBoarder "   Creating Datebase   "

printWithBoarder "Avilable Databases are : " "ls ./databases"

read -p "what is DB name? " dbname
echo $dbname
if [ $dbname ]
then
    if [ -d ./databases/$dbname  ]
		then
		printFailure "DB already exists"
		printInfo "Press [y] to go back to main menu or press [n] to create another database : "
		read -p "[y] or [n]? " answer	
		menuBack $answer
		echo -n "creating a new Db .."
		waitAndClear
		. ./DBScripts/createDB.sh
	else
		mkdir ./databases/$dbname
		sleep .7
		printSucceful "1 DB with name $dbname has been created successfully"
		printInfo "Press [y] to go back to main menu or press [n] to create a database : "
		read -p "[y] or [n]? " answer	
		menuBack $answer
		echo -n "creating a new Db .."
		waitAndClear
		. ./DBScripts/createDB.sh
	fi
else
    printWarning "You cant enter Empty string"
	printInfo "Press [y] to go back to main menu or press [n] to create a database : "
	read -p "[y] or [n]? " answer	
	menuBack $answer
	echo -n "creating a new Db .."
	waitAndClear
	. ./DBScripts/createDB.sh
fi

