#!/bin/bash

source ./common.sh
app_name=mysql

check_root

dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$LOGS_FILE
systemctl start mysqld &>>$LOGS_FILE
VALIDATE $? "enable and start mysql"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "setup root password"

print_total_time