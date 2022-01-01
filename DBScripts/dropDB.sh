#!/bin/bash 

read -p "DB name you want to drop : " dbname

if [ -d  ./databases/$dbname ]
then
    echo "Are you sure you want to delete $dbname"
    select choice in 'y' 'n'
        do 
            case $choice in
            'y') 
                rm -r ./databases/$dbname
                break
                ;;
            'n') 
                exit
                break
                ;;
            *) echo "Choose Valid Option" ;;
            esac
            done
else
    echo "$dbname Doesn't exist!"
fi


