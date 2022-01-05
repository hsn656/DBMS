#!/bin/bash

########################################################
## function to let u back to menu according to yes or no
########################################################

function waitAndClear {
			sleep .4
			echo -n ".."
			sleep .4
			echo -n ".."
			sleep .4
			clear
}


function menuBack
{
	case $1 in 
		[Yy][Ee][Ss] )	
			echo -n "Back to Main Menu .."
			waitAndClear
			printWithBoarder "  Back to Main Menu   "
			mainMenu
			;;
		[Yy])
			echo -n "Back to Main Menu .."
			waitAndClear
			printWithBoarder "  Back to Main Menu   "
			mainMenu
			;;
		[Nn][Oo] )
			;;
		[Nn] )
			;;
		* )
			read -p "not valid input please try again and enter y or n " answer
			menuBack $answer
	esac
}
#	$2 | expand | awk 'length($0) > length(longest) { longest = $0 } { lines[NR] = $0 } END { gsub(/./, "=", longest); print "+=" longest "=\+"; n = length(longest); for(i = 1; i <= NR; ++i) { printf("| %s %*s\n", lines[i], n - length(lines[i]) + 1, "|"); } print "+\=" longest "=+" }'

function printWithBoarder 
{
    printf "$1\n" > .printtmp
    $2 >> .printtmp
	cat .printtmp | expand |awk 'length($0) > length(longest) { longest = $0 } { lines[NR] = $0 } END { gsub(/./, "=", longest); print "+=" longest "=\+"; n = length(longest); for(i = 1; i <= NR; ++i) { printf("| %s %*s\n", lines[i], n - length(lines[i]) + 1, "|"); } print "+\=" longest "=+" }' 2> .tmp;
}


function mainMenu {
echo "please select one from the following options"
select option in "Create DB" "Rename DB" "Drop DB" "Connect to DB" "Exit"
do 
	case $option in
		"Create DB" )
			echo -n "creating a new Db .."
			waitAndClear	
			. ./DBScripts/createDB.sh $name
			;;
        "Rename DB" )
			echo -n "renaming Database .."
			waitAndClear
			. ./DBScripts/renameDB.sh
            ;;
        "Drop DB" )
			echo -n "Dropping Database .."
			waitAndClear
            . ./DBScripts/dropDB.sh
            ;;
        "Connect to DB" )
			echo -n "Connecting to Database .."
			waitAndClear
			. ./DBSelectionMenu.sh
            ;;
		"Exit" )
			echo "Bye"
			exit
            ;;
		* )
			printWarning "not valid input, please Try again"
			sleep .3
			echo -n "loading again .."
			waitAndClear
			mainMenu
			;;
	esac
done
}

###############
#Message Colors 
Red="\e[31m"
Green="\e[32m"
Yellow="\e[33m"
Blue="\e[34m"
ENDCOLOR="\e[0m"

function printWarning
{
	echo -e "$Yellow$1  ⚠️$ENDCOLOR"
}

function printSucceful
{
	echo -e "$Green$1 ✅$ENDCOLOR"
}

function printFailure
{
	echo -e "$Red$1 ⛔$ENDCOLOR"
}
function printInfo
{
	echo -e "$Blue$1 $ENDCOLOR"
}

######################################################
##		  			 Script Start	    			##
######################################################
clear
printWithBoarder "   Welcome in our DBMS  "

## to create data bases container if it is not exit ##
if [ -d databases ]
	then
	echo -n ""
else
	echo "This is your first time; Hope you Enjoy"
	mkdir ./databases
fi
#############################################

PS3="Enter Number of option : "

mainMenu

