#!/bin/bash
echo "+-----------------------+"
echo "|   Creating Datebase   |"
echo "+-----------------------+"
echo "Avilable Databases are :"
ls ./databases
echo "===================================="

read -p "which db do you want to rename (old name) : " oldName

if line=`ls ./databases | grep $oldName`
	then 
	read -p "please Enter DB name (new name): " newName
	mv ./databases/$oldName ./databases/$newName
	sleep .7
	echo "Successfull Renaming from $oldName to $newName"

	read -p "Press [y] to go back to main menu or press [n] to rename another database : " answer
	menuBack $answer
	echo -n "creating a new Db .."
	waitAndClear
	. ./DBScripts/renameDB.sh
	
else
	echo "this name does not exist please type it correct again"
	read -p "if you changed your mind you can back to main menu by pressing y or press n for continue" answer
	menuBack $answer
	echo -n "renaming a new Db .."
	waitAndClear
	. ./DBScripts/renameDB.sh
fi



