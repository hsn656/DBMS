#!/bin/bash 
printSuccessful "\nConnected to \"$dbname\""
printWithBoarder "   Rename Table   "
printWithBoarder "avilable tables are : " "ls -1 ./databases/$dbname"
read -p "Enter table name you want to rename : " tableName

if [ $tableName ]
then
    if [ -a  ./databases/$dbname/"$tableName" ]
    then
        read -p "Enter the new name : " newName
        if [ -a  ./databases/$dbname/"$newName" ]
        then
            printFailure "tbale with the name \"$newName\" exists"
        else
        mv  ./databases/$dbname/"$tableName"  ./databases/$dbname/"$newName"
        printSuccessful "Table \"$tableName\" changed to \"$newName\""
        fi
    else
        printFailure "\"$tableName\" Doesn't exist"
    fi
else
  printFailure "invalid input please enter a valid name"
fi


routeFromTable renameTable.sh "Rename table .."


