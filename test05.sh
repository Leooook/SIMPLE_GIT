#!/bin/sh

#Testing commit-add functionality

rm -rd ".legit"
./legit.pl init > /dev/null 2>&1

seq 1 2 > a.txt

./legit.pl add a.txt

standard_out=$(perl legit.pl commit -a -m  "zero" 2>&1)
if [[ $standard_out == "Committed as commit 0" && -f ".legit/master/0/a.txt" ]]
then
        echo "Commit add serval files from index Successful"
else
        echo "Commit addserval files from index Failed"
        exit 1
fi

echo 0 > a.txt
./legit.pl commit -a -m "one" > /dev/null 2>&1

standard_out=$(perl legit.pl show 1:a.txt 2>&1)
if [[ $standard_out == "0" ]]
then
        echo "Commit update serval files from workpath Successful"
else
        echo "Commit update serval files from workpath Failed"
        exit 1
fi
