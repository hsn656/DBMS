#!/bin/bash

##for testing and trying

if `cut -f1 -d: ./databases/hsn/test | grep 1 >> /dev/null 2>/dev/null`
then
    echo exits
else
    echo not
fi