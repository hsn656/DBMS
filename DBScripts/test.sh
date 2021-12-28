#!/bin/bash
##for testing and trying

x=`wc -l reminders | cut -f1 -d" " `
if [ $x -ge 10 ]
then
	echo $x
else 
	echo hhh
fi