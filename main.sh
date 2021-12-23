#!/bin/bash

########################################################
## function to let u back to menu according to yes or no
########################################################
function menuBack
{
	case $1 in 
		[Yy][Ee][Ss] )	
			echo "#######################"		
			echo "back to main menu "
			. ./main.sh
			;;
		[Yy])
			echo "#######################"
			echo "back to main menu "
			. ./main.sh
			;;
		[Nn][Oo] )
			;;
		[Nn] )
			;;
		* )
			read -p "not valid input please try again and enter y or n" answer
			menuBack $answer
	esac
}

###################################################
## to create data bases container if it is not exit
###################################################

echo "#######################"
if [ -d databases ]
	then
	echo "Welcome in our DBMS"
else
	echo "This is your first time; Hope you Enjoy"
	mkdir databases
fi
echo "#######################"
#############################################


#############################################
## Star Menu ###
#############################################
echo "please select one from the following options"
select option in "Create DB" "Rename DB" "Drop DB" "Use Specific DB"
do 
	case $option in
		"Create DB" )
			read -p "what is DB name? " name
			. ./DBScripts/createDB.sh $name
			;;
        "Rename DB" )
			. ./DBScripts/renameDB.sh
            ;;
        "Drop DB" )
            echo "done 3"
            ;;
        "Use Specific DB" )
			. ./DBSelectionMenu.sh
            ;;
		* )
			echo "ay 7aga"
			;;
	esac
done
#############################################
