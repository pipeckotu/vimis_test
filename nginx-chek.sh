#!/bin/bash
UP=$(netstat -tulpn | grep :80 | grep dockerd | wc -l);
if [ "$UP" -ne 1 ];
then
#        sudo service nginx start
        echo "Webserver Is DOWN";
else
        echo "Webserver Is UP";
fi
