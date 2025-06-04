#!/bin/bash
 UP=$(docker ps |grep healthy |wc -l);
  if [ "$UP" -ne 1 ];
    then
      echo "Nginx Service Is DOWN";
    else
      echo "Nginx Service Is UP";
    fi
