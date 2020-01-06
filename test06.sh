#!/bin/bash

#Testing remove functionailty

rm -rd ".legit"
./legit.pl init > /dev/null 2>&1

seq 1 2 > a.txt

standard_out=$(perl legit.pl rm a.txt 2>&1)
if [[ $standard_out == "legit.pl: error: 'a.txt' is not in the legit repository" ]]
then
	echo "rm Successful -- Remove file is not in the legit repository"
else
	echo "rm Failed -- Remove file is not in the legit repository"
	exit 1
fi

./legit.pl add a.txt 
./legit.pl commit -m 'zero' > /dev/null 2>&1
echo 3 >> a.txt

standard_out=$(perl legit.pl rm a.txt 2>&1)
if [[ $standard_out == "legit.pl: error: 'a.txt' in repository is different to working file" ]]
then
	echo "rm Successful -- Remove file in repository is different to working file"
else
	echo "rm Failed -- Remove file in repository is different to working file"
	exit 1
fi

./legit.pl add a.txt 

standard_out=$(perl legit.pl rm a.txt 2>&1)
if [[ $standard_out == "legit.pl: error: 'a.txt' has changes staged in the index" ]]
then
	echo "rm Successful -- Remove file has changes staged in the index"
else
	echo "rm Failed -- Remove file has changes staged in the index"
	exit 1
fi

echo 4 >> a.txt

standard_out=$(perl legit.pl rm a.txt 2>&1)
if [[ $standard_out == "legit.pl: error: 'a.txt' in index is different to both working file and repository" ]]
then
	echo "rm Successful -- in index is different to both working file and repository"
else
	echo "rm Failed -- in index is different to both working file and repository"
	exit 1
fi

./legit.pl commit -a -m 'one' > /dev/null 2>&1
./legit.pl rm a.txt
if [[ !(-f ".legit/index/a.txt") || !(-f "a.txt") ]]
then
	echo "rm Successful"
else
	echo "rm Failed"
	exit 1
fi

echo 1 2 > a.txt
./legit.pl add a.txt
./legit.pl commit -m 'two' > /dev/null 2>&1
echo 3 >> a.txt
./legit.pl rm --force a.txt

if [[ !(-f ".legit/index/a.txt") || !(-f "a.txt") ]]
then
	echo "rm --force Successful"
else
	echo "rm --force Failed"
	exit 1
fi

echo 1 2 > a.txt
./legit.pl add a.txt
./legit.pl commit -m 'three' > /dev/null 2>&1
./legit.pl rm --cached a.txt

if [[ !(-f ".legit/index/a.txt") && (-f "a.txt") ]]
then
	echo "rm --cached Successful"
else
	echo "rm --cached Failed"
	exit 1
fi
