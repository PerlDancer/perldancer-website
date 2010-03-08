#!/bin/sh

for pid in `ps fax | grep perldancer.pl | grep -v grep |  awk '{print $1}'`
do 
    echo "killing $pid..." 
    kill $pid
done 

./perldancer.pl --daemon --port 5001 --environment production 
./perldancer.pl --daemon --port 5002 --environment production 
./perldancer.pl --daemon --port 5003 --environment production 
