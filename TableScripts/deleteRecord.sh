
##############################
## temp for test
#dbname="hsn"

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
        ####################
        ## check if he update pk

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

        ###############################
        ## to update table
        gawk -i -F:  ' $"'$conditionIndex'"!="'$conditionValue'" {for(i=1 ;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}';  
        echo "Deleted successfully"

        #####################################
        ## to prevent update if it violate pk
        if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$coloumnIndex | grep "%PK%" ` 
        then 
            x=`cat ./tmp | cut -f$coloumnIndex -d:| grep -w $newValue|wc -l | cut -f1 -d" "`
            echo $x
            if [ $x -gt 1 ]
            then
                echo "update fail due to PK constraint violation"
                 rm ./tmp;
            fi   
        fi

else
    echo "there is no such table"
fi