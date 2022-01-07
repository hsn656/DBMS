printWithBoarder "   Updating Table   "
printWithBoarder "Available tables: " "ls -1 ./databases/$dbname"

echo -e -n "\n${bold}Enter table name: ${normal}"
read tableName

if [ $tableName ]
then
    if [ -a ./databases/$dbname/$tableName ]
    then
    clear
    printWithBoarder "   Updating Table $tableName   "
    coloumnsNomber=`awk -F: 'NR==1 {print NF}' ./databases/$dbname/$tableName`
       
        ## to read all column names and data types
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            #######################    
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
        
        echo "table columns are : "
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done
        

        ###############################################
        ## get index of the coloumn he wanted to update
        read -p "enter nomber of coloumn you want to update : " coloumnIndex 
        checkInt $coloumnIndex
        while [[ $? -ne 0 || $coloumnIndex -le 0 || $coloumnIndex -gt $coloumnsNomber ]]
        do
            printFailure "please enter a valid value"
            printInfo "ener value in between 1 and $coloumnsNomber"
            read -p "enter nomber of coloumn you want to update : " coloumnIndex 
            checkInt $coloumnIndex
        done 

        ##############################################
        ## check data type of new value
        read -p "Enter a new value of type (${coloumnsTypes[coloumnIndex]}) : " newValue;
        if [ ${coloumnsTypes[coloumnIndex]} == "int" ]
            then
            checkInt $newValue
            while [ $? != 0 ]
            do
                printFailure "please enter a valid value"
                printInfo "enter only numbers"
                read -p "enter (${coloumnsNames[coloumnIndex]}) of type (${coloumnsTypes[coloumnIndex]}) : " newValue
                checkInt $newValue
            done
        fi
        ####################
        ## check if he update pk

        if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$coloumnIndex | grep "%PK%" ` 
        then
            checkPK $coloumnIndex $newValue
            while [ $? != 0 ]
            do
                printFailure "Violation of PK constraint"
                printFailure "please enter a valid value"
                read -p "enter (${coloumnsNames[coloumnIndex]}) of type (${coloumnsTypes[coloumnIndex]}) : " newValue
                checkPK $coloumnIndex $newValue
            done
        fi
        ################################
        ## read condition   
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
            printInfo "ener value in between 1 and $coloumnsNomber"
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
                printFailure "please enter a valid value"
                printInfo "enter only numbers"
                read -p "enter (${coloumnsNames[conditionIndex]}) of type (${coloumnsTypes[conditionIndex]}) : " conditionValue
                checkInt $conditionValue
            done
        fi

        ############################### ci=2 && cvalue=hsn >>> $2==hsn && 3=>23 >>>> $3=23
        ## to update table 
        awk -F:  '( NR!=1 && $"'$conditionIndex'"=="'$conditionValue'" ) {$"'$coloumnIndex'"="'$newValue'"} {for(i=1 ;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}' ./databases/$dbname/$tableName > ./.tmp;
        

        #####################################
        ## to prevent update if it violate pk
        if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$coloumnIndex | grep "%PK%" ` 
        then 
            x=`cat ./.tmp | cut -f$coloumnIndex -d:| grep -w $newValue|wc -l | cut -f1 -d" "`
            if [ $x -gt 1 ]
            then
                printFailure "update fail due to PK constraint violation"
                 rm ./.tmp;
            fi   
        fi
        
        if [ -a ./.tmp ]
        then
            cat ./.tmp > ./databases/$dbname/$tableName;
            rm ./.tmp;
            printSuccessful "update successfull"
        fi
    else
        printFailure "there is no such table"
    fi
else
    printFailure "invalid input please enter a valid name"
fi

## to go back or stay
echo -e "${bold}Press [y] to go back to previous menu or press [n] to try again :${normal}"
select answer in "y" "n"
do
    case $answer in
    "y" )
        echo -n "going back .."
        waitAndClear
        afterConnection
        ;;
    "n" )
        echo -n "Updating table .."
        waitAndClear
        . ./TableScripts/updateRecord.sh
        ;; 
    * )
        printWarning "Please choose a valid option [use 1 or 2 ]"
        ;;
    esac
done 
