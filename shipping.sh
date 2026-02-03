#!/bin/bash

source ./common.sh
app_name=shipping

check_root
app_setup
java_setup
systemd_setup

dnf install mysql -y 
VALIDATE $? "installing mysql client"

if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOGS_FILE
    VALIDATE $? "loading the schema,app data and master data for shipping application"
else
   echo -e "Data already available....$Y skipping $N"
fi

app_restart
print_total_time