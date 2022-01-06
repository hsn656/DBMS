#!/bin/bash
printWithBoarder "   Renaming Datebase   "
printWithBoarder "Avilable Databases are : " "ls ./databases"

read -p "Which DB you want to rename : " oldName

if  isValidName $oldName 
then
	if line=`ls ./databases | grep $oldName`
		then 
		read -p "please Enter DB name (new name): " newName
		if  isValidName $newName 
		then
			if [ -d ./databases/$newName  ]
			then
				printFailure "DB with the name \"$newName\" already exists"
				menuMessage
				read answer	
				menuBack $answer
				echo -n "renaming  Db .."
				waitAndClear
				. ./DBScripts/renameDB.sh

			else
			mv ./databases/$oldName ./databases/$newName
			sleep .7
			printSucceful "Successfull Renaming from \"$oldName\" to \"$newName\""
			menuMessage
			read answer	
			menuBack $answer
			echo -n "renaming  Db .."
			waitAndClear
			. ./DBScripts/renameDB.sh
			fi
		else
			menuMessage
			read answer	
			menuBack $answer
			echo -n "creating a new Db .. "
			waitAndClear
			. ./DBScripts/renameDB.sh
		fi

	else
		printFailure "\"$oldName\" does not exist please try again"
		menuMessage
		read answer	
		menuBack $answer
		echo -n "renaming  Db .."
		waitAndClear
		. ./DBScripts/renameDB.sh
	fi
else
	menuMessage
	read answer	
	menuBack $answer
	echo -n "creating a new Db .. "
	waitAndClear
	. ./DBScripts/renameDB.sh
fi


