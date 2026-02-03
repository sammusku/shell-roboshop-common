#!/bin/bash

source ./common.sh
check_root
app_name=catalogue
nodejs_setup
systemd_setup

#Load data into mongodb

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOGS_FILE
dnf install mongodb-mongosh -y &>>$LOGS_FILE

INDEX=$(mongosh --host "$MONGODB_HOST" --quiet \
  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -eq -1 ]; then
   mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOGS_FILE
   VALIDATE $? "products loading"
else 
   echo -e "products already loaded ---$Y skipping $N "
fi

app_restart
print_total_time