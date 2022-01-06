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


function checkInt {
    expr $1 + 1 2> /dev/null >> /dev/null
}

#############################

function checkPK {
   if `cut -f$1 -d: ./databases/hsn/test | grep -w $2 >> /dev/null 2>/dev/null`
        then
        return 1
    else
        return 0
    fi 
}

function afterConnection 
{
    clear
    printSuccessful "\nConnected to \"$dbname\""
    printWithBoarder "Available tables: " "ls -1 ./databases/$dbname"
    echo "===================================="

    select option in "Create table" "Drop table" "Rename table" "Update table" "Insert record" "Delete from table" "Select from table" "Back to main menu"
    do
        case $option in 
            "Create table" )
                . ./TableScripts/createTable.sh
                ;;
            "Drop table" )
                echo "drop table"
                . ./TableScripts/dropTable.sh
                ;;
            "Rename table" )
                . ./TableScripts/renameTable.sh
                ;;    
            "Update table" )
                . ./TableScripts/updateRecord.sh
                ;;
            "Insert record" )
                . ./TableScripts/insertRecord.sh
                ;;
            "Delete from table" )
                . ./TableScripts/deleteRecord.sh
                ;;
            "Select from table" )
                echo "Select from table"
                ;;
            "Back to main menu" )
                menuBack y
                ;;   
            * )
                printWarning "not valid option"
                ;;
        esac
    done
}

function beforeConnection
{
    clear
    printWithBoarder "Available Databases:" "ls -1 ./databases"
    read -p "Enter DB name : " dbname
    if [ -d ./databases/$dbname ]
        then
        echo -n "Connecting to \"$dbname\".."
        waitAndClear
        afterConnection 
    else
        printFailure "\"$dbname\" doesn't exist"
        menuMessage
        read answer
        menuBack $answer
        echo -n "Connecting to another DB .."
        waitAndClear 
        . ./DBSelectionMenu.sh
    fi
}

beforeConnection
