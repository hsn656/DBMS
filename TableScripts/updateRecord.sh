
##############################
## temp for test
dbname="hsn"
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

        if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$coloumnIndex | grep "%PK%" ` 
        then
            checkPK $coloumnIndex $newValue
            while [ $? != 0 ]
            do
                echo "Violation of PK constraint"
                echo "please enter a valid value"
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

        ############################### ci=2 && cvalue=hsn >>> $2==hsn && 3=>23 >>>> $3=23
        ## to update table 
        awk -F:  '( NR!=1 && $"'$conditionIndex'"=="'$conditionValue'" ) {$"'$coloumnIndex'"="'$newValue'"} {for(i=1 ;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}' ./databases/$dbname/$tableName > ./.tmp;
        

        #####################################
        ## to prevent update if it violate pk
        if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$coloumnIndex | grep "%PK%" ` 
        then 
            x=`cat ./.tmp | cut -f$coloumnIndex -d:| grep -w $newValue|wc -l | cut -f1 -d" "`
            echo $x
            if [ $x -gt 1 ]
            then
                echo "update fail due to PK constraint violation"
                 rm ./.tmp;
            fi   
        fi
        
        if [ -a ./.tmp ]
        then
            cat ./.tmp > ./databases/$dbname/$tableName;
            rm ./.tmp;
            echo "update successfull"
        fi

else
    echo "there is no such table"
fi