#!/bin/bash 

read -p "Enter table name you want to rename : " tableName


if [ -a  ./databases/$dbname/"$tableName" ]
then
    read -p "Enter the new name : " newName
    if [ -a  ./databases/$dbname/"$newName" ]
    then
        printFailure "tbale with the name \"$newName\" exists"
        sleep 2
        echo -n "going to previous menu.."
        waitAndClear
        afterConnection        
    else
    mv  ./databases/$dbname/"$tableName"  ./databases/$dbname/"$newName"
    printSuccessful "Table \"$tableName\" changed to \"$newName\""
    echo -n "going to previous menu.."
    waitAndClear
    afterConnection
    fi
else
    printFailure "\"$tableName\" Doesn't exist"
    sleep 2
    echo -n "going to previous menu.."
    waitAndClear
    afterConnection
fi


