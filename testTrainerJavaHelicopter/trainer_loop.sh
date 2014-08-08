#!/bin/sh
# Script to run the trainer ad infinitum

counter=1
while :
do
    echo "Starting RL-Glue for iteration ${counter}"
    bash run.bash
    counter=`expr ${counter} + 1`
done
