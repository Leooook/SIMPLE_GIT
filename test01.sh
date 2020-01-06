#!/bin/sh

#Testing add functionality

rm -rd ".legit"
./legit.pl init > /dev/null 2>&1

seq 1 2 > a.txt
seq 10 20 > b.txt
seq 100 200 > c.txt

standard_out=$(perl legit.pl add d.txt 2>&1)

if [[ "$standard_out" == "legit.pl: error: can not open 'd.txt'" ]]
then
	echo "Success Program -- 'legit.pl: error: can not open d.txt'"
else
	echo "Failed Program -- 'legit.pl: error: can not open d.txt'"
	exit 1
fi

./legit.pl add a.txt > /dev/null 2>&1

if [[ -f ".legit/index/a.txt" ]]
then
	echo "Add one file Successful"
else
	echo "Add one file Failed"
	exit 1
fi

./legit.pl add b.txt c.txt > /dev/null 2>&1

if [[ -f ".legit/index/b.txt" && -f ".legit/index/c.txt" ]]
then
	echo "Add more than one files Successful"
else
	echo "Add more than one files Failed"
	exit 1
fi

exit 0
