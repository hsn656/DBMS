#!/bin/bash
printWithBoarder "   Renaming Datebase   "
printWithBoarder "Avilable Databases are : " "ls ./databases"

read -p "which db do you want to rename (old name) : " oldName

if [ $oldName ]
then
	if line=`ls ./databases | grep $oldName`
		then 
		read -p "please Enter DB name (new name): " newName
		mv ./databases/$oldName ./databases/$newName
		sleep .7
		printSucceful "Successfull Renaming from $oldName to $newName"
		printInfo "Press [y] to go back to main menu or press [n] to rename another database : "
		read -p "[y] or [n]? " answer	
		menuBack $answer
		echo -n "renaming  Db .."
		waitAndClear
		. ./DBScripts/renameDB.sh
		
	else
		printFailure "this name does not exist please type it correct again"
		printInfo "Press [y] to go back to main menu or press [n] to rename another database : "
		read -p "[y] or [n]? " answer	
		menuBack $answer
		echo -n "renaming  Db .."
		waitAndClear
		. ./DBScripts/renameDB.sh
	fi
else
    printWarning "You cant enter Empty string"
	printInfo "Press [y] to go back to main menu or press [n] to rename another database : "
	read -p "[y] or [n]? " answer	
	menuBack $answer
	echo -n "renaming  Db .."
	waitAndClear
	. ./DBScripts/renameDB.sh
fi


