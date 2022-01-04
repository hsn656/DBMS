#!/bin/bash
echo "+-----------------------+"
echo "|   Creating Datebase   |"
echo "+-----------------------+"
echo "Avilable Databases are : "
ls ./databases

read -p "what is DB name? " dbname

	if [ -d ./databases/$dbname ]
		then
		echo "DB already exists"
		read -p "if you changed your mind you can back to main menu by pressing y or press n to try again : " answer
		menuBack $answer
		echo -n "creating a new Db .."
		waitAndClear
		. ./DBScripts/createDB.sh
	else
		mkdir ./databases/$dbname
		echo "Creation successfull"
		echo "1 DB with name $dbname has been created"
		read -p "Press [y] to go back to main menu or press [n] to create another table : " answer
		menuBack $answer
		echo -n "creating a new Db .."
		waitAndClear
		. ./DBScripts/createDB.sh
	fi
