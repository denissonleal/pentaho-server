#!/bin/bash

PENTAHO_SERVER="/opt/pentaho/server/pentaho-server"

bash $PENTAHO_SERVER/start-pentaho.sh
sleep 60
tail -f $PENTAHO_SERVER/tomcat/logs/*.log
