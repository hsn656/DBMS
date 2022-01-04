#!/bin/bash 
echo "+-----------------------+"
echo "|   Deleting Datebase   |"
echo "+-----------------------+"
echo "Avilable Databases are : "
ls ./databases
echo "===================================="

read -p "Which DB name you want to drop : " dbname

if [ -d  ./databases/$dbname ]
then
    echo "Are you sure you want to delete $dbname"
    select choice in 'y' 'n'
        do 
            case $choice in
            'y') 
                rm -r ./databases/$dbname
                sleep .7
                echo "Successfull Delete"
                echo "1 DB with name $dbname has been droped"
                read -p "Press [y] to go back to main menu or press [n] to delete another database : " answer
                menuBack $answer
                echo -n "creating a new Db .."
                waitAndClear
                . ./DBScripts/dropDB.sh
                break
                ;;
            'n') 
                read -p "to go back to main menu press [y] or press [n] to delete anothe DB : " answer
                menuBack $answer
                echo -n "Deleting Another Db .."
                waitAndClear
                . ./DBScripts/dropDB.sh             
                break
                ;;
            *) echo "Choose Valid Option" ;;
            esac
            done
else
    echo "$dbname Doesn't exist!"
    read -p "to go back to main menu press [y] or press [n] to try again : " answer
    menuBack $answer
    echo -n "Deleting Another Db .."
    waitAndClear
    . ./DBScripts/dropDB.sh 
fi


