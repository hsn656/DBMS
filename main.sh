#!/bin/bash

########################################################
## function to let u back to menu according to yes or no
########################################################
shopt -s extglob
export LC_COLLATE=C


#Message Colors 
Red="\e[31m"
Green="\e[32m"
Yellow="\e[0;33m"
ENDCOLOR="\e[0m"
Blue="\e[34m"
bold="\033[1m"
normal="\033[0m"

function printWarning
{
	echo -e "$Yellow$1 ⚠️$ENDCOLOR"
}

function printSuccessful
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

function menuMessage
{
	echo -e "${bold}Press [y] to go back to main menu or press [n] to try again :${normal}"
}

function printWithBoarder 
{
    echo -e "$1" > .printtmp
    $2 >> .printtmp
	cat .printtmp | expand |awk 'length($0) > length(longest) { longest = $0 } { lines[NR] = $0 } END { gsub(/./, "=", longest); print "+=" longest "=\+"; n = length(longest); for(i = 1; i <= NR; ++i) { printf("| %s %*s\n", lines[i], n - length(lines[i]) + 1, "|"); } print "+\=" longest "=+" }' 2> .tmp;
}

function isValidName
{
	if [[ $1 =~ ^[A-Za-z]+$ ]] 
	then
		#true "valid Name the contain only characters"
		return 0
	else 
		#conatin special char or number
		printFailure "Invalid name"
		printInfo "DB name can't be \"empty\" or cantaining numbers, spaces or special characters"
		return 1 
	fi
}



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
			printWithBoarder "  DBMS Main Menu   "
			mainMenu
			;;
		[Yy])
			echo -n "Back to Main Menu .."
			waitAndClear
			printWithBoarder "   DBMS Main Menu    "
			mainMenu
			;;
		[Nn][Oo] )
			;;
		[Nn] )
			;;
		* )
			printWarning "Not valid input please try again and enter y or n "
			read answer
			menuBack $answer
	esac
}
#	$2 | expand | awk 'length($0) > length(longest) { longest = $0 } { lines[NR] = $0 } END { gsub(/./, "=", longest); print "+=" longest "=\+"; n = length(longest); for(i = 1; i <= NR; ++i) { printf("| %s %*s\n", lines[i], n - length(lines[i]) + 1, "|"); } print "+\=" longest "=+" }'

function mainMenu {
echo "Please select one of the following options"
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
			echo -n "Loading Databases .."
			waitAndClear
			. ./DBSelectionMenu.sh
            ;;
		"Exit" )
			echo -e "\n ${bold}Bye${normal} 👋"
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

######################################################
##		  			 Script Start	    			##
######################################################
clear
printWithBoarder "   Welcome in our DBMS   "

## to create data bases container if it is not exit ##
if [ -d databases ]
	then
	echo -n ""
else
	echo "This is your first time, Hope you enjoy it"
	mkdir ./databases
fi
#############################################

PS3="Select one of option : "

mainMenu

