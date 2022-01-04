#!/bin/bash
echo "Avilable Databases are :"
ls ./databases
echo "#######################"
read -p "which name do you want to change : " oldName

if line=`ls ./databases | grep $oldName`
	then 
	read -p "please Enter your name : " newName
	mv ./databases/$oldName ./databases/$newName
	echo "Successfull Renaming"
	. ./main.sh
else
	echo "this name does not exist please type it correct again"
	read -p "if you changed your mind you can back to main menu by pressing y or press n for continue" answer
	menuBack $answer
	. ./DBScripts/renameDB.sh
fi



