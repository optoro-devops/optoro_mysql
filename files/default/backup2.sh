#!/bin/bash

#Are we running on slave?
OUTPUT=$(mysql -u root -pmaster -e "show slave status\G" | awk -F":" '/Slave_SQL_Running/ { print $2 }' | tr -d ' ')

if [ -n "$OUTPUT" ]; then #get a syntax error when $OUTPUT is empty
  if [ $OUTPUT == "Yes" ]; then  #Back it up!
    /opt/chef/embedded/bin/backup perform --trigger rotation --root-path /var/optoro/backup
  fi
fi
