#!/bin/bash
for run in {1..13}; do
UP=$(netstat -tulpn | grep :80 | grep dockerd | wc -l);
if [ "$UP" -ne 1 ];
then
#        sudo service nginx start
        echo "Webserver Is DOWN";
else
        echo "Webserver Is UP";
fi
sleep 5s
done
