
##############################
## temp for test


function checkInt {
    expr $1 + 1 2> /dev/null >> /dev/null
}
#############################

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
            echo "please enter a valid value"
            read -p "condition on which coloumn number : " conditionIndex 
            checkInt $conditionIndex
        done 


        ##############################################
        ## check data type of condition value
        read -p "Enter a condtion value of type (${coloumnsTypes[conditionIndex]}) : " conditionValue;
        if [ ${coloumnsTypes[conditionIndex]} == "int" ]
            then
            checkInt $conditionValue
            while [ $? != 0 ]
            do
                echo "please enter a valid value"
                read -p "enter (${coloumnsNames[conditionIndex]}) of type (${coloumnsTypes[conditionIndex]}) : " conditionValue
                checkInt $conditionValue
            done
        fi

        if [ $firstCondition == "true" ]
        then
            firstCondition="false"
            awk -F:  '( NR!=1 && $"'$conditionIndex'"=="'$conditionValue'" ) {{for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s",$i":"}}}' ./databases/$dbname/$tableName >> .tmp
        else
            cp ./.tmp ./.tmp2
            echo $conditionIndex $conditionValue
            awk -F:  ' ( NR==1 || $"'$conditionIndex'"=="'$conditionValue'" ) {{for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s",$i":"}}}' .tmp2 > .tmp
            rm ./.tmp2
        fi

        
        echo "do you want use another condition?"
        loopBackOrNot
}

function loopBackOrNot {
    PS3="Enter Your Choice Number : "
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
            echo "invalid choice"
            loopBackOrNot
            break
            ;;     
	esac
    done
}

read -p "Enter table name to select from: " tableName


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

        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            if [ $i -eq $coloumnsNomber ]
            then
                echo ${coloumnsNames[i]} >> ./.tmp
            else
                echo -n ${coloumnsNames[i]}":" >> ./.tmp
            fi
        done

    echo "Do you want to use conditions?"
    PS3="Enter Your Choice Number : "
    firstCondition="true"
    select option in "yes" "no"
    do 
	case $option in
		"yes" )
			readConditionForSelect
            break
			;;
        "no" )
            awk -F:  ' NR!=1 {{for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s",$i":"}}}' ./databases/$dbname/$tableName >> ./.tmp
            break
			;;
        * )
            echo "invalic choice"
            loopBackOrNot
            break
            ;;     
	esac
    done
    
printWithBoarder "        $tableName        "

    cat ./.tmp | column -s ":" -t
    rm ./.tmp

else
    echo "there is no such table"
fi