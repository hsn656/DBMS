
##############################
## temp for test
#dbname="hsn"

function checkInt {
    expr $1 + 1 2> /dev/null >> /dev/null
}
#############################



printWithBorder "avilable tables are : " "ls -1 ./databases/$dbname"
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
        

        

        ################################
        ## read condition   
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done

        ########################################
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
     
        ###############################
        ## to delete from table
  #awk -F:  '( NR!=1 && $"'$conditionIndex'"=="'$conditionValue'" ) {$"'$coloumnIndex'"="'$newValue'"} {for(i=1 ;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}' ./databases/$dbname/$tableName > ./tmp;
        awk -F:  ' $"'$conditionIndex'"!="'$conditionValue'" {for(i=1 ;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}' ./databases/$dbname/$tableName > ./.tmp;
        #sed -i ./databases/$dbname/$tableName
        if [ -a ./.tmp ]
        then
            cat ./.tmp > ./databases/$dbname/$tableName;
            rm ./.tmp;
            echo "Deleted successfully"
        fi

else
    echo "there is no such table"
fi