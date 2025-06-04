#!/bin/bash
for run in {1..5}; do
 UP=$(curl -I http://10.15.25.55 -s |grep HTTP |grep 200 |wc -l);
  if [ "$UP" -ne 1 ];
    then
      echo "Webserver Is DOWN";
    else
      echo "Webserver Is UP";
    fi
  sleep 5s
done
