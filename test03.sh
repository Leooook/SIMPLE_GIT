#!/bin/bash

#Testing log functionailty

rm -rd ".legit"
./legit.pl init > /dev/null 2>&1

seq 1 2 > a.txt
seq 10 20 > b.txt
seq 100 200 > c.txt

./legit.pl add a.txt b.txt
./legit.pl commit -m 'zero' > /dev/null 2>&1

standard_out=$(perl legit.pl log 2>&1)
if [[ $standard_out == "0 zero" ]]
then
	echo "Log once Successful"
else
	echo "Log once failed"
	exit 1
fi

./legit.pl add c.txt 
./legit.pl commit -m 'one' > /dev/null 2>&1

standard_out=$(perl legit.pl log 2>&1)

if [[ $standard_out == "1 one
0 zero" ]]
then
	echo "Log twice Successful"
else
	echo "Log twice failed"
	exit 1
fi

