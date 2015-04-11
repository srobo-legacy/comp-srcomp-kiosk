#!/bin/bash

if [ "$#" != 1 ]; then
  echo >&2 "Deploys srcomp-kiosk to hostnames given in filename"
  echo >&2 "Usage: $0 <filename>"
  exit 1
fi

filename="$1"

while read -r line; do
  ssh pi@"$line" 'cd srcomp-kiosk; git pull; sudo ./deploy.sh'
done < "$filename"
