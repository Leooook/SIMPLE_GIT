#!/bin/sh

#Testing Checkout functionality

rm -rd ".legit"
./legit.pl init > /dev/null 2>&1

seq 1 2 > a.txt

./legit.pl add a.txt

standard_out=$(perl legit.pl checkout master 2>&1)

if [[ "$standard_out" == "Switched to branch 'master'" ]]
then
	echo "Success Checkout -- Switched to branch 'master'"
else
	echo "Failed Checkout -- Switched to branch 'master'"
	exit 1
fi

standard_out=$(perl legit.pl checkout a1 2>&1)

if [[ "$standard_out" == "legit.pl: error: unknown branch 'a1'" ]]
then
	echo "Success Checkout --  unknown branch"
else
	echo "Success Checkout -- unknown branch"
	exit 1
fi

./legit.pl commit -m 'zero' > /dev/null 2>&1
./legit.pl branch a1

standard_out=$(perl legit.pl checkout a1 2>&1)

if [[ "$standard_out" == "Switched to branch 'a1'" ]]
then
	echo "Success Checkout --  Switched to branch"
else
	echo "Success Checkout -- Switched to branch"
	exit 1
fi

exit 0

