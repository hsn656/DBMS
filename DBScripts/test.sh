#!/bin/bash
##for testing and trying




		printWarning "You cant enter Empty string"
		printInfo "Press [y] to go back to main menu or press [n] to create a database : "
		read -p "[y] or [n]? " answer	
		menuBack $answer
		echo -n "creating a new Db .. \n"
		waitAndClear
		. ./DBScripts/createDB.sh
	