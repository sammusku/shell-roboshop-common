#!/bin/bash

source ./common.sh

app_name=redis

check_root


dnf module disable redis -y
dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "enable redis 7"

dnf install redis -y &>>$LOGS_FILE
VALIDATE $? "install redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no'  /etc/redis/redis.conf
VALIDATE $? "Allowing remote connection"

systemctl enable redis &>>$LOGS_FILE
systemctl start redis  &>>$LOGS_FILE
VALIDATE $? "enable and start redis"

print_total_time
