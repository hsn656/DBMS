
##############################
## temp for test
dbname="hsn"
function checkInt {
    expr $1 + 1 2> /dev/null >> /dev/null
}
#############################


echo "avilable tables are : "
ls ./databases/$dbname
read -p "please enter table name : " tableName


if [ -a ./databases/$dbname/$tableName ]
    then
    coloumnsNomber=`awk -F: 'NR==1 {print NF}' ./databases/$dbname/$tableName`
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | grep "%PK%" ` 
            then
                echo "PK"
                coloumnsNames[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f3 `
                coloumnsTypes[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f4 `
            else
                echo "NO PK"
                coloumnsNames[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f1 `
                coloumnsTypes[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f2 `
            fi
        done
        
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done
        

        awk -F: -v c=${coloumnsNames[1]} '{print c }' ./databases/$dbname/$tableName

        ###############################################
        ## get index of the coloumn he wanted to update
        read -p "enter nomber of coloumn you want to update : " coloumnIndex 
        checkInt $coloumnIndex
        while [[ $? -ne 0 || $coloumnIndex -le 0 || $coloumnIndex -gt $coloumnsNomber ]]
        do
            echo "please enter a valid value"
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
                echo "please enter a valid value"
                read -p "enter (${coloumnsNames[coloumnIndex]}) of type (${coloumnsTypes[coloumnIndex]}) : " newValue
                checkInt $newValue
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
        while [[ $? -ne 0 || $conditionIndex -le 0 || $coloumnIndex -gt $coloumnsNomber ]]
        do
            echo "please enter a valid value"
            read -p "enter nomber of coloumn you want to update : " conditionIndex 
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


        
else
    echo "there is no such table"
fi