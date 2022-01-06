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
                printSuccessful "Table \"$tableName\" deleted Successfully"
                sleep 2
                echo -n "going to previous menu.."
                waitAndClear
                afterConnection
                break
                ;;
            'n') 
                echo -n "going to previous menu.."
                waitAndClear
                afterConnection
                break
                ;;
            *) printWarning "Choose Valid Option" ;;
            esac
            done
else
    printFailure "$tableName Doesn't exist!"
    sleep 2
    echo -n "going to previous menu.."
    waitAndClear
    afterConnection
fi


