#!/bin/bash

## to create data bases container if it is not exit
###########################################
if [ -d data ]
	then
	echo "Welcome in our DBMS"
else
	echo "This is your first time; Hope you Enjoy"
	mkdir databases
fi
#############################################



## Star Menu
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
                        echo "done 2"
			./DBScripts/test.sh
                        ;;
                "Drop DB" )
                        echo "done 3"
                        ;;
                "Use Specific DB" )
                        echo "done 4"
                        ;;

		* )
			echo "ay 7aga"
		;;
	esac
done
#############################################
