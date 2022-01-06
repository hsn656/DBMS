#!/bin/bash 
printWithBoarder "   Drop Datebase   "
printWithBoarder "Avilable Databases: " "ls ./databases"

read -p "Which DB you want to drop : " dbname
if isValidName $dbname
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
                    printSuccessful "\"$dbname\" dropped successfully"
                    menuMessage
                    read answer
                    menuBack $answer
                    echo -n "drop Db .."
                    waitAndClear
                    . ./DBScripts/dropDB.sh
                    break
                    ;;
                'n') 
                    menuMessage
                    read answer
                    menuBack $answer
                    echo -n "Deleting Another Db .."
                    waitAndClear
                    . ./DBScripts/dropDB.sh             
                    break
                    ;;
                *)  
                    printWarning "Choose Valid Option"
                    ;;
                esac
                done
    else
        printFailure "\"$dbname\" Doesn't exist!"
        menuMessage
        read answer
        menuBack $answer
        echo -n "Deleting Another DB .."
        waitAndClear
        . ./DBScripts/dropDB.sh 
    fi
else
    menuMessage
    read answer
    menuBack $answer
    echo -n "Deleting Another DB .."
    waitAndClear
    . ./DBScripts/dropDB.sh
fi


