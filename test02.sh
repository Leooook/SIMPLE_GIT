#!/bin/bash

#Testing commit functionailty

rm -rd ".legit"
./legit.pl init > /dev/null 2>&1

seq 1 2 > a.txt
seq 10 20 > b.txt
seq 100 200 > c.txt

./legit.pl add a.txt b.txt

standard_out=$(perl legit.pl commit -m "zero" 2>&1)
if [[ $standard_out == "Committed as commit 0" && -f ".legit/master/0/a.txt" && -f ".legit/master/0/b.txt" ]]
then
	echo "Commit serval files Successful"
else
	echo "Commit serval files Failed"
	exit 1
fi

./legit.pl add a.txt b.txt

standard_out=$(perl legit.pl commit -m "one" 2>&1)
if [[ $standard_out == "nothing to commit" ]]
then
	echo "Successful -- 'nothing to commit'"
else
	echo "Failed -- 'nothing to commit'"
	exit 1
fi

