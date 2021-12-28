#!/bin/bash
##for testing and trying
# nv="hsm"
# index=2
# ci=1
# cv=1

# awk -F: -v indx=$index -v newValue=$nv -v ci=$ci -v cv=$cv -v found="false" {for (i=1;i<NF;i++) 
#                             {if (i==ci && $i==cv) 
#                                 found="true";
#                                 print found;
#                             else 
#                                 printf "%s" , $i":" ;
#                             }
                            
#                             }' ./databases/hsn/test





# read -p "enter : " value;

# if echo $value | grep " : " >> /dev/null 2> /dev/null
# then 
#     echo "true"
# else 
#     echo "false"
# fi




	awk -F:  '( NR!=1 && $1==2 ) {$2="hsm"} {for(i=1 ;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}' ./databases/hsn/test;
	


