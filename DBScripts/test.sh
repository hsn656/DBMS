#!/bin/bash

select db in `ls ./databases`
do
    if [ -d $db ]
        then 
        echo "this is dir $db"
    fi
done
