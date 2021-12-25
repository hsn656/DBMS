#!/bin/bash 

read -p "Table name you want to drop : " tableName

if [ -a  ./databases/$dbname/$tableName ]
then
    echo "Are you sure you want to delete $tableName"
    select choice in 'y' 'n'
        do 
            case $choice in
            'y') 
                rm ./databases/$dbname/$tableName
                break
                ;;
            'n') 
                break
                ;;
            *) echo "Choose Valid Option" ;;
            esac
            done
else
    echo "$tableName Doesn't exist!"
fi


