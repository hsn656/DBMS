#!/bin/bash
echo "your data bases are :"
ls ./databases
echo "#######################"
read -p "which name do you want to change : " oldName

if line=`ls ./databases | grep $oldName`
	then 
	echo "exist"
	read -p "please Enter your name : " newName
	mv ./databases/$oldName ./databases/$newName
	echo "Successfull Renaming"
	. ./main.sh
else
	echo "this name does not exist please type it correct again"
	. ./DBScripts/renameDB.sh
fi



