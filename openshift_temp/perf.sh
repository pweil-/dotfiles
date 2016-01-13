#!/bin/bash

count=$1
rate=$2

if [ "${count}" == "" ]; then
  echo "count is required"
  exit 1
fi

for i in $(seq 1 $count); do
  id=$(cat /dev/urandom | tr -cd 'a-f0-0' | head -c 8)
  name="project-${id}"
  /usr/bin/time -f "${i},%e" bash -c "openshift cli new-project $name >/dev/null"
  if [ "${rate}" != "" ]; then
    sleep $rate
  fi
done
