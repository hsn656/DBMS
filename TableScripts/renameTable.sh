#!/bin/bash 

read -p "Table name you want to rename : " tableName


if [ -f  ./databases/$dbname/$tableName ]
then
    read -p "Enter the new name : " newName
    sudo mv  ./databases/$dbname/$tableName  ./databases/$dbname/$newName
    echo "Table $tableName is now $newName"
else
    echo "$tableName Doesn't exist!"
fi


