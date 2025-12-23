#!/bin/bash
FILES=$(ls)
for FILE in ${FILES} 
do
  echo ${FILE}
  echo $?
done
