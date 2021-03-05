#!/bin/bash


distros=(git vagrant ansible python pip)

for i in "${distros[@]}"
do
    echo $i
if ! [ -x "$(command -v $i)" ]; then
echo "Error: $i is not installed." >&2
else 
echo "OK : $i is installed." >&2
fi
done