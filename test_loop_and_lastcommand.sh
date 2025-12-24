#!/bin/bash

#set FILES
FILES=$(ls)
for FILE in ${FILES} 
do
  echo ${FILE}
  echo $?
done
