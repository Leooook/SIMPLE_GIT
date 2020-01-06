#!/bin/sh

#Testing branch functionality

rm -rd ".legit"
./legit.pl init > /dev/null 2>&1

seq 1 2 > a.txt

./legit.pl add a.txt

standard_out=$(perl legit.pl branch master 2>&1)

if [[ "$standard_out" == "legit.pl: error: branch 'master' already exists" ]]
then
	echo "Success Branch -- branch 'master' already exists"
else
	echo "Failed Program -- branch 'master' already exists"
	exit 1
fi

standard_out=$(perl legit.pl branch a1 2>&1)

if [[ "$standard_out" == "" ]]
then
	echo "Branch Successful"
else
	echo "Branch Failed"
	exit 1
fi

standard_out=$(perl legit.pl branch a1 2>&1)

if [[ "$standard_out" == "legit.pl: error: branch 'a1' already exists" ]]
then
	echo "Success Branch Twice-- branch 'a1' already exists"
else
	echo "Failed Branch Twice-- branch 'a1' already exists"
	exit 1
fi

exit 0



