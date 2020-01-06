#!/bin/sh

#Testing status functionailty

rm -rd ".legit"
./legit.pl init > /dev/null 2>&1

seq 1 2 > a.txt
seq 1 2 > b.txt
seq 1 2 > c.txt
seq 1 2 > d.txt
seq 1 2 > e.txt
seq 1 2 > f.txt
seq 1 2 > g.txt
./legit.pl add a.txt b.txt c.txt d.txt e.txt f.txt
./legit.pl commit -m 'zero' > /dev/null 2>&1
echo 3 >> a.txt
echo 3 >> b.txt
echo 3 >> c.txt
./legit.pl add a.txt b.txt
echo 4 >> a.txt
rm d.txt
./legit.pl rm e.txt
./legit.pl add g.txt

standard_out=$(perl legit.pl status 2>&1)
if [[ $standard_out == "a.txt - file changed, different changes staged for commit
b.txt - file changed, changes staged for commit
c.txt - file changed, changes not staged for commit
d.txt - file deleted
e.txt - deleted
f.txt - same as repo
g.txt - added to index
legit.pl - untracked
" ]]
then
	echo "Status Successful"
else
	echo "Status Failed"
	exit 1
fi
