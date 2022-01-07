#!/bin/bash 
printSuccessful "\nConnected to \"$dbname\""
printWithBoarder "   Drop Table   "
printWithBoarder "avilable tables are : " "ls -1 ./databases/$dbname"

read -p "Table name you want to drop : " tableName

if [ $tableName ]
then
    if [ -f  ./databases/$dbname/$tableName ]
    then
        printWarning "Are you sure you want to delete \"$tableName\""
        select choice in 'y' 'n'
            do 
                case $choice in
                'y') 
                    rm ./databases/$dbname/$tableName
                    printSuccessful "Table \"$tableName\" deleted Successfully"
                    break
                    ;;
                'n') 
                    break
                    ;;
                *) printWarning "Choose Valid Option" ;;
                esac
                done
    else
        printFailure "\"$tableName\" doesn't exist!"
    fi
else
    printFailure "invalid input please enter a valid name"
fi    

routeFromTable dropTable.sh "Drop table .."


