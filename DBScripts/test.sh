#!/bin/bash
##for testing and trying
## %id%int%Pk%


grep "%," ./databases/hsn/t | cut -d "," -f$i | cut -d "%" -f2
grep "%," ./databases/hsn/t | cut -d "," -f$i | cut -d "%" -f3


awk -F, 'NR>1 {for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s","\t"$i"\t"}}' ./databases/hsn/t
