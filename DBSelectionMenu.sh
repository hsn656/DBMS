#!/bin/bash

## functions for table
function insertField {
      if [ $i -eq $coloumnsNomber ]
                then
                echo $1 >> ./databases/$dbname/$tableName
            else
                echo -n $1":" >> ./databases/$dbname/$tableName
      fi
}

function checkInt {
    expr $1 + 1 2> /dev/null >> /dev/null
}

function checkPK {
    if `cut -f$1 -d: ./databases/hsn/test | grep -w $2 >> /dev/null 2>/dev/null`
        then
        return 1
    else
        return 0
    fi
}


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
                . ./TableScripts/dropTable.sh
                ;;
            "update table" )
                . ./TableScripts/updateRecord.sh
                ;;
            "insert record" )
                . ./TableScripts/insertRecord.sh
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

