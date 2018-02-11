#!/bin/bash

for i in 1 2 3 4
do
    echo $(cat output.txt | grep "READER $i" | wc -l)
done

for i in 1 2
do
    echo $(cat output.txt | grep "WRITER $i" | wc -l)
done