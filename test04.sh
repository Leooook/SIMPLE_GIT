#!/bin/sh

#Testing show functionailty

rm -rd ".legit"
./legit.pl init > /dev/null 2>&1

seq 1 2 > a.txt

./legit.pl add a.txt 
./legit.pl commit -m 'zero' > /dev/null 2>&1

standard_out=$(perl legit.pl show 5:a.txt 2>&1)
if [[ $standard_out == "legit.pl: error: unknown commit '5'" ]]
then
	echo "Successful -- unknown commit"
else
	echo "failed -- unknown commit"
	exit 1
fi

standard_out=$(perl legit.pl show 0:b.txt 2>&1)
if [[ $standard_out == "legit.pl: error: 'b.txt' not found in commit 0" ]]
then
	echo "Successful -- not found in commit"
else
	echo "failed -- not found in commit"
	exit 1
fi

standard_out=$(perl legit.pl show 0:a.txt 2>&1)
if [[ $standard_out == "1
2" ]]
then
	echo "Show 0:a in once commit Successful"
else
	echo "Show 0:a in once commit failed"
	exit 1
fi

echo 3 >> a.txt
./legit.pl add a.txt 
./legit.pl commit -m 'one' > /dev/null 2>&1

standard_out=$(perl legit.pl show 1:a.txt 2>&1)

if [[ $standard_out == "1
2
3" ]]
then
	echo "Show 1:a in twice commit Successful"
else
	echo "Show 1:a in twice commit failed"
	exit 1
fi

echo  0 > a.txt
./legit.pl add a.txt 

standard_out=$(perl legit.pl show :a.txt 2>&1)
if [[ $standard_out == "0" ]]
then
	echo "Show :a in index Successful"
else
	echo "Show :a in index failed"
	exit 1
fi

