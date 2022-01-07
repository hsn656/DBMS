#!/bin/bash

#########################
## Function for select script
function readConditionForSelect {
        
        ############################
        ## to show avilable columns
        echo "table columns are : "
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done
        
        ############################
        ## check if condition index is a number 
        read -p "condition on which coloumn number : " conditionIndex 
        checkInt $conditionIndex
        while [[ $? -ne 0 || $conditionIndex -le 0 || $conditionIndex -gt $coloumnsNomber ]]
        do
            printFailure "please enter a valid value"
            read -p "condition on which coloumn number : " conditionIndex 
            checkInt $conditionIndex
        done 


        ##############################################
        ## check data type of condition value
        read -p "Enter a condition value of type (${coloumnsTypes[conditionIndex]}) : " conditionValue;
        if [ ${coloumnsTypes[conditionIndex]} == "int" ]
            then
            checkInt $conditionValue
            while [ $? != 0 ]
            do
                printFailure "please enter a valid value"
                read -p "enter (${coloumnsNames[conditionIndex]}) of type (${coloumnsTypes[conditionIndex]}) : " conditionValue
                checkInt $conditionValue
            done
        fi
        if [ $firstCondition == "true" ]
        then
            firstCondition="false"
            awk -F:  '( NR!=1 && $"'$conditionIndex'"=="'$conditionValue'" ) {{for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s",$i":"}}}' ./databases/$dbname/$tableName >> .tmp1
        else
            cp ./.tmp1 ./.tmp2
            awk -F:  ' ( NR==1 || $"'$conditionIndex'"=="'$conditionValue'" ) {{for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s",$i":"}}}' .tmp2 > .tmp1
            rm ./.tmp2
        fi        
        echo "do you want use another condition?"
        loopBackOrNot
}

function loopBackOrNot {
    select option in "yes" "no"
    do 
	case $option in
		"yes" )
			readConditionForSelect
            break
			;;
        "no" )
            break
			;;
        * )
            printFailure "invalid choice"
            loopBackOrNot
            break
            ;;     
	esac
    done
}
#########################
printWithBoarder "   Selecting Data from Table   "
printWithBoarder "Avilable tables: " "ls -1 ./databases/$dbname"

read -p "Enter table name to select from: " tableName

if [ $tableName ]
then
    if [ -a ./databases/$dbname/$tableName ]
        then
        coloumnsNomber=`awk -F: 'NR==1 {print NF}' ./databases/$dbname/$tableName`
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            #######################      name%string%
            ## this if condition because cut in case of pk is different
            if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | grep "%PK%" ` 
            then
                coloumnsNames[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f3 `
                coloumnsTypes[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f4 `
            else
                coloumnsNames[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f1 `
                coloumnsTypes[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f2 `
            fi
        done

        ## to show header for table
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            if [ $i -eq $coloumnsNomber ]
            then
                echo ${coloumnsNames[i]} >> ./.tmp1
            else
                echo -n ${coloumnsNames[i]}":" >> ./.tmp1
            fi
        done

        echo "Do you want to use conditions?"
        firstCondition="true"
        select option in "yes" "no"
        do 
        case $option in
            "yes" )
                readConditionForSelect
                break
                ;;
            "no" )
                awk -F:  ' NR!=1 {{for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s",$i":"}}}' ./databases/$dbname/$tableName >> ./.tmp1
                break
                ;;
            * )
                printFailure "invalic choice"
                loopBackOrNot
                break
                ;;     
        esac
        done
        
    printWithBoarder "   $tableName table   "

    

    cat ./.tmp1 | column -s ":" -t
    
    x=`cat ./.tmp1 | wc -l | cut -f1 -d" "`
    if [ $x -eq 1 ]
    then
        printInfo  " no data for this select command "
    else
        printInfo  $(expr $x - 1)" rows was selected "
    fi  
    rm ./.tmp1

    else
        echo "there is no such table"
    fi
else
    printFailure "invalid input please enter a valid name"
fi

echo -e "${bold}choose [y] to go back to previous menu or choose [n] to try again :${normal}"
select answer in "y" "n"
do
    case $answer in
    "y" )
        echo -n "going back .."
        waitAndClear
        afterConnection
        ;;
    "n" )
        echo -n "Selecting from table .."
        waitAndClear
        . ./TableScripts/selectRecords.sh
        ;; 
    * )
        printWarning "Please choose a valid option [use 1 or 2 ]"
        ;;
    esac
done 
