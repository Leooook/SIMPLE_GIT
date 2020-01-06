#!/bin/sh

#Testing Init functionality

rm -rd ".legit" 
./legit.pl init > /dev/null 2>&1

if [[ -d .legit ]]
then
	echo "Init Successful"
else
	echo "Init Failed"
	exit 1
fi

standard_out=$(perl legit.pl init 2>&1)

if [[ "$standard_out" == "legit.pl: error: .legit already exists" ]] 
then
	echo "Success Program -- 'legit.pl: error: .legit already exists'"
else
	echo "Faild Program -- 'legit.pl: error: .legit already exists'"
	exit 1
fi

exit 0
