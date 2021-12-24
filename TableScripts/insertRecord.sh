dbname="hsn"

function insertField {
      if [ $i -eq $coloumnsNomber ]
                then
                echo $1 >> ./databases/$dbname/$tableName
            else
                echo -n $1":" >> ./databases/$dbname/$tableName
      fi
}

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
            fieldName=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f3 `
            echo "this is primary key it must be uniqe"
            read -p "enter value of $fieldName : " value
            
            insertField $value
            ################################
            ## dont forget to check PK value
            ## dont forget to check data type

        else
            fieldName=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f1 `
            read -p "enter value of $fieldName : " value
            #################################
            ## dont forget to check data type
            insertField $value
        fi
    done
else
    echo "there is no such table"
fi
