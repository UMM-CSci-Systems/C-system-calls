#!/bin/bash

num_directories=`find $1 -type d | wc -l | xargs`
num_files=`find $1 -type f | wc -l | xargs`

echo "There were $num_directories directories."
echo "There were $num_files regular files."
