
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
        
        ###############################################
        ## get index of the coloumn he wanted to update
        read -p "enter nomber of coloumn you want to update : " coloumnIndex 
        checkInt $coloumnIndex
        while [[ $? -ne 0 || $coloumnIndex -le 0 ]]
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

        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done

        ###############################################
        ## get index of the condition coloumn
        read -p " which coloumn number you want to use for condition " coloumnIndex 
        checkInt $coloumnIndex
        while [[ $? -ne 0 || $coloumnIndex -le 0 ]]
        do
            echo "please enter a valid value"
            read -p "enter nomber of coloumn you want to update : " coloumnIndex 
            checkInt $coloumnIndex
        done 

        
else
    echo "there is no such table"
fi