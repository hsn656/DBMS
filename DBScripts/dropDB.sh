#!/bin/bash 
printWithBoarder "   Deleting Datebase   "
printWithBoarder "Avilable Databases are : " "ls ./databases"

read -p "Which DB name you want to drop : " dbname
if [ $dbname ]
then
    if [ -d  ./databases/$dbname ]
    then
        printWarning "Are you sure you want to delete $dbname"
        select choice in 'y' 'n'
            do 
                case $choice in
                'y') 
                    rm -r ./databases/$dbname
                    sleep .7
                    printSucceful "Successfull Delete"
                    echo "1 DB with name $dbname has been droped"
                    printInfo "Press [y] to go back to main menu or press [n] to rename another database : "
                    read -p "[y] or [n]? " answer
                    menuBack $answer
                    echo -n "dropping  Db .."
                    waitAndClear
                    . ./DBScripts/dropDB.sh
                    break
                    ;;
                'n') 
                    printInfo "Press [y] to go back to main menu or press [n] to drop another database : "
                    read -p "[y] or [n]? " answer
                    menuBack $answer
                    echo -n "Deleting Another Db .."
                    waitAndClear
                    . ./DBScripts/dropDB.sh             
                    break
                    ;;
                *)  printWarning "Choose Valid Option"
                    printInfo "Enter [1] or [2] "
                    ;;
                esac
                done
    else
        printFailure "$dbname Doesn't exist!"
        printInfo "Press [y] to go back to main menu or press [n] to drop a database : "
        read -p "[y] or [n]? " answer
        menuBack $answer
        echo -n "Deleting Another Db .."
        waitAndClear
        . ./DBScripts/dropDB.sh 
    fi
else
    printWarning "You must Enter value"
    printInfo "Press [y] to go back to main menu or press [n] to drop a database : "
    read -p "[y] or [n]? " answer
    menuBack $answer
    echo -n "Deleting Another Db .."
    waitAndClear
    . ./DBScripts/dropDB.sh
fi


