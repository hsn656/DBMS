#!/bin/bash

echo "Available Databases are : "
ls ./databases
read -p "enter DB Name : " dbname
if [ -d ./databases/$dbname ]
    then
    select option in "create table" "drop table" "update table" "insert record" "Delete from table" "Select from table"
    do
        case $option in 
            "create table" )
                . ./TableScripts/createTable.sh
                ;;
            "drop table" )
                echo "drop table"
                ;;
            "update table" )
                echo "update table"
                ;;
            "insert record" )
                echo "insert record"
                ;;
            "Delete from table" )
                echo "Delete from table"
                ;;
            "Select from table" )
                echo "Select from table"
                ;;
            * )
                echo "not valid option"
                read -p "please try a valid option or you can go to main menu by pressing y? " answer
                menuBack $answer
                echo $PWD
                . ./DBSelectionMenu.sh
                ;;
        esac
    done
else
    echo "not valid"
fi

