#!/bin/bash

read -p "Enter table name you want to create : " tableName

## this variable is to check PK 
NoPK_Yet="true"

if [ -a  ./databases/$dbname/"$tableName" ]
    then
    printFailure "Table with name \"$tableName\" already exists"
    menuMessage
    select answer in "y" "n"
    do
        case $answer in
        "y" )
            beforeConnection
            ;;
        "n" )
            afterConnection
            ;; 
        * )
            printWarning "Please choose vlaid option"
            ;;
        esac
    done    
   
else
    touch ./databases/$dbname/.tmptable/"$tableName" 
    read -p "Enter number of coloumns : " coloumnsNomber

    ############################################
    ## to check if number of coloumns is int
    expr $coloumnsNomber + 1 2> /dev/null >> /dev/null
    while [ $? != 0 ]
    do
        printWarning "Please enter a valid number"
        read -p "Enter number of coloumns : " coloumnsNomber
        expr $coloumnsNomber + 1 2> /dev/null >> /dev/null
    done
    ############################################
    ## now read colomn type and names
    i=1
    while [ $i -le $coloumnsNomber ]
    do
        
        ########################
        ## gen name of field
        read -p "Enter column $i name : " coloumnsName;
        while [ -z "$coloumnsName" ]; do
			printFailure "Field name can't be empty";
            read -p "Enter column $i name : " coloumnsName;
		done
        ########################

        ##############################
        ## check if field is PK or not
        while [ $NoPK_Yet == "true" ]
        do
            read -p "is this feild is a primary key? [Y/N] : " IsPK
            if [[ $IsPK == *(y)*(Y)*(yes)*(YES)*(Yes) ]]
            then
                echo -n "%PK%" >> ./databases/$dbname/.tmptable/$tableName
                NoPK_Yet="false"
                break
            elif [[ $IsPK = *(N)*(n)*(NO)*(No)*(no) ]]
            then
                break
            fi
           printWarning "Please Enter valid option" 
        done
        ##############################


        ########################
        ## get datatype of field
        read -p "Enter a valid column $i datatype : [string/int] " dataType;
        while [[ "$dataType" != *(int)*(string) || -z $dataType ]]
        do
			printWarning "Invalid datatype"
			read -p "Enter a valid column $i datatype again : [string/int] " dataType;
		done
        ##############################

        ########################
        ## write in the table file; check to stop adding ":" in the last field
        if [ $i -eq $coloumnsNomber ]
            then
            echo $coloumnsName"%"$dataType"%" >> ./databases/$dbname/.tmptable/$tableName
        else
            echo -n $coloumnsName"%"$dataType"%:" >> ./databases/$dbname/.tmptable/$tableName
        fi
        ##############################
        ((i=$i+1))

    done
    
    mv ./databases/$dbname/.tmptable/$tableName ./databases/$dbname/$tableName
    echo -n "Creating table .."
    waitAndClear
    printSuccessful "\nTable created successfully"
    sleep 1 
    afterConnection
   
fi
