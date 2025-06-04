#!/bin/bash
 d=$(dirname $0)
  docker stack deploy -c docker-test.yml test --detach=false
 sleep 5s
  . ${d}/nginx-chek.sh
