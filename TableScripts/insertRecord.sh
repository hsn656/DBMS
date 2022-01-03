echo "avilable tables are : "
ls -1 ./databases/$dbname
read -p "please enter table name : " tableName
if [ -a ./databases/$dbname/$tableName ]
    then
    coloumnsNomber=`awk -F: 'NR==1 {print NF}' ./databases/$dbname/$tableName`

    for (( i=1; i <= $coloumnsNomber; i++ ))
    do
        ##############################
        ## inserting primary key field
        if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | grep "%PK%" ` 
            then 
            fieldName=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f3 `
            fieldType=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f4 `
            echo "this is primary key it must be uniqe"
            read -p "enter ($fieldName) of type ($fieldType) : " value
            
            ###########################
            ## check data type
            if [ $fieldType == "int" ]
                then
                checkInt $value
                while [ $? != 0 ]
                do
                echo "please enter a valid value"
                read -p "enter ($fieldName) of type ($fieldType) : " value
                checkInt $value
                done
            fi

            ############################
            ## check PK constraint
            checkPK $i $value
            while [ $? != 0 ]
            do
                echo "Violation of PK constraint"
                echo "please enter a valid value"
                read -p "enter ($fieldName) of type ($fieldType) : " value
                checkPK $i $value
            done

            insertField $value

        #########################    
        ## inserting normal field
        else
            fieldName=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f1 `
            fieldType=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f2 `
            read -p "enter ($fieldName) of type ($fieldType) : " value

            ###########################
            ## check data type
            if [ $fieldType == "int" ]
                then
                checkInt $value
                while [ $? != 0 ]
                do
                    echo "please enter a valid value"
                    read -p "enter ($fieldName) of type ($fieldType) : " value
                    checkInt $value
                done
            fi

            insertField $value
        fi
    done
else
    echo "there is no such table"
fi
