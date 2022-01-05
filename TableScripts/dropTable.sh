#!/bin/bash 

read -p "Table name you want to drop : " tableName

if [ -f  ./databases/$dbname/$tableName ]
then
    printWarning "Are you sure you want to delete $tableName"
    select choice in 'y' 'n'
        do 
            case $choice in
            'y') 
                rm ./databases/$dbname/$tableName
                printSuccessful "Table $tableName deleted Successfully"
                break
                ;;
            'n') 
                break
                ;;
            *) printWarning "Choose Valid Option" ;;
            esac
            done
else
    printFailure "$tableName Doesn't exist!"
fi


